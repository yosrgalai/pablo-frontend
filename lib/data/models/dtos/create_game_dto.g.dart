// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_game_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateGameDto _$CreateGameDtoFromJson(Map<String, dynamic> json) =>
    _CreateGameDto(
      scoreLimit: (json['scoreLimit'] as num).toInt(),
      playerNames: (json['playerNames'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CreateGameDtoToJson(_CreateGameDto instance) =>
    <String, dynamic>{
      'scoreLimit': instance.scoreLimit,
      'playerNames': instance.playerNames,
    };
