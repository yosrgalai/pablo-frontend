import 'dart:math';

import 'package:flutter/material.dart';

import 'data/models/card_model.dart';
import 'data/models/game_round_state.dart';
import 'data/models/player_model.dart';
import 'data/models/round_model.dart';
import 'features/game/widgets/game_turn_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const TestApp());
}

class TestApp extends StatefulWidget {
  const TestApp({super.key});

  @override
  State<TestApp> createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  bool _needsInitialPeek = true;

  // --- "Vérité serveur" (jamais transmise telle quelle à CardWidget) ---
  late List<CardModel> _trueHand;
  List<CardModel> _hand = const [];

  // --- Vérité serveur des adversaires (juste pour simuler pouvoirs 8/9 ---
  // en vrai, ceci vit uniquement en base côté backend, jamais côté client,
  // même caché : c'est notre app qui doit jouer ce rôle ici faute de serveur.
  final Map<String, List<CardModel>> _opponentTrueHands = {
    'p1': List.generate(4, (_) => _staticRandomCard()),
    'p2': List.generate(3, (_) => _staticRandomCard()),
    'p3': List.generate(5, (_) => _staticRandomCard()),
  };

  CardModel? _discardTop;
  int _drawPileCount = 38;
  bool _isMyTurn = true;

  static final _random = Random();
  static const _ranks = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'];
  static const _suits = ['♠', '♥', '♦', '♣'];

  static CardModel _staticRandomCard() {
    final rank = _ranks[_random.nextInt(_ranks.length)];
    final suit = _suits[_random.nextInt(_suits.length)];
    return CardModel(
      id: 'card_${DateTime.now().microsecondsSinceEpoch}_${_random.nextInt(9999)}',
      rank: rank,
      suit: suit,
      hidden: false,
    );
  }

  @override
  void initState() {
    super.initState();
    _trueHand = List.generate(4, (_) => _staticRandomCard());
    _hand = List.generate(4, (i) => CardModel(id: _trueHand[i].id, hidden: true));
    _discardTop = _staticRandomCard();
  }

  CardModel _randomCard({bool hidden = false, String? id}) {
    final rank = _ranks[_random.nextInt(_ranks.length)];
    final suit = _suits[_random.nextInt(_suits.length)];
    return CardModel(
      id: id ?? 'card_${DateTime.now().microsecondsSinceEpoch}_${_random.nextInt(9999)}',
      rank: rank,
      suit: suit,
      hidden: hidden,
    );
  }

  // --- INITIAL_PEEK ---

  Future<void> _simulateChooseInitialPeek(List<int> positions) async {
    await Future.delayed(const Duration(milliseconds: 400));
    setState(() {
      final newHand = List<CardModel>.from(_hand);
      for (final p in positions) {
        newHand[p] = _trueHand[p].copyWith(hidden: false);
      }
      _hand = newHand;
    });
  }

  void _handlePeekComplete() {
    setState(() {
      _hand = List.generate(4, (i) => CardModel(id: _trueHand[i].id, hidden: true));
      _needsInitialPeek = false;
    });
  }

  // --- Piocher / échanger / défausser ---

  Future<CardModel> _simulateDraw() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _drawPileCount--);
    return _randomCard();
  }

  void _simulateSwap(CardModel drawnCard, int handPosition) {
    setState(() {
      final revealedOldCard = _trueHand[handPosition].copyWith(hidden: false);

      final newTrueHand = List<CardModel>.from(_trueHand);
      newTrueHand[handPosition] = drawnCard;
      _trueHand = newTrueHand;

      final newHand = List<CardModel>.from(_hand);
      newHand[handPosition] = CardModel(id: drawnCard.id, hidden: true);
      _hand = newHand;

      _discardTop = revealedOldCard;
      _isMyTurn = false;
    });
    debugPrint('SwapCardDto: drawnCardId=${drawnCard.id}, handPosition=$handPosition');
  }

  void _simulateDiscard(CardModel drawnCard, {required bool usePower}) {
    setState(() => _discardTop = drawnCard);
    // NB : le tour ne se termine plus ici si un pouvoir est activé — c'est
    // GameTurnController qui gère la suite (sous-état AWAITING_POWER_TARGET).
    // En vrai, c'est le serveur qui décide quand renvoyer turn:started au
    // joueur suivant, une fois le pouvoir résolu (ou le timeout écoulé).
    if (!usePower || !drawnCard.hasPower) {
      setState(() => _isMyTurn = false);
    }
    debugPrint('DiscardCardDto: drawnCardId=${drawnCard.id}, usePower=$usePower');
  }

  // --- Défausser une paire ---

  Future<bool> _simulatePairAttempt(int firstPosition, int secondPosition) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final cardA = _trueHand[firstPosition];
    final cardB = _trueHand[secondPosition];
    final success = cardA.rank == cardB.rank;

    setState(() {
      if (success) {
        _discardTop = cardB.copyWith(hidden: false);
        final hi = max(firstPosition, secondPosition);
        final lo = min(firstPosition, secondPosition);
        _trueHand = List<CardModel>.from(_trueHand)..removeAt(hi)..removeAt(lo);
        _hand = List<CardModel>.from(_hand)..removeAt(hi)..removeAt(lo);
      } else {
        final penalty = _randomCard(hidden: true);
        _trueHand = List<CardModel>.from(_trueHand)..add(penalty);
        _hand = List<CardModel>.from(_hand)..add(CardModel(id: penalty.id, hidden: true));
      }
      _isMyTurn = false;
    });

    debugPrint(
      'PairAttemptDto: firstPosition=$firstPosition, secondPosition=$secondPosition -> success=$success',
    );
    return success;
  }

  // --- Pouvoirs ---

  /// Pouvoir 7 : révèle une de ses propres cartes, temporairement.
  Future<CardModel> _simulatePowerSelfPeek(int ownPosition) async {
    await Future.delayed(const Duration(milliseconds: 400));
    setState(() => _isMyTurn = false); // le tour se termine une fois le pouvoir résolu
    return _trueHand[ownPosition].copyWith(hidden: false);
  }

  /// Pouvoir 8 : révèle une carte d'un adversaire, temporairement.
  Future<CardModel> _simulatePowerSpy(String opponentId, int opponentPosition) async {
    await Future.delayed(const Duration(milliseconds: 400));
    setState(() => _isMyTurn = false);
    final trueHand = _opponentTrueHands[opponentId]!;
    return trueHand[opponentPosition].copyWith(hidden: false);
  }

  /// Pouvoir 9 : échange une carte à soi avec une carte adverse, SANS
  /// révéler aucune des deux. Met à jour les 2 "vérités" en conséquence.
  Future<void> _simulatePowerBlindSwap(
    int ownPosition,
    String opponentId,
    int opponentPosition,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));

    setState(() {
      final opponentTrueHand = List<CardModel>.from(_opponentTrueHands[opponentId]!);
      final myCard = _trueHand[ownPosition];
      final opponentCard = opponentTrueHand[opponentPosition];

      final newTrueHand = List<CardModel>.from(_trueHand);
      newTrueHand[ownPosition] = opponentCard.copyWith(hidden: true);
      _trueHand = newTrueHand;

      opponentTrueHand[opponentPosition] = myCard.copyWith(hidden: true);
      _opponentTrueHands[opponentId] = opponentTrueHand;

      // La vue client de cette position reste cachée (nouvel id, même état
      // "hidden" qu'avant — ni l'un ni l'autre joueur ne voit la valeur).
      final newHand = List<CardModel>.from(_hand);
      newHand[ownPosition] = CardModel(id: opponentCard.id, hidden: true);
      _hand = newHand;

      _isMyTurn = false;
    });

    debugPrint(
      'PowerTargetDto: powerRank=9, ownPosition=$ownPosition, '
      'opponentId=$opponentId, opponentPosition=$opponentPosition',
    );
  }

  @override
  Widget build(BuildContext context) {
    final localPlayer = PlayerModel(
      id: 'me',
      name: 'Moi',
      handSize: _hand.length,
      isConnected: true,
      isCurrentTurn: _isMyTurn,
      hand: _hand,
    );

    final opponents = [
      PlayerModel(
        id: 'p1',
        name: 'Yosr',
        handSize: _opponentTrueHands['p1']!.length,
        isConnected: true,
        isCurrentTurn: false,
      ),
      PlayerModel(
        id: 'p2',
        name: 'Ali',
        handSize: _opponentTrueHands['p2']!.length,
        isConnected: false,
        isCurrentTurn: false,
      ),
      PlayerModel(
        id: 'p3',
        name: 'Nour',
        handSize: _opponentTrueHands['p3']!.length,
        isConnected: true,
        isCurrentTurn: false,
        hasCalledPablo: true,
      ),
    ];

    final round = RoundModel(
      roundNumber: 1,
      drawPileCount: _drawPileCount,
      discardTop: _discardTop,
      state: GameRoundState.playerTurn,
    );

    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF0B6B4F),
        body: SafeArea(
          child: Stack(
            children: [
              GameTurnController(
                localPlayer: localPlayer,
                opponents: opponents,
                round: round,
                needsInitialPeek: _needsInitialPeek,
                onConfirmPeek: _simulateChooseInitialPeek,
                onPeekComplete: _handlePeekComplete,
                onDrawCard: _simulateDraw,
                onSwapCard: _simulateSwap,
                onDiscardCard: _simulateDiscard,
                onPairAttempt: _simulatePairAttempt,
                onPowerSelfPeek: _simulatePowerSelfPeek,
                onPowerSpy: _simulatePowerSpy,
                onPowerBlindSwap: _simulatePowerBlindSwap,
              ),
              Positioned(
                top: 8,
                left: 8,
                child: ElevatedButton(
                  onPressed: () => setState(() => _isMyTurn = true),
                  child: const Text('DEBUG: redonner mon tour'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
import 'app.dart';
import 'core/di/injector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // NOTE pour la binôme : ton TestApp verrouillait l'orientation en
  // paysage dès main(). Je l'ai retiré ici car ça casserait les écrans de
  // lobby/login (portrait, cf. maquette El Bat7a). Le verrouillage paysage
  // doit plutôt être local à game_table_screen (initState() -> lock,
  // dispose() -> reset). Je le laisse en commentaire pour référence :
  //
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.landscapeLeft,
  //   DeviceOrientation.landscapeRight,
  // ]);

  // Racine REST du backend (routes /auth, /games...).
  // - Web / iOS simulator : localhost fonctionne tel quel.
  // - Émulateur Android : remplace par 10.0.2.2.
  // - Appareil physique : IP locale de ta machine (ex: 192.168.x.x).
  const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  // ⚠️ Le GameGateway déclare namespace: '/game' côté serveur — le
  // suffixe est obligatoire, sinon le socket se connecte au namespace
  // par défaut où aucun handler n'existe.
  const socketUrl = String.fromEnvironment(
    'SOCKET_URL',
    defaultValue: 'http://localhost:3000/game',
  );

  setupInjector(apiBaseUrl: apiBaseUrl, socketUrl: socketUrl);

  runApp(const PabloApp());
}