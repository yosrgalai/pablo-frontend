import 'package:freezed_annotation/freezed_annotation.dart';

part 'choose_initial_peek_dto.freezed.dart';
part 'choose_initial_peek_dto.g.dart';

/// Miroir de `ChooseInitialPeekDto` (backend).
///
/// [positions] doit contenir EXACTEMENT 2 valeurs, chacune entre 0 et 3
/// (`DtoConstraints.minHandPosition` / `maxHandPosition`).
/// Validé côté client pour l'UX, mais la source de vérité métier reste
/// le backend (CardService).
@freezed
abstract class ChooseInitialPeekDto with _$ChooseInitialPeekDto {
  const factory ChooseInitialPeekDto({
    required String gameId,
    required String playerId,
    required List<int> positions,
  }) = _ChooseInitialPeekDto;

  factory ChooseInitialPeekDto.fromJson(Map<String, dynamic> json) =>
      _$ChooseInitialPeekDtoFromJson(json);
}
