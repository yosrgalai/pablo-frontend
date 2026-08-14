// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlayerModel _$PlayerModelFromJson(Map<String, dynamic> json) => _PlayerModel(
  id: json['id'] as String,
  name: json['name'] as String,
  isHost: json['isHost'] as bool? ?? false,
  isReady: json['isReady'] as bool? ?? false,
  handSize: (json['handSize'] as num).toInt(),
  hand:
      (json['hand'] as List<dynamic>?)
          ?.map((e) => CardModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  isConnected: json['isConnected'] as bool,
  isCurrentTurn: json['isCurrentTurn'] as bool,
  hasCalledPablo: json['hasCalledPablo'] as bool? ?? false,
  roundScore: (json['roundScore'] as num?)?.toInt(),
  totalScore: (json['totalScore'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PlayerModelToJson(_PlayerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isHost': instance.isHost,
      'isReady': instance.isReady,
      'handSize': instance.handSize,
      'hand': instance.hand,
      'isConnected': instance.isConnected,
      'isCurrentTurn': instance.isCurrentTurn,
      'hasCalledPablo': instance.hasCalledPablo,
      'roundScore': instance.roundScore,
      'totalScore': instance.totalScore,
    };
