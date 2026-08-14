import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/network/api_client.dart';
import '../../../data/models/player_model.dart';
import '../../../data/repositories/game_repository.dart';

part 'lobby_event.dart';
part 'lobby_state.dart';

class LobbyBloc extends Bloc<LobbyEvent, LobbyState> {
  final GameRepository _gameRepository;

  StreamSubscription<void>? _gameDealtSub;
  StreamSubscription<String>? _errorSub;
  Timer? _pollTimer;

  LobbyBloc(this._gameRepository) : super(const LobbyInitial()) {
    on<LobbyCreateRequested>(_onCreateRequested);
    on<LobbyJoinRequested>(_onJoinRequested);
    on<LobbyStartGamePressed>(_onStartGamePressed);
    on<LobbyLeftRequested>(_onLeftRequested);
    on<LobbyGameDealtReceived>(_onGameDealtReceived);
    on<LobbySocketErrorReceived>(_onSocketErrorReceived);
    on<LobbyPollRequested>(_onPollRequested);
  }

  Future<void> _onCreateRequested(
    LobbyCreateRequested event,
    Emitter<LobbyState> emit,
  ) async {
    emit(const LobbyConnecting());
    try {
      final snapshot = await _gameRepository.createGame(scoreLimit: event.scoreLimit);
      final localPlayerId = snapshot.hostPlayerId ?? '';

      await _gameRepository.connectToRoom(
        gameId: snapshot.gameId,
        playerId: localPlayerId,
      );
      _listenToSocketStreams();
      _startPolling();

      emit(LobbyRoomJoined(
        gameId: snapshot.gameId,
        scoreLimit: snapshot.scoreLimit,
        hostPlayerId: snapshot.hostPlayerId,
        localPlayerId: localPlayerId,
        players: _markConnected(snapshot.players, localPlayerId),
      ));
    } catch (e) {
      emit(LobbyError(_friendlyError(e)));
    }
  }

  Future<void> _onJoinRequested(
    LobbyJoinRequested event,
    Emitter<LobbyState> emit,
  ) async {
    emit(const LobbyConnecting());
    try {
      final (playerId, snapshot) =
          await _gameRepository.joinGame(gameId: event.gameId);

      await _gameRepository.connectToRoom(
        gameId: snapshot.gameId,
        playerId: playerId,
      );
      _listenToSocketStreams();
      _startPolling();

      emit(LobbyRoomJoined(
        gameId: snapshot.gameId,
        scoreLimit: snapshot.scoreLimit,
        hostPlayerId: snapshot.hostPlayerId,
        localPlayerId: playerId,
        players: _markConnected(snapshot.players, playerId),
      ));
    } catch (e) {
      emit(LobbyError(_friendlyError(e)));
    }
  }

  void _onStartGamePressed(
    LobbyStartGamePressed event,
    Emitter<LobbyState> emit,
  ) {
    final current = state;
    if (current is LobbyRoomJoined && current.isHost) {
      _gameRepository.startGame(
        gameId: current.gameId,
        playerId: current.localPlayerId,
      );
    }
  }

  void _onLeftRequested(LobbyLeftRequested event, Emitter<LobbyState> emit) {
    _cancelSocketStreams();
    _stopPolling();
    emit(const LobbyInitial());
  }

  void _onGameDealtReceived(
    LobbyGameDealtReceived event,
    Emitter<LobbyState> emit,
  ) {
    final current = state;
    if (current is LobbyRoomJoined) {
      _stopPolling();
      emit(LobbyGameStarting(current.gameId, current.localPlayerId));
    }
  }

  Future<void> _onPollRequested(
    LobbyPollRequested event,
    Emitter<LobbyState> emit,
  ) async {
    final current = state;
    if (current is! LobbyRoomJoined) return;
    try {
      final snapshot = await _gameRepository.findOne(current.gameId);
      emit(current.copyWith(
        players: _markConnected(snapshot.players, current.localPlayerId),
      ));
    } catch (_) {
      // Échec de polling ponctuel : on ignore silencieusement, le prochain
      // tick réessaiera. Pas la peine de casser l'UI pour ça.
    }
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => add(const LobbyPollRequested()),
    );
  }

  void _stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  void _onSocketErrorReceived(
    LobbySocketErrorReceived event,
    Emitter<LobbyState> emit,
  ) {
    final current = state;
    if (current is LobbyRoomJoined) {
      emit(current.copyWith(transientError: event.message));
    }
  }

  /// Marque le joueur local comme connecté immédiatement après un
  /// connectToRoom réussi (le REST seul ne le sait pas encore côté
  /// snapshot initial, puisque isConnected ne passe à true qu'au moment
  /// du `join_game` socket).
  List<PlayerModel> _markConnected(List<PlayerModel> players, String playerId) {
    return players
        .map((p) => p.id == playerId ? p.copyWith(isConnected: true) : p)
        .toList();
  }

  void _listenToSocketStreams() {
    _cancelSocketStreams();
    _gameDealtSub = _gameRepository.onGameDealt
        .listen((_) => add(const LobbyGameDealtReceived()));
    _errorSub = _gameRepository.onError
        .listen((msg) => add(LobbySocketErrorReceived(msg)));
  }

  void _cancelSocketStreams() {
    _gameDealtSub?.cancel();
    _errorSub?.cancel();
  }

  String _friendlyError(Object e) {
    if (e is ApiException) return e.message;
    if (e.toString().contains('TimeoutException')) {
      return 'Le serveur ne répond pas. Vérifie ta connexion.';
    }
    return 'Une erreur est survenue. Réessaie.';
  }

  @override
  Future<void> close() {
    _cancelSocketStreams();
    _stopPolling();
    return super.close();
  }
}