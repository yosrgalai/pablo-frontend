import 'package:freezed_annotation/freezed_annotation.dart';

part 'swap_card_dto.freezed.dart';
part 'swap_card_dto.g.dart';

/// Miroir de `SwapCardDto` (backend).
///
/// [drawnCardId] : carte actuellement piochée (location = DECK).
/// [handPosition] : position dans la main (0 à 3) à échanger avec la carte piochée.
@freezed
abstract class SwapCardDto with _$SwapCardDto {
  const factory SwapCardDto({
    required String gameId,
    required String playerId,
    required String drawnCardId,
    required int handPosition,
  }) = _SwapCardDto;

  factory SwapCardDto.fromJson(Map<String, dynamic> json) =>
      _$SwapCardDtoFromJson(json);
}
