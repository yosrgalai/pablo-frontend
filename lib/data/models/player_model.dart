import 'package:freezed_annotation/freezed_annotation.dart';

import 'card_model.dart';

part 'player_model.freezed.dart';
part 'player_model.g.dart';

/// Miroir du format joueur envoyé par le backend (doc 02, section 1).
///
/// [hand] n'est rempli (avec les vraies valeurs connues) que pour le
/// joueur local. Pour les adversaires, le serveur envoie [handSize]
/// (nombre de cartes) mais [hand] reste vide côté client — le plateau
/// affiche alors [handSize] cartes face cachée via `opponent_seat_widget`,
/// sans jamais construire de `CardModel` fictif pour combler le vide.
@freezed
class PlayerModel with _$PlayerModel {
  const PlayerModel._();

  const factory PlayerModel({
    required String id,
    required String name,
    required int handSize,
    @Default([]) List<CardModel> hand,
    required bool isConnected,
    required bool isCurrentTurn,
    @Default(false) bool hasCalledPablo,
    int? roundScore,
    @Default(0) int totalScore,
  }) = _PlayerModel;

  factory PlayerModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerModelFromJson(json);

  /// Vrai s'il s'agit du joueur local (main connue, `hand` non vide ou
  /// `handSize == 0` en fin de manche). À utiliser plutôt que de comparer
  /// `hand.isNotEmpty` directement dans les widgets.
  bool get isLocalPlayer => hand.isNotEmpty || handSize == 0;

  /// Nombre de cartes cachées à afficher pour cet adversaire
  /// (`opponent_seat_widget` boucle sur ce nombre, pas sur `hand`).
  int get hiddenCardCount => isLocalPlayer ? 0 : handSize;
}
