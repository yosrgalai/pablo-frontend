// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_hand_positions_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GetHandPositionsDto _$GetHandPositionsDtoFromJson(Map<String, dynamic> json) =>
    _GetHandPositionsDto(
      gameId: json['gameId'] as String,
      playerId: json['playerId'] as String,
    );

Map<String, dynamic> _$GetHandPositionsDtoToJson(
  _GetHandPositionsDto instance,
) => <String, dynamic>{
  'gameId': instance.gameId,
  'playerId': instance.playerId,
};
