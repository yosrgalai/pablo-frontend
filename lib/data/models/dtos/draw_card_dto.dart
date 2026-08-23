import 'package:freezed_annotation/freezed_annotation.dart';

part 'draw_card_dto.freezed.dart';
part 'draw_card_dto.g.dart';

/// Miroir de `DrawCardDto` (backend).
/// Le joueur ne peut piocher QUE depuis la pioche (DECK), jamais depuis
/// la défausse (doc §4, Option A). La reconstruction de la pioche à partir
/// de la défausse (doc §9.1) est un mécanisme interne serveur uniquement.
@freezed
abstract class DrawCardDto with _$DrawCardDto {
  const factory DrawCardDto({
    required String gameId,
    required String playerId,
  }) = _DrawCardDto;

  factory DrawCardDto.fromJson(Map<String, dynamic> json) =>
      _$DrawCardDtoFromJson(json);
}
