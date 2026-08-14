// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'round_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoundModel _$RoundModelFromJson(Map<String, dynamic> json) => _RoundModel(
  roundNumber: (json['roundNumber'] as num).toInt(),
  drawPileCount: (json['drawPileCount'] as num).toInt(),
  discardTop: json['discardTop'] == null
      ? null
      : CardModel.fromJson(json['discardTop'] as Map<String, dynamic>),
  state: $enumDecode(_$GameRoundStateEnumMap, json['state']),
);

Map<String, dynamic> _$RoundModelToJson(_RoundModel instance) =>
    <String, dynamic>{
      'roundNumber': instance.roundNumber,
      'drawPileCount': instance.drawPileCount,
      'discardTop': instance.discardTop,
      'state': _$GameRoundStateEnumMap[instance.state]!,
    };

const _$GameRoundStateEnumMap = {
  GameRoundState.lobby: 'LOBBY',
  GameRoundState.dealing: 'DEALING',
  GameRoundState.initialPeek: 'INITIAL_PEEK',
  GameRoundState.playerTurn: 'PLAYER_TURN',
  GameRoundState.pabloCalled: 'PABLO_CALLED',
  GameRoundState.roundScoring: 'ROUND_SCORING',
  GameRoundState.nextRound: 'NEXT_ROUND',
  GameRoundState.gameOver: 'GAME_OVER',
};
