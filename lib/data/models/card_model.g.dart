// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CardModel _$CardModelFromJson(Map<String, dynamic> json) => _CardModel(
  id: json['id'] as String,
  rank: json['rank'] as String?,
  suit: json['suit'] as String?,
  hidden: json['hidden'] as bool,
);

Map<String, dynamic> _$CardModelToJson(_CardModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rank': instance.rank,
      'suit': instance.suit,
      'hidden': instance.hidden,
    };
