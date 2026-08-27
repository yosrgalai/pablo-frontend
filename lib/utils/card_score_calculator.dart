import '../data/models/card_model.dart';

/// Calcul de la valeur d'une carte / du score d'une main, purement pour
/// l'affichage et la vérification locale (doc jeu §7). Le score officiel
/// est TOUJOURS calculé côté serveur (GameService.resolveRoundScoring) —
/// ce fichier ne sert jamais de source de vérité, seulement à afficher
/// un aperçu (ex: pendant round_scoring, une fois les cartes révélées
/// par le serveur).
///
/// Table de valeurs (doc §7) :
///  As              -> 10
///  2 à 10           -> valeur faciale
///  Valet / Dame     -> 10
///  Roi rouge (♥ ♦)  -> 0
///  Roi noir (♠ ♣)   -> 10
///  Joker            -> 0

/// Valeur d'une seule carte. Lance une [ArgumentError] si la carte est
/// cachée ([CardModel.hidden] == true / rank == null) : on ne doit
/// JAMAIS tenter de calculer/afficher la valeur d'une carte que le
/// serveur n'a pas révélée (règle de sécurité, doc contrat §3).
int cardValue(CardModel card) {
  final rank = card.rank;
  if (card.hidden || rank == null) {
    throw ArgumentError(
      'cardValue() appelé sur une carte cachée (id: ${card.id}). '
      'Une carte non révélée par le serveur ne doit jamais être utilisée '
      'pour un calcul de score côté client.',
    );
  }

  switch (rank) {
    case 'A':
      return 10;
    case 'J':
    case 'Q':
      return 10;
    case 'K':
      // Roi rouge (♥ ♦) = 0, Roi noir (♠ ♣) = 10.
      final isRed = card.isRedSuit;
      if (isRed == null) {
        throw ArgumentError(
          'Carte Roi (id: ${card.id}) sans enseigne connue : impossible '
          'de déterminer rouge/noir.',
        );
      }
      return isRed ? 0 : 10;
    case 'JOKER':
      return 0;
    default:
      final faceValue = int.tryParse(rank);
      if (faceValue != null && faceValue >= 2 && faceValue <= 10) {
        return faceValue;
      }
      throw ArgumentError('Rank de carte inconnu : "$rank" (id: ${card.id})');
  }
}

/// Score total d'une main (somme des valeurs des cartes, doc §7).
/// Toutes les cartes doivent être visibles ([CardModel.hidden] == false).
int handScore(List<CardModel> hand) {
  return hand.fold(0, (sum, card) => sum + cardValue(card));
}