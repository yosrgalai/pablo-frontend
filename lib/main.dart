import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data/models/card_model.dart';
import 'data/models/game_round_state.dart';
import 'data/models/player_model.dart';
import 'data/models/round_model.dart';
import 'features/game/widgets/game_table_layout.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Verrouille l'app en paysage. Sans ça, un joueur qui tourne son
  // téléphone casse tous les calculs de GameTableLayout (qui suppose
  // width > height pour choisir ses proportions).
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    // --- Données factices, juste pour valider le layout visuellement ---
    // TODO: à remplacer par le vrai flux (GameBloc + socket) une fois
    // l'étape 4 (interactions du tour) commencée.
    final localPlayer = const PlayerModel(
      id: 'me',
      name: 'Moi',
      handSize: 4,
      isConnected: true,
      isCurrentTurn: true,
      hand: [
        CardModel(id: 'c1', rank: 'K', suit: '♥', hidden: false),
        CardModel(id: 'c2', hidden: true),
        CardModel(id: 'c3', hidden: true),
        CardModel(id: 'c4', rank: '7', suit: '♠', hidden: false),
      ],
    );

    final opponents = const [
      PlayerModel(id: 'p1', name: 'Yosr', handSize: 4, isConnected: true, isCurrentTurn: false),
      PlayerModel(id: 'p2', name: 'Ali', handSize: 3, isConnected: false, isCurrentTurn: false),
      PlayerModel(id: 'p3', name: 'Nour', handSize: 5, isConnected: true, isCurrentTurn: false, hasCalledPablo: true),
    ];

    final round = const RoundModel(
      roundNumber: 1,
      drawPileCount: 38,
      discardTop: CardModel(id: 'd1', rank: '9', suit: '♦', hidden: false),
      state: GameRoundState.playerTurn,
    );

    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF0B6B4F),
        body: SafeArea(
          child: GameTableLayout(
            localPlayer: localPlayer,
            opponents: opponents,
            round: round,
            onDrawTap: () => debugPrint('draw tapped'),
            onDiscardTap: () => debugPrint('discard tapped'),
            onHandCardTap: (pos) => debugPrint('hand card $pos tapped'),
          ),
        ),
      ),
    );
  }
}
