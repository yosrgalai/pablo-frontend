part of 'lobby_bloc.dart';

abstract class LobbyEvent extends Equatable {
  const LobbyEvent();
  @override
  List<Object?> get props => [];
}

class LobbyCreateRequested extends LobbyEvent {
  final int scoreLimit;
   final String name;    
const LobbyCreateRequested({required this.scoreLimit, required this.name});  @override
  List<Object?> get props => [scoreLimit, name];
}

class LobbyJoinRequested extends LobbyEvent {
  final String gameId;
  const LobbyJoinRequested({required this.gameId});
  @override
  List<Object?> get props => [gameId];
}

/// Hôte uniquement — bouton "Démarrer la partie".
class LobbyStartGamePressed extends LobbyEvent {
  const LobbyStartGamePressed();
}

class LobbyLeftRequested extends LobbyEvent {
  const LobbyLeftRequested();
}

/// Interne — déclenché périodiquement pendant qu'on est dans la salle
/// d'attente. Le backend ne pousse rien en temps réel quand un joueur
/// rejoint via REST (POST /games/:id/join) ; on repolle donc l'état de la
/// partie pour voir les autres joueurs arriver. À remplacer par un vrai
/// broadcast socket côté backend si/quand ça devient prioritaire.
class LobbyPollRequested extends LobbyEvent {
  const LobbyPollRequested();
}

// ---- Events internes (streams socket) ----

class LobbyGameDealtReceived extends LobbyEvent {
  const LobbyGameDealtReceived();
}

class LobbySocketErrorReceived extends LobbyEvent {
  final String message;
  const LobbySocketErrorReceived(this.message);
  @override
  List<Object?> get props => [message];
}