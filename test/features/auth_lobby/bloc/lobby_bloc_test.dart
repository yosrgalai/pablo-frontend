import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:frontend_pablo/core/network/api_client.dart';
import 'package:frontend_pablo/data/models/player_model.dart';
import 'package:frontend_pablo/data/repositories/game_repository.dart';
import 'package:frontend_pablo/features/auth_lobby/bloc/lobby_bloc.dart';

class MockGameRepository extends Mock implements GameRepository {}

void main() {
  late MockGameRepository repo;

  // Joueurs bruts tels que renvoyés par GameSnapshot (isHost calculé en
  // interne par le repository à partir de hostPlayerId — ici on construit
  // directement le GameSnapshot déjà résolu, donc on le met à la main).
  PlayerModel host() => const PlayerModel(
        id: 'host-1',
        name: 'Maryem',
        isHost: true,
        handSize: 0,
        isConnected: false,
        isCurrentTurn: false,
      );

  PlayerModel guest() => const PlayerModel(
        id: 'guest-1',
        name: 'Yossr',
        isHost: false,
        handSize: 0,
        isConnected: false,
        isCurrentTurn: false,
      );

  setUpAll(() {
    // Fallback nécessaire pour les matchers `any(named: ...)` sur des
    // types non primitifs utilisés dans les stubs ci-dessous.
    registerFallbackValue(<int>[]);
  });

  setUp(() {
    repo = MockGameRepository();
    // Streams par défaut : vides, sauf override explicite dans un test.
    when(() => repo.onGameDealt).thenAnswer((_) => const Stream.empty());
    when(() => repo.onError).thenAnswer((_) => const Stream.empty());
  });

  group('LobbyCreateRequested', () {
    blocTest<LobbyBloc, LobbyState>(
      'émet [LobbyConnecting, LobbyRoomJoined] quand createGame + connectToRoom réussissent',
      build: () {
        when(() => repo.createGame(scoreLimit: any(named: 'scoreLimit')))
            .thenAnswer((_) async => GameSnapshot(
                  gameId: 'game-1',
                  scoreLimit: 100,
                  state: 'LOBBY',
                  hostPlayerId: 'host-1',
                  players: [host()],
                ));
        when(() => repo.connectToRoom(
              gameId: any(named: 'gameId'),
              playerId: any(named: 'playerId'),
            )).thenAnswer((_) async {});
        return LobbyBloc(repo);
      },
      act: (bloc) => bloc.add(const LobbyCreateRequested(scoreLimit: 100)),
      expect: () => [
        isA<LobbyConnecting>(),
        isA<LobbyRoomJoined>()
            .having((s) => s.gameId, 'gameId', 'game-1')
            .having((s) => s.localPlayerId, 'localPlayerId', 'host-1')
            .having((s) => s.isHost, 'isHost', true)
            .having((s) => s.players.first.isConnected, 'host isConnected', true),
      ],
    );

    blocTest<LobbyBloc, LobbyState>(
      'émet [LobbyConnecting, LobbyError] quand createGame échoue (ApiException)',
      build: () {
        when(() => repo.createGame(scoreLimit: any(named: 'scoreLimit')))
            .thenThrow(ApiException(409, 'scoreLimit invalide'));
        return LobbyBloc(repo);
      },
      act: (bloc) => bloc.add(const LobbyCreateRequested(scoreLimit: 999)),
      expect: () => [
        isA<LobbyConnecting>(),
        isA<LobbyError>().having((s) => s.message, 'message', 'scoreLimit invalide'),
      ],
    );

    blocTest<LobbyBloc, LobbyState>(
      'émet LobbyError si connectToRoom time-out après un createGame réussi',
      build: () {
        when(() => repo.createGame(scoreLimit: any(named: 'scoreLimit')))
            .thenAnswer((_) async => GameSnapshot(
                  gameId: 'game-1',
                  scoreLimit: 100,
                  state: 'LOBBY',
                  hostPlayerId: 'host-1',
                  players: [host()],
                ));
        when(() => repo.connectToRoom(
              gameId: any(named: 'gameId'),
              playerId: any(named: 'playerId'),
            )).thenThrow(Exception('TimeoutException'));
        return LobbyBloc(repo);
      },
      act: (bloc) => bloc.add(const LobbyCreateRequested(scoreLimit: 100)),
      expect: () => [
        isA<LobbyConnecting>(),
        isA<LobbyError>(),
      ],
    );
  });

  group('LobbyJoinRequested', () {
    blocTest<LobbyBloc, LobbyState>(
      'émet LobbyRoomJoined avec isHost=false pour un joueur qui rejoint',
      build: () {
        when(() => repo.joinGame(gameId: any(named: 'gameId')))
            .thenAnswer((_) async => (
                  'guest-1',
                  GameSnapshot(
                    gameId: 'game-1',
                    scoreLimit: 100,
                    state: 'LOBBY',
                    hostPlayerId: 'host-1',
                    players: [host(), guest()],
                  ),
                ));
        when(() => repo.connectToRoom(
              gameId: any(named: 'gameId'),
              playerId: any(named: 'playerId'),
            )).thenAnswer((_) async {});
        return LobbyBloc(repo);
      },
      act: (bloc) => bloc.add(const LobbyJoinRequested(gameId: 'game-1')),
      expect: () => [
        isA<LobbyConnecting>(),
        isA<LobbyRoomJoined>()
            .having((s) => s.localPlayerId, 'localPlayerId', 'guest-1')
            .having((s) => s.isHost, 'isHost', false)
            .having((s) => s.players.length, 'players.length', 2),
      ],
    );
  });

  group('Events internes (socket)', () {
    final seedRoom = LobbyRoomJoined(
      gameId: 'game-1',
      scoreLimit: 100,
      hostPlayerId: 'host-1',
      localPlayerId: 'host-1',
      players: [host().copyWith(isConnected: true), guest()],
    );

    blocTest<LobbyBloc, LobbyState>(
      'LobbyGameDealtReceived transforme LobbyRoomJoined en LobbyGameStarting',
      build: () => LobbyBloc(repo),
      seed: () => seedRoom,
      act: (bloc) => bloc.add(const LobbyGameDealtReceived()),
      expect: () => [
        isA<LobbyGameStarting>()
            .having((s) => s.gameId, 'gameId', 'game-1')
            .having((s) => s.localPlayerId, 'localPlayerId', 'host-1'),
      ],
    );

    blocTest<LobbyBloc, LobbyState>(
      'LobbySocketErrorReceived attache un transientError sans quitter la room',
      build: () => LobbyBloc(repo),
      seed: () => seedRoom,
      act: (bloc) => bloc.add(const LobbySocketErrorReceived('Partie complète.')),
      expect: () => [
        isA<LobbyRoomJoined>()
            .having((s) => s.transientError, 'transientError', 'Partie complète.')
            .having((s) => s.gameId, 'gameId (inchangé)', 'game-1'),
      ],
    );

    blocTest<LobbyBloc, LobbyState>(
      'LobbyLeftRequested ramène à LobbyInitial',
      build: () => LobbyBloc(repo),
      seed: () => seedRoom,
      act: (bloc) => bloc.add(const LobbyLeftRequested()),
      expect: () => [isA<LobbyInitial>()],
    );
  });

  group('LobbyRoomJoined — getters', () {
    test('isHost / connectedCount / canStart reflètent la liste de joueurs', () {
      final state = LobbyRoomJoined(
        gameId: 'g',
        scoreLimit: 100,
        hostPlayerId: 'host-1',
        localPlayerId: 'host-1',
        players: [
          host().copyWith(isConnected: true),
          guest().copyWith(isConnected: false),
        ],
      );

      expect(state.isHost, isTrue);
      expect(state.connectedCount, 1);
      expect(state.canStart, isFalse); // il faut ≥2 connectés (doc backend)
    });

    test('canStart passe à true dès que 2 joueurs sont connectés', () {
      final state = LobbyRoomJoined(
        gameId: 'g',
        scoreLimit: 100,
        hostPlayerId: 'host-1',
        localPlayerId: 'host-1',
        players: [
          host().copyWith(isConnected: true),
          guest().copyWith(isConnected: true),
        ],
      );

      expect(state.canStart, isTrue);
    });
  });
}