import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_pablo/data/models/card_model.dart';
import 'package:frontend_pablo/utils/card_score_calculator.dart';

void main() {
  group('cardValue', () {
    test('As vaut 10', () {
      expect(cardValue(const CardModel(id: '1', rank: 'A', suit: '♠', hidden: false)), 10);
    });

    test('2 à 10 valent leur valeur faciale', () {
      expect(cardValue(const CardModel(id: '1', rank: '7', suit: '♦', hidden: false)), 7);
      expect(cardValue(const CardModel(id: '2', rank: '10', suit: '♣', hidden: false)), 10);
    });

    test('Valet et Dame valent 10', () {
      expect(cardValue(const CardModel(id: '1', rank: 'J', suit: '♠', hidden: false)), 10);
      expect(cardValue(const CardModel(id: '2', rank: 'Q', suit: '♥', hidden: false)), 10);
    });

    test('Roi rouge (♥ ♦) vaut 0', () {
      expect(cardValue(const CardModel(id: '1', rank: 'K', suit: '♥', hidden: false)), 0);
      expect(cardValue(const CardModel(id: '2', rank: 'K', suit: '♦', hidden: false)), 0);
    });

    test('Roi noir (♠ ♣) vaut 10', () {
      expect(cardValue(const CardModel(id: '1', rank: 'K', suit: '♠', hidden: false)), 10);
      expect(cardValue(const CardModel(id: '2', rank: 'K', suit: '♣', hidden: false)), 10);
    });

    test('Joker vaut 0', () {
      expect(cardValue(const CardModel(id: '1', rank: 'JOKER', suit: null, hidden: false)), 0);
    });

    test('lève une erreur sur une carte cachée', () {
      expect(
        () => cardValue(const CardModel(id: '1', hidden: true)),
        throwsArgumentError,
      );
    });
  });

  group('handScore', () {
    test('additionne correctement une main de 4 cartes', () {
      final hand = const [
        CardModel(id: '1', rank: 'K', suit: '♥', hidden: false), // 0
        CardModel(id: '2', rank: '7', suit: '♠', hidden: false), // 7
        CardModel(id: '3', rank: 'A', suit: '♦', hidden: false), // 10
        CardModel(id: '4', rank: 'K', suit: '♣', hidden: false), // 10
      ];
      expect(handScore(hand), 27);
    });

    test('main vide = score 0', () {
      expect(handScore(const []), 0);
    });
  });
}