import 'package:freezed_annotation/freezed_annotation.dart';

part 'discard_card_dto.freezed.dart';
part 'discard_card_dto.g.dart';

/// Miroir de `DiscardCardDto` (backend).
///
/// Défausse directe de la carte piochée (sans échange avec la main).
/// Si la carte est un 7, 8 ou 9 (voir `DtoConstraints.powerRanks`), le
/// pouvoir PEUT être activé — ce n'est pas automatique (doc §4).
/// [usePower] exprime le choix du joueur : null/absent = comportement par
/// défaut backend (true si la carte a un pouvoir), ignoré sinon.
@freezed
abstract class DiscardCardDto with _$DiscardCardDto {
  const factory DiscardCardDto({
    required String gameId,
    required String playerId,
    required String drawnCardId,
    bool? usePower,
  }) = _DiscardCardDto;

  factory DiscardCardDto.fromJson(Map<String, dynamic> json) =>
      _$DiscardCardDtoFromJson(json);
}
