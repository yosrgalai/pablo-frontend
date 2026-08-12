import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  // Simule ce qui vivrait en base côté backend. Notre app joue les deux
  // rôles (serveur ET client) pour l'instant, donc on sépare nous-mêmes
  // pour ne jamais transmettre à `_hand` (vue client) une valeur que le
  // joueur n'est pas censé connaître (doc 01 §3).
  late List<CardModel> _trueHand;

  // --- Vue client : c'est CE QUE CardWidget reçoit et affiche ---
  late List<CardModel> _hand;

  CardModel? _discardTop;
  int _drawPileCount = 38;
  bool _isMyTurn = true;

  final _random = Random();
  static const _ranks = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'];
  static const _suits = ['♠', '♥', '♦', '♣'];

  @override
  void initState() {
    super.initState();
    _trueHand = List.generate(4, (_) => _randomCard());
    // Tout est caché au départ : c'est justement le but du mode de
    // sélection INITIAL_PEEK que de laisser le joueur choisir quoi voir.
    _hand = List.generate(4, (i) => CardModel(id: _trueHand[i].id, hidden: true));
    _discardTop = _randomCard();
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

  /// Simule `ChooseInitialPeekDto` -> `player:peeked_initial`.
  /// Révèle immédiatement les 2 cartes choisies dans `_hand` (vue client).
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

  /// Fenêtre de révélation terminée : tout redevient caché, le jeu commence.
  void _handlePeekComplete() {
    setState(() {
      _hand = List.generate(4, (i) => CardModel(id: _trueHand[i].id, hidden: true));
      _needsInitialPeek = false;
    });
  }

  /// Simule `turn:draw`.
  Future<CardModel> _simulateDraw() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _drawPileCount--);
    return _randomCard();
  }

  /// Simule `turn:swap`. La carte piochée entre en main mais REDEVIENT
  /// cachée (le joueur la connaît de mémoire, pas via l'app).
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

  /// Simule `turn:discard` (défausse directe, pas d'échange).
  void _simulateDiscard(CardModel drawnCard, {required bool usePower}) {
    setState(() {
      _discardTop = drawnCard;
      _isMyTurn = false;
    });
    debugPrint('DiscardCardDto: drawnCardId=${drawnCard.id}, usePower=$usePower');
  }

  /// Simule `turn:discard_pair`. Le succès/échec se calcule TOUJOURS sur
  /// `_trueHand` (la vérité), jamais sur `_hand` — comme le vrai backend.
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

    const opponents = [
      PlayerModel(id: 'p1', name: 'Yosr', handSize: 4, isConnected: true, isCurrentTurn: false),
      PlayerModel(id: 'p2', name: 'Ali', handSize: 3, isConnected: false, isCurrentTurn: false),
      PlayerModel(id: 'p3', name: 'Nour', handSize: 5, isConnected: true, isCurrentTurn: false, hasCalledPablo: true),
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
}