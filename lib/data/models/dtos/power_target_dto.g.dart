// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'power_target_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PowerTargetDto _$PowerTargetDtoFromJson(Map<String, dynamic> json) =>
    _PowerTargetDto(
      gameId: json['gameId'] as String,
      playerId: json['playerId'] as String,
      powerRank: (json['powerRank'] as num).toInt(),
      targetPlayerId: json['targetPlayerId'] as String,
      targetPosition: (json['targetPosition'] as num).toInt(),
      secondTargetPlayerId: json['secondTargetPlayerId'] as String?,
      secondTargetPosition: (json['secondTargetPosition'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PowerTargetDtoToJson(_PowerTargetDto instance) =>
    <String, dynamic>{
      'gameId': instance.gameId,
      'playerId': instance.playerId,
      'powerRank': instance.powerRank,
      'targetPlayerId': instance.targetPlayerId,
      'targetPosition': instance.targetPosition,
      'secondTargetPlayerId': instance.secondTargetPlayerId,
      'secondTargetPosition': instance.secondTargetPosition,
    };
