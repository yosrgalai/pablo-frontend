// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pair_attempt_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PairAttemptDtoImpl _$$PairAttemptDtoImplFromJson(Map<String, dynamic> json) =>
    _$PairAttemptDtoImpl(
      gameId: json['gameId'] as String,
      playerId: json['playerId'] as String,
      firstPosition: (json['firstPosition'] as num).toInt(),
      secondPosition: (json['secondPosition'] as num).toInt(),
    );

Map<String, dynamic> _$$PairAttemptDtoImplToJson(
  _$PairAttemptDtoImpl instance,
) => <String, dynamic>{
  'gameId': instance.gameId,
  'playerId': instance.playerId,
  'firstPosition': instance.firstPosition,
  'secondPosition': instance.secondPosition,
};
