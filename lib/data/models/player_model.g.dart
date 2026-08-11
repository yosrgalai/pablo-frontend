// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerModelImpl _$$PlayerModelImplFromJson(Map<String, dynamic> json) =>
    _$PlayerModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
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

Map<String, dynamic> _$$PlayerModelImplToJson(_$PlayerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'handSize': instance.handSize,
      'hand': instance.hand,
      'isConnected': instance.isConnected,
      'isCurrentTurn': instance.isCurrentTurn,
      'hasCalledPablo': instance.hasCalledPablo,
      'roundScore': instance.roundScore,
      'totalScore': instance.totalScore,
    };
