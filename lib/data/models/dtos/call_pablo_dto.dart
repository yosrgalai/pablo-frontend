import 'package:freezed_annotation/freezed_annotation.dart';

part 'call_pablo_dto.freezed.dart';
part 'call_pablo_dto.g.dart';

/// Miroir de `CallPabloDto` (backend) — doc §6.
/// [gameId] et [playerId] doivent être des UUID valides.
@freezed
class CallPabloDto with _$CallPabloDto {
  const factory CallPabloDto({
    required String gameId,
    required String playerId,
  }) = _CallPabloDto;

  factory CallPabloDto.fromJson(Map<String, dynamic> json) =>
      _$CallPabloDtoFromJson(json);
}
