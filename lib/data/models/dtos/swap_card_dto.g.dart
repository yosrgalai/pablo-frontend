// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swap_card_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SwapCardDtoImpl _$$SwapCardDtoImplFromJson(Map<String, dynamic> json) =>
    _$SwapCardDtoImpl(
      gameId: json['gameId'] as String,
      playerId: json['playerId'] as String,
      drawnCardId: json['drawnCardId'] as String,
      handPosition: (json['handPosition'] as num).toInt(),
    );

Map<String, dynamic> _$$SwapCardDtoImplToJson(_$SwapCardDtoImpl instance) =>
    <String, dynamic>{
      'gameId': instance.gameId,
      'playerId': instance.playerId,
      'drawnCardId': instance.drawnCardId,
      'handPosition': instance.handPosition,
    };
