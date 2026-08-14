part of 'game_bloc.dart';

abstract class GameState extends Equatable {
  const GameState();
  @override
  List<Object?> get props => [];
}

/// DEALING — en attente des positions de main (bref, jusqu'à hand:positions).
class GameDealingState extends GameState {
  const GameDealingState();
}

/// INITIAL_PEEK — le joueur choisit 2 des 4 positions à regarder.
/// [selected] : positions actuellement cochées (max 2, cf. doc §3).
/// [confirmed] : true une fois choose_initial_peek envoyé (verrouille l'UI
/// en attendant player:peeked_initial).
class GameInitialPeekState extends GameState {
  final List<CardModel> positions; // 4 cartes cachées, index = position
  final Set<int> selected;
  final bool confirmed;

  const GameInitialPeekState({
    required this.positions,
    this.selected = const {},
    this.confirmed = false,
  });

  GameInitialPeekState copyWith({Set<int>? selected, bool? confirmed}) {
    return GameInitialPeekState(
      positions: positions,
      selected: selected ?? this.selected,
      confirmed: confirmed ?? this.confirmed,
    );
  }

  @override
  List<Object?> get props => [positions, selected, confirmed];
}

/// Peek confirmé, cartes révélées localement : on attend que les AUTRES
/// joueurs finissent le leur (turn:started marque la fin de cette attente).
class GameWaitingOthersPeekState extends GameState {
  final List<CardModel> revealedCards;
  const GameWaitingOthersPeekState(this.revealedCards);
  @override
  List<Object?> get props => [revealedCards];
}

/// PLAYER_TURN — squelette minimal (Dev A) : qui a la main, et si c'est à
/// nous. Le détail du plateau (pioche/défausse/main visible avec valeurs)
/// est alimenté par les events que Dev B gère (turn:drew_card,
/// turn:swapped_card, turn:discarded_card...) — pas dupliqué ici.
class GamePlayerTurnState extends GameState {
  final String currentPlayerId;
  final String localPlayerId;
  final bool pabloCalled;
  final String? pabloCallerId;

  const GamePlayerTurnState({
    required this.currentPlayerId,
    required this.localPlayerId,
    this.pabloCalled = false,
    this.pabloCallerId,
  });

  bool get isLocalTurn => currentPlayerId == localPlayerId;

  GamePlayerTurnState copyWith({
    String? currentPlayerId,
    bool? pabloCalled,
    String? pabloCallerId,
  }) {
    return GamePlayerTurnState(
      currentPlayerId: currentPlayerId ?? this.currentPlayerId,
      localPlayerId: localPlayerId,
      pabloCalled: pabloCalled ?? this.pabloCalled,
      pabloCallerId: pabloCallerId ?? this.pabloCallerId,
    );
  }

  @override
  List<Object?> get props =>
      [currentPlayerId, localPlayerId, pabloCalled, pabloCallerId];
}

/// ROUND_SCORING — fin de manche, scores bruts reçus (payload non
/// détaillé plus finement pour l'instant, cf. round:ended côté serveur).
class GameRoundScoringState extends GameState {
  final Map<String, dynamic> payload;
  const GameRoundScoringState(this.payload);
  @override
  List<Object?> get props => [payload];
}

/// GAME_OVER — partie terminée.
class GameOverState extends GameState {
  final Map<String, dynamic> payload;
  const GameOverState(this.payload);
  @override
  List<Object?> get props => [payload];
}

class GameErrorState extends GameState {
  final String message;
  const GameErrorState(this.message);
  @override
  List<Object?> get props => [message];
}
