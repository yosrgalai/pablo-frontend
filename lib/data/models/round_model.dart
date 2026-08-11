import 'package:freezed_annotation/freezed_annotation.dart';

import 'card_model.dart';
import 'game_round_state.dart';

part 'round_model.freezed.dart';
part 'round_model.g.dart';

/// Miroir du format manche envoyé par le backend (doc 02, section 1).
///
/// [discardTop] est la carte visible au sommet de la défausse
/// (`discard_pile_widget` l'affiche directement, jamais cachée).
/// [drawPileCount] sert uniquement à afficher le nombre de cartes restantes
/// sur `draw_pile_widget` — le contenu réel de la pioche n'est jamais
/// envoyé au client (règle de sécurité, doc 01 section 3).
@freezed
class RoundModel with _$RoundModel {
  const factory RoundModel({
    required int roundNumber,
    required int drawPileCount,
    CardModel? discardTop,
    required GameRoundState state,
  }) = _RoundModel;

  factory RoundModel.fromJson(Map<String, dynamic> json) =>
      _$RoundModelFromJson(json);
}
