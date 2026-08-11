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
  // --- État factice, simule ce que le GameBloc/socket fournira plus tard ---
  List<CardModel> _hand = const [
    CardModel(id: 'c1', rank: 'K', suit: '♥', hidden: false),
    CardModel(id: 'c2', hidden: true),
    CardModel(id: 'c3', hidden: true),
    CardModel(id: 'c4', rank: '7', suit: '♠', hidden: false),
  ];
  CardModel? _discardTop = const CardModel(id: 'd1', rank: '9', suit: '♦', hidden: false);
  int _drawPileCount = 38;
  bool _isMyTurn = true;

  final _random = Random();
  static const _ranks = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'];
  static const _suits = ['♠', '♥', '♦', '♣'];

  /// Simule `turn:draw` : en vrai, ceci émettrait DrawCardDto et
  /// attendrait la réponse serveur via le socket.
  Future<CardModel> _simulateDraw() async {
    await Future.delayed(const Duration(milliseconds: 500)); // latence réseau simulée
    final rank = _ranks[_random.nextInt(_ranks.length)];
    final suit = _suits[_random.nextInt(_suits.length)];
    setState(() => _drawPileCount--);
    return CardModel(id: 'drawn_${DateTime.now().microsecondsSinceEpoch}', rank: rank, suit: suit, hidden: false);
  }

  /// Simule `turn:swap` : la carte piochée prend la place en main, l'ancienne
  /// carte de la main part en défausse (révélée, comme le fait le vrai backend).
  void _simulateSwap(CardModel drawnCard, int handPosition) {
    setState(() {
      final oldCard = _hand[handPosition];
      final newHand = List<CardModel>.from(_hand);
      newHand[handPosition] = drawnCard;
      _hand = newHand;
      _discardTop = oldCard.copyWith(hidden: false); // révélée en défausse
      _isMyTurn = false; // fin de tour
    });
    debugPrint('SwapCardDto: drawnCardId=${drawnCard.id}, handPosition=$handPosition');
  }

  /// Simule `turn:discard`.
  void _simulateDiscard(CardModel drawnCard, {required bool usePower}) {
    setState(() {
      _discardTop = drawnCard;
      _isMyTurn = false; // fin de tour
    });
    debugPrint('DiscardCardDto: drawnCardId=${drawnCard.id}, usePower=$usePower');
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
                onDrawCard: _simulateDraw,
                onSwapCard: _simulateSwap,
                onDiscardCard: _simulateDiscard,
              ),
              // Bouton de debug pour redonner la main au joueur local
              // (en vrai, ça viendrait de turn:started envoyé par le serveur).
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