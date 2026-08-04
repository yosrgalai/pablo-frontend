import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_game_dto.freezed.dart';
part 'create_game_dto.g.dart';

/// Miroir de `CreateGameDto` (backend).
///
/// Contraintes backend à respecter côté UI avant envoi :
/// - [scoreLimit] doit être 50, 100 ou 150 (voir `DtoConstraints.allowedScoreLimits`)
/// - [playerNames] doit contenir entre 2 et 8 noms non vides
@freezed
class CreateGameDto with _$CreateGameDto {
  const factory CreateGameDto({
    required int scoreLimit,
    required List<String> playerNames,
  }) = _CreateGameDto;

  factory CreateGameDto.fromJson(Map<String, dynamic> json) =>
      _$CreateGameDtoFromJson(json);
}
