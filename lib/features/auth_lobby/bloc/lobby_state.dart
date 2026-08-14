part of 'lobby_bloc.dart';

abstract class LobbyState extends Equatable {
  const LobbyState();
  @override
  List<Object?> get props => [];
}

class LobbyInitial extends LobbyState {
  const LobbyInitial();
}

class LobbyConnecting extends LobbyState {
  const LobbyConnecting();
}

class LobbyError extends LobbyState {
  final String message;
  const LobbyError(this.message);
  @override
  List<Object?> get props => [message];
}

/// Dans la salle d'attente. [transientError] porte un message d'erreur
/// ponctuel (ex: "pas assez de joueurs connectés") sans quitter la room —
/// à afficher une fois (snackbar) puis ignorer.
class LobbyRoomJoined extends LobbyState {
  final String gameId;
  final int scoreLimit;
  final String? hostPlayerId;
  final String localPlayerId;
  final List<PlayerModel> players;
  final String? transientError;

  const LobbyRoomJoined({
    required this.gameId,
    required this.scoreLimit,
    required this.hostPlayerId,
    required this.localPlayerId,
    required this.players,
    this.transientError,
  });

  bool get isHost => hostPlayerId != null && hostPlayerId == localPlayerId;
  int get connectedCount => players.where((p) => p.isConnected).length;
  bool get canStart => connectedCount >= 2;

  LobbyRoomJoined copyWith({
    List<PlayerModel>? players,
    String? transientError,
    bool clearTransientError = false,
  }) {
    return LobbyRoomJoined(
      gameId: gameId,
      scoreLimit: scoreLimit,
      hostPlayerId: hostPlayerId,
      localPlayerId: localPlayerId,
      players: players ?? this.players,
      transientError:
          clearTransientError ? null : (transientError ?? this.transientError),
    );
  }

  @override
  List<Object?> get props =>
      [gameId, scoreLimit, hostPlayerId, localPlayerId, players, transientError];
}

class LobbyGameStarting extends LobbyState {
  final String gameId;
  final String localPlayerId;
  const LobbyGameStarting(this.gameId, this.localPlayerId);
  @override
  List<Object?> get props => [gameId, localPlayerId];
}