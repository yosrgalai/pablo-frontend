// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discard_card_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DiscardCardDto _$DiscardCardDtoFromJson(Map<String, dynamic> json) =>
    _DiscardCardDto(
      gameId: json['gameId'] as String,
      playerId: json['playerId'] as String,
      drawnCardId: json['drawnCardId'] as String,
      usePower: json['usePower'] as bool?,
    );

Map<String, dynamic> _$DiscardCardDtoToJson(_DiscardCardDto instance) =>
    <String, dynamic>{
      'gameId': instance.gameId,
      'playerId': instance.playerId,
      'drawnCardId': instance.drawnCardId,
      'usePower': instance.usePower,
    };
