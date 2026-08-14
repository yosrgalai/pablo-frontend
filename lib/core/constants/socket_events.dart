/// Noms d'events socket — copie exacte du contrat partagé
/// (`documentation_frontend_docx.pdf`). Ne JAMAIS modifier une valeur ici
/// sans validation des deux équipes (cf. en-tête du contrat).
class SocketEvents {
  SocketEvents._();

  // ---- Client → Serveur ----
  static const gameCreate = 'game:create';
  static const gameJoin = 'game:join';
  static const playerReady = 'player:ready';
  static const playerPeekInitial = 'player:peek_initial';
  static const turnDraw = 'turn:draw';
  static const turnSwap = 'turn:swap';
  static const turnDiscard = 'turn:discard';
  static const turnDiscardPair = 'turn:discard_pair';
  static const powerSelectTarget = 'power:select_target';
  static const caboCall = 'cabo:call';

  // ---- Serveur → Client ----
  static const playerJoined = 'player:joined';
  static const playerLeft = 'player:left';
  static const playerDisconnected = 'player:disconnected';
  static const gameDealt = 'game:dealt';
  static const playerPeekedInitial = 'player:peeked_initial';
  static const turnStarted = 'turn:started';
  static const turnDrewCard = 'turn:drew_card';
  static const turnSwappedCard = 'turn:swapped_card';
  static const turnDiscardedCard = 'turn:discarded_card';
  static const turnDiscardPairResult = 'turn:discard_pair_result';
  static const powerActivated = 'power:activated';
  static const powerTargetSelected = 'power:target_selected';
  static const caboCalled = 'cabo:called';
  static const roundEnded = 'round:ended';
  static const roundScoresRevealed = 'round:scores_revealed';
  static const gameEnded = 'game:ended';
}