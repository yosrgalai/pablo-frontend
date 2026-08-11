import 'package:json_annotation/json_annotation.dart';

/// Miroir exact de la state machine backend (doc §10).
/// Les valeurs JSON doivent correspondre caractère pour caractère
/// à ce que le serveur envoie.
enum GameRoundState {
  @JsonValue('LOBBY')
  lobby,
  @JsonValue('DEALING')
  dealing,
  @JsonValue('INITIAL_PEEK')
  initialPeek,
  @JsonValue('PLAYER_TURN')
  playerTurn,
  @JsonValue('PABLO_CALLED')
  pabloCalled,
  @JsonValue('ROUND_SCORING')
  roundScoring,
  @JsonValue('NEXT_ROUND')
  nextRound,
  @JsonValue('GAME_OVER')
  gameOver,
}
