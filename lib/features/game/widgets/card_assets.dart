import '../../../data/models/card_model.dart';

/// Fait le lien entre un [CardModel] (rank/suit venant du backend) et le
/// chemin de l'image PNG correspondante dans `assets/images/cards/`.
///
/// Convention de nommage utilisée par le pack de cartes :
/// `{rank}_of_{suit}.png` (ex. `9_of_diamonds.png`, `king_of_hearts.png`).
///
/// ⚠️ Le backend réel envoie `suit` sous forme de mot anglais en
/// majuscules (`HEARTS`, `DIAMONDS`, `CLUBS`, `SPADES`), pas les symboles
/// (`♥ ♦ ♣ ♠`) utilisés dans la doc de jeu d'origine. On accepte les DEUX
/// formats ci-dessous pour rester robuste si ça change encore.
abstract class CardAssets {
  CardAssets._();

  static const String _basePath = 'assets/images/cards';

  /// Dos de carte, unique pour toutes les cartes cachées.
  static const String backPath = '$_basePath/card_back.png';

  /// Résout le chemin de l'image pour une carte visible.
  /// Retourne `null` si `rank` ou `suit` est manquant.
  static String? pathFor(CardModel card) {
    if (card.rank == null) return null;

    if (card.rank == 'JOKER') {
      return '$_basePath/black_joker.png';
    }

    if (card.suit == null) return null;

    final suitWord = _suitToWord(card.suit!);
    final rankWord = _rankToWord[card.rank];
    if (suitWord == null || rankWord == null) return null;

    return '$_basePath/${rankWord}_of_$suitWord.png';
  }

  /// Accepte le symbole (`♥`) OU le mot anglais, n'importe quelle casse
  /// (`HEARTS`, `hearts`, `Hearts`).
  static String? _suitToWord(String suit) {
    switch (suit.toUpperCase()) {
      case '♠':
      case 'SPADES':
        return 'spades';
      case '♥':
      case 'HEARTS':
        return 'hearts';
      case '♦':
      case 'DIAMONDS':
        return 'diamonds';
      case '♣':
      case 'CLUBS':
        return 'clubs';
      default:
        return null;
    }
  }

  /// Rangs texte -> mot utilisé dans le nom de fichier.
  /// Les valeurs numériques (2 à 10) restent telles quelles.
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