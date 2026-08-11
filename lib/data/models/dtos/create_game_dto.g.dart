// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_game_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateGameDtoImpl _$$CreateGameDtoImplFromJson(Map<String, dynamic> json) =>
    _$CreateGameDtoImpl(
      scoreLimit: (json['scoreLimit'] as num).toInt(),
      playerNames: (json['playerNames'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$CreateGameDtoImplToJson(_$CreateGameDtoImpl instance) =>
    <String, dynamic>{
      'scoreLimit': instance.scoreLimit,
      'playerNames': instance.playerNames,
    };
