import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:frontend_pablo/data/models/card_model.dart';
import 'package:frontend_pablo/data/repositories/game_repository.dart';
import 'package:frontend_pablo/features/game/bloc/game_bloc.dart';

class MockGameRepository extends Mock implements GameRepository {}

void main() {
  late MockGameRepository repo;

  const gameId = 'game-1';
  const localPlayerId = 'me';
  const otherPlayerId = 'other';

  List<CardModel> hiddenHand() => const [
        CardModel(id: 'c0', hidden: true),
        CardModel(id: 'c1', hidden: true),
        CardModel(id: 'c2', hidden: true),
        CardModel(id: 'c3', hidden: true),
      ];

  setUpAll(() {
    registerFallbackValue(<int>[]);
  });

  setUp(() {
    repo = MockGameRepository();
    when(() => repo.chooseInitialPeek(
          gameId: any(named: 'gameId'),
          playerId: any(named: 'playerId'),
          positions: any(named: 'positions'),
        )).thenReturn(null);
    when(() => repo.callPablo(
          gameId: any(named: 'gameId'),
          playerId: any(named: 'playerId'),
        )).thenReturn(null);
  });

  group('INITIAL_PEEK', () {
    blocTest<GameBloc, GameState>(
      'GameHandPositionsReceived en DEALING -> GameInitialPeekState avec les 4 positions',
      build: () => GameBloc(repo, gameId: gameId, localPlayerId: localPlayerId),
      act: (bloc) => bloc.add(GameHandPositionsReceived(hiddenHand())),
      expect: () => [
        isA<GameInitialPeekState>()
            .having((s) => s.positions.length, 'positions.length', 4)
            .having((s) => s.selected, 'selected', isEmpty)
            .having((s) => s.confirmed, 'confirmed', false),
      ],
    );

    blocTest<GameBloc, GameState>(
      'sélectionner 2 positions puis en toucher une 3e est ignoré',
      build: () => GameBloc(repo, gameId: gameId, localPlayerId: localPlayerId),
      seed: () => GameInitialPeekState(positions: hiddenHand()),
      act: (bloc) => bloc
        ..add(const GamePeekPositionToggled(0))
        ..add(const GamePeekPositionToggled(1))
        ..add(const GamePeekPositionToggled(2)), // ignoré : déjà 2 sélectionnées
      expect: () => [
        isA<GameInitialPeekState>().having((s) => s.selected, 'selected', {0}),
        isA<GameInitialPeekState>().having((s) => s.selected, 'selected', {0, 1}),
        // Le 3e toggle ne doit produire AUCUNE nouvelle émission utile ;
        // bloc renvoie quand même un state égal si l'implémentation
        // n'émet rien de neuf, donc on vérifie juste qu'on ne dépasse
        // jamais 2 sélections au final via le state courant.
      ],
      verify: (bloc) {
        final state = bloc.state as GameInitialPeekState;
        expect(state.selected, {0, 1});
        expect(state.selected.length, 2);
      },
    );

    blocTest<GameBloc, GameState>(
      'GameConfirmInitialPeekPressed avec 2 sélectionnées appelle le repository et verrouille confirmed',
      build: () => GameBloc(repo, gameId: gameId, localPlayerId: localPlayerId),
      seed: () => GameInitialPeekState(positions: hiddenHand(), selected: {2, 0}),
      act: (bloc) => bloc.add(const GameConfirmInitialPeekPressed()),
      expect: () => [
        isA<GameInitialPeekState>()
            .having((s) => s.confirmed, 'confirmed', true)
            .having((s) => s.selected, 'selected', {2, 0}),
      ],
      verify: (_) {
        verify(() => repo.chooseInitialPeek(
              gameId: gameId,
              playerId: localPlayerId,
              positions: [0, 2], // trié
            )).called(1);
      },
    );

    blocTest<GameBloc, GameState>(
      'GameConfirmInitialPeekPressed est ignoré si moins de 2 positions sélectionnées',
      build: () => GameBloc(repo, gameId: gameId, localPlayerId: localPlayerId),
      seed: () => GameInitialPeekState(positions: hiddenHand(), selected: {0}),
      act: (bloc) => bloc.add(const GameConfirmInitialPeekPressed()),
      expect: () => [],
      verify: (_) {
        verifyNever(() => repo.chooseInitialPeek(
              gameId: any(named: 'gameId'),
              playerId: any(named: 'playerId'),
              positions: any(named: 'positions'),
            ));
      },
    );

    blocTest<GameBloc, GameState>(
      'GamePeekedInitialReceived -> GameWaitingOthersPeekState',
      build: () => GameBloc(repo, gameId: gameId, localPlayerId: localPlayerId),
      seed: () => GameInitialPeekState(
        positions: hiddenHand(),
        selected: {0, 2},
        confirmed: true,
      ),
      act: (bloc) => bloc.add(GamePeekedInitialReceived(const [
        CardModel(id: 'c0', rank: 'K', suit: '♥', hidden: false),
        CardModel(id: 'c2', rank: '7', suit: '♠', hidden: false),
      ])),
      expect: () => [
        isA<GameWaitingOthersPeekState>()
            .having((s) => s.revealedCards.length, 'revealedCards.length', 2),
      ],
    );
  });

  group('PLAYER_TURN', () {
    blocTest<GameBloc, GameState>(
      'GameTurnStartedReceived depuis un autre state -> crée GamePlayerTurnState',
      build: () => GameBloc(repo, gameId: gameId, localPlayerId: localPlayerId),
      seed: () => const GameWaitingOthersPeekState([]),
      act: (bloc) => bloc.add(const GameTurnStartedReceived(otherPlayerId)),
      expect: () => [
        isA<GamePlayerTurnState>()
            .having((s) => s.currentPlayerId, 'currentPlayerId', otherPlayerId)
            .having((s) => s.isLocalTurn, 'isLocalTurn', false)
            .having((s) => s.pabloCalled, 'pabloCalled', false),
      ],
    );

    blocTest<GameBloc, GameState>(
      'GameTurnStartedReceived met à jour currentPlayerId sans perdre pabloCalled',
      build: () => GameBloc(repo, gameId: gameId, localPlayerId: localPlayerId),
      seed: () => const GamePlayerTurnState(
        currentPlayerId: otherPlayerId,
        localPlayerId: localPlayerId,
        pabloCalled: true,
        pabloCallerId: otherPlayerId,
      ),
      act: (bloc) => bloc.add(const GameTurnStartedReceived(localPlayerId)),
      expect: () => [
        isA<GamePlayerTurnState>()
            .having((s) => s.currentPlayerId, 'currentPlayerId', localPlayerId)
            .having((s) => s.isLocalTurn, 'isLocalTurn', true)
            .having((s) => s.pabloCalled, 'pabloCalled (préservé)', true),
      ],
    );

    blocTest<GameBloc, GameState>(
      'GameCallPabloPressed appelle le repository seulement si isLocalTurn',
      build: () => GameBloc(repo, gameId: gameId, localPlayerId: localPlayerId),
      seed: () => const GamePlayerTurnState(
        currentPlayerId: localPlayerId,
        localPlayerId: localPlayerId,
      ),
      act: (bloc) => bloc.add(const GameCallPabloPressed()),
      expect: () => [],
      verify: (_) {
        verify(() => repo.callPablo(gameId: gameId, playerId: localPlayerId)).called(1);
      },
    );

    blocTest<GameBloc, GameState>(
      "GameCallPabloPressed n'appelle PAS le repository si ce n'est pas notre tour",
      build: () => GameBloc(repo, gameId: gameId, localPlayerId: localPlayerId),
      seed: () => const GamePlayerTurnState(
        currentPlayerId: otherPlayerId,
        localPlayerId: localPlayerId,
      ),
      act: (bloc) => bloc.add(const GameCallPabloPressed()),
      expect: () => [],
      verify: (_) {
        verifyNever(() => repo.callPablo(
              gameId: any(named: 'gameId'),
              playerId: any(named: 'playerId'),
            ));
      },
    );

    blocTest<GameBloc, GameState>(
      'GameCaboCalledReceived marque pabloCalled sur le state courant',
      build: () => GameBloc(repo, gameId: gameId, localPlayerId: localPlayerId),
      seed: () => const GamePlayerTurnState(
        currentPlayerId: localPlayerId,
        localPlayerId: localPlayerId,
      ),
      act: (bloc) => bloc.add(const GameCaboCalledReceived(localPlayerId)),
      expect: () => [
        isA<GamePlayerTurnState>()
            .having((s) => s.pabloCalled, 'pabloCalled', true)
            .having((s) => s.pabloCallerId, 'pabloCallerId', localPlayerId),
      ],
    );
  });

  group('Fin de manche / fin de partie', () {
    blocTest<GameBloc, GameState>(
      'GameRoundEndedReceived -> GameRoundScoringState',
      build: () => GameBloc(repo, gameId: gameId, localPlayerId: localPlayerId),
      seed: () => const GamePlayerTurnState(
        currentPlayerId: localPlayerId,
        localPlayerId: localPlayerId,
      ),
      act: (bloc) => bloc.add(const GameRoundEndedReceived({
        'roundScores': {'me': 12, 'other': 30},
      })),
      expect: () => [
        isA<GameRoundScoringState>()
            .having((s) => s.payload['roundScores'], 'roundScores', {'me': 12, 'other': 30}),
      ],
    );

    blocTest<GameBloc, GameState>(
      'GameEndedReceived -> GameOverState',
      build: () => GameBloc(repo, gameId: gameId, localPlayerId: localPlayerId),
      act: (bloc) => bloc.add(const GameEndedReceived({
        'winner': {'id': 'me', 'name': 'Maryem', 'score': 42},
      })),
      expect: () => [
        isA<GameOverState>().having(
          (s) => (s.payload['winner'] as Map)['name'],
          'winner.name',
          'Maryem',
        ),
      ],
    );
  });
}