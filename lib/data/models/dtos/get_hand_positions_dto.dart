import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_hand_positions_dto.freezed.dart';
part 'get_hand_positions_dto.g.dart';

/// Miroir de `GetHandPositionsDto` (backend).
///
/// Note : côté TS, `gameId`/`playerId` sont typés `string | undefined` mais
/// restent requis via `@IsNotEmpty()`. Côté Dart, on les garde `required
/// String` (non nullable) : un payload sans ces champs est de toute façon
/// invalide et rejeté par le backend.
@freezed
abstract class GetHandPositionsDto with _$GetHandPositionsDto {
  const factory GetHandPositionsDto({
    required String gameId,
    required String playerId,
  }) = _GetHandPositionsDto;

  factory GetHandPositionsDto.fromJson(Map<String, dynamic> json) =>
      _$GetHandPositionsDtoFromJson(json);
}
