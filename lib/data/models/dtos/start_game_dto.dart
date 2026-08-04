import 'package:freezed_annotation/freezed_annotation.dart';

part 'start_game_dto.freezed.dart';
part 'start_game_dto.g.dart';

/// Miroir de `StartGameDto` (backend).
/// [gameId] doit être un UUID valide.
@freezed
class StartGameDto with _$StartGameDto {
  const factory StartGameDto({
    required String gameId,
  }) = _StartGameDto;

  factory StartGameDto.fromJson(Map<String, dynamic> json) =>
      _$StartGameDtoFromJson(json);
}
