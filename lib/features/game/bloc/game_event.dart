part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();
  @override
  List<Object?> get props => [];
}

/// À déclencher une fois en entrant dans l'écran de jeu (après
/// LobbyGameStarting) : démarre l'écoute des events + demande les
/// positions de main en filet de sécurité.
class GameStarted extends GameEvent {
  const GameStarted();
}

class GameHandPositionsReceived extends GameEvent {
  final List<CardModel> positions;
  const GameHandPositionsReceived(this.positions);
  @override
  List<Object?> get props => [positions];
}

/// Le joueur tape une carte pendant INITIAL_PEEK pour la sélectionner
/// (max 2, cf. doc §3).
class GamePeekPositionToggled extends GameEvent {
  final int position;
  const GamePeekPositionToggled(this.position);
  @override
  List<Object?> get props => [position];
}

class GameConfirmInitialPeekPressed extends GameEvent {
  const GameConfirmInitialPeekPressed();
}

class GamePeekedInitialReceived extends GameEvent {
  final List<CardModel> revealedCards;
  const GamePeekedInitialReceived(this.revealedCards);
  @override
  List<Object?> get props => [revealedCards];
}

class GameTurnStartedReceived extends GameEvent {
  final String currentPlayerId;
  const GameTurnStartedReceived(this.currentPlayerId);
  @override
  List<Object?> get props => [currentPlayerId];
}

/// Bouton "Annoncer Pablo" (Dev A).
class GameCallPabloPressed extends GameEvent {
  const GameCallPabloPressed();
}

class GameCaboCalledReceived extends GameEvent {
  final String playerId;
  const GameCaboCalledReceived(this.playerId);
  @override
  List<Object?> get props => [playerId];
}

class GameRoundEndedReceived extends GameEvent {
  final Map<String, dynamic> payload;
  const GameRoundEndedReceived(this.payload);
  @override
  List<Object?> get props => [payload];
}

class GameEndedReceived extends GameEvent {
  final Map<String, dynamic> payload;
  const GameEndedReceived(this.payload);
  @override
  List<Object?> get props => [payload];
}

class GameSocketErrorReceived extends GameEvent {
  final String message;
  const GameSocketErrorReceived(this.message);
  @override
  List<Object?> get props => [message];
}
