import '../../../data/models/card_model.dart';

/// Fait le lien entre un [CardModel] (rank/suit venant du backend) et le
/// chemin de l'image PNG correspondante dans `assets/images/cards/`.
///
/// Convention de nommage utilisée par le pack de cartes :
/// `{rank}_of_{suit}.png`
///
/// Exemples :
/// - `2_of_clubs.png`
/// - `9_of_diamonds.png`
/// - `jack_of_diamonds.png`
/// - `king_of_hearts.png`
/// - `7_of_spades.png`
class CardAssets {
  CardAssets._();

  static const String _basePath = 'assets/images/cards';

  /// Dos de carte, unique pour toutes les cartes cachées.
  static const String backPath = '$_basePath/card_back.png';

  /// Résout le chemin de l'image pour une carte visible.
  ///
  /// Retourne `null` si `rank` ou `suit` est manquant.
  static String? pathFor(CardModel card) {
    if (card.rank == null) return null;

    // Joker : pas d'enseigne associée.
    if (card.rank == 'JOKER') {
      // Le backend n'envoie pas d'enseigne pour un joker, on renvoie donc
      // par défaut la version noire.
      return '$_basePath/black_joker.png';
    }

    if (card.suit == null) return null;

    final suitWord = _suitToWord[card.suit];
    final rankWord = _rankToWord[card.rank];

    if (suitWord == null || rankWord == null) return null;

    // Convention du pack :
    // 9_of_diamonds.png
    // king_of_hearts.png
    // 7_of_spades.png
    return '$_basePath/${rankWord}_of_$suitWord.png';
  }

  /// Correspondance entre les symboles d'enseigne du backend
  /// et les noms utilisés dans les fichiers.
  static const Map<String, String> _suitToWord = {
    '♠': 'spades',
    '♥': 'hearts',
    '♦': 'diamonds',
    '♣': 'clubs',
  };

  /// Correspondance entre les rangs du backend
  /// et les noms utilisés dans les fichiers.
  static const Map<String, String> _rankToWord = {
    'A': 'ace',
    '2': '2',
    '3': '3',
    '4': '4',
    '5': '5',
    '6': '6',
    '7': '7',
    '8': '8',
    '9': '9',
    '10': '10',
    'J': 'jack',
    'Q': 'queen',
    'K': 'king',
  };
}