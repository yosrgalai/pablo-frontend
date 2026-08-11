// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'choose_initial_peek_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChooseInitialPeekDtoImpl _$$ChooseInitialPeekDtoImplFromJson(
  Map<String, dynamic> json,
) => _$ChooseInitialPeekDtoImpl(
  gameId: json['gameId'] as String,
  playerId: json['playerId'] as String,
  positions: (json['positions'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$$ChooseInitialPeekDtoImplToJson(
  _$ChooseInitialPeekDtoImpl instance,
) => <String, dynamic>{
  'gameId': instance.gameId,
  'playerId': instance.playerId,
  'positions': instance.positions,
};
