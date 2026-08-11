// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discard_card_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DiscardCardDtoImpl _$$DiscardCardDtoImplFromJson(Map<String, dynamic> json) =>
    _$DiscardCardDtoImpl(
      gameId: json['gameId'] as String,
      playerId: json['playerId'] as String,
      drawnCardId: json['drawnCardId'] as String,
      usePower: json['usePower'] as bool?,
    );

Map<String, dynamic> _$$DiscardCardDtoImplToJson(
  _$DiscardCardDtoImpl instance,
) => <String, dynamic>{
  'gameId': instance.gameId,
  'playerId': instance.playerId,
  'drawnCardId': instance.drawnCardId,
  'usePower': instance.usePower,
};
