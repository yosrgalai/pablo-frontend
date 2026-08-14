// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'choose_initial_peek_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChooseInitialPeekDto _$ChooseInitialPeekDtoFromJson(
  Map<String, dynamic> json,
) => _ChooseInitialPeekDto(
  gameId: json['gameId'] as String,
  playerId: json['playerId'] as String,
  positions: (json['positions'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$ChooseInitialPeekDtoToJson(
  _ChooseInitialPeekDto instance,
) => <String, dynamic>{
  'gameId': instance.gameId,
  'playerId': instance.playerId,
  'positions': instance.positions,
};
