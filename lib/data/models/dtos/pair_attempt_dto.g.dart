// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pair_attempt_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PairAttemptDto _$PairAttemptDtoFromJson(Map<String, dynamic> json) =>
    _PairAttemptDto(
      gameId: json['gameId'] as String,
      playerId: json['playerId'] as String,
      firstPosition: (json['firstPosition'] as num).toInt(),
      secondPosition: (json['secondPosition'] as num).toInt(),
    );

Map<String, dynamic> _$PairAttemptDtoToJson(_PairAttemptDto instance) =>
    <String, dynamic>{
      'gameId': instance.gameId,
      'playerId': instance.playerId,
      'firstPosition': instance.firstPosition,
      'secondPosition': instance.secondPosition,
    };
