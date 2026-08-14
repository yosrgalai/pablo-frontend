import 'package:freezed_annotation/freezed_annotation.dart';

part 'power_target_dto.freezed.dart';
part 'power_target_dto.g.dart';

/// Miroir de `PowerTargetDto` (backend) — doc §5.
///
/// - powerRank 7 -> regarder une de ses propres cartes :
///   [targetPlayerId] = le joueur lui-même.
/// - powerRank 8 -> espionner : [targetPlayerId] = un adversaire.
/// - powerRank 9 -> échange aveugle entre deux joueurs, sans regarder
///   aucune des deux cartes : [secondTargetPlayerId] et
///   [secondTargetPosition] sont alors OBLIGATOIRES (null sinon).
///
/// [powerRank] doit être 7, 8 ou 9 (voir `DtoConstraints.powerRanks`).
/// [targetPosition] / [secondTargetPosition] doivent être entre 0 et 3.
@freezed
abstract class PowerTargetDto with _$PowerTargetDto {
  const factory PowerTargetDto({
    required String gameId,
    required String playerId,
    required int powerRank,
    required String targetPlayerId,
    required int targetPosition,
    String? secondTargetPlayerId,
    int? secondTargetPosition,
  }) = _PowerTargetDto;

  factory PowerTargetDto.fromJson(Map<String, dynamic> json) =>
      _$PowerTargetDtoFromJson(json);
}
