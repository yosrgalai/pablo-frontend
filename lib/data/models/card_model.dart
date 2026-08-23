import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_model.freezed.dart';
part 'card_model.g.dart';

/// Miroir du format carte envoyé par le backend.
///
/// [rank] et [suit] sont `null` quand [hidden] est `true` : le serveur ne
/// révèle jamais la valeur d'une carte que le joueur/client ne doit pas
/// connaître. Le widget d'affichage (`CardWidget`) doit se baser
/// uniquement sur [hidden] pour décider quoi afficher — jamais essayer
/// de "deviner" une valeur.
///
/// ⚠️ [suit] peut être soit un symbole (`♠ ♥ ♦ ♣`), soit un mot anglais
/// en majuscules (`SPADES`, `HEARTS`, `DIAMONDS`, `CLUBS`) selon ce que le
/// backend envoie réellement — les deux formats sont supportés ici et
/// dans `CardAssets`.
@freezed
abstract class CardModel with _$CardModel {
  const CardModel._();

  const factory CardModel({
    required String id,
    String? rank,
    String? suit,
    required bool hidden,
  }) = _CardModel;

  factory CardModel.fromJson(Map<String, dynamic> json) =>
      _$CardModelFromJson(json);

  /// Vrai si la carte possède un pouvoir spécial (7, 8 ou 9) — n'a de sens
  /// que si la carte est visible (rank connu).
  bool get hasPower => rank == '7' || rank == '8' || rank == '9';

  /// Couleur du symbole (utile pour l'affichage : rouge vs noir).
  /// Retourne `null` si la carte est cachée. Accepte symbole ET mot anglais.
  bool? get isRedSuit {
    if (suit == null) return null;
    final normalized = suit!.toUpperCase();
    return normalized == '♥' || normalized == 'HEARTS' ||
        normalized == '♦' || normalized == 'DIAMONDS';
  }
}