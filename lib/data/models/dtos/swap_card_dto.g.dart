// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swap_card_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SwapCardDto _$SwapCardDtoFromJson(Map<String, dynamic> json) => _SwapCardDto(
  gameId: json['gameId'] as String,
  playerId: json['playerId'] as String,
  drawnCardId: json['drawnCardId'] as String,
  handPosition: (json['handPosition'] as num).toInt(),
);

Map<String, dynamic> _$SwapCardDtoToJson(_SwapCardDto instance) =>
    <String, dynamic>{
      'gameId': instance.gameId,
      'playerId': instance.playerId,
      'drawnCardId': instance.drawnCardId,
      'handPosition': instance.handPosition,
    };
