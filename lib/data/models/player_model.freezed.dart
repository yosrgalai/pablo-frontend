// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlayerModel {

 String get id; String get name; bool get isHost; bool get isReady; int get handSize; List<CardModel> get hand; bool get isConnected; bool get isCurrentTurn; bool get hasCalledPablo; int? get roundScore; int get totalScore;
/// Create a copy of PlayerModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerModelCopyWith<PlayerModel> get copyWith => _$PlayerModelCopyWithImpl<PlayerModel>(this as PlayerModel, _$identity);

  /// Serializes this PlayerModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isHost, isHost) || other.isHost == isHost)&&(identical(other.isReady, isReady) || other.isReady == isReady)&&(identical(other.handSize, handSize) || other.handSize == handSize)&&const DeepCollectionEquality().equals(other.hand, hand)&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected)&&(identical(other.isCurrentTurn, isCurrentTurn) || other.isCurrentTurn == isCurrentTurn)&&(identical(other.hasCalledPablo, hasCalledPablo) || other.hasCalledPablo == hasCalledPablo)&&(identical(other.roundScore, roundScore) || other.roundScore == roundScore)&&(identical(other.totalScore, totalScore) || other.totalScore == totalScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,isHost,isReady,handSize,const DeepCollectionEquality().hash(hand),isConnected,isCurrentTurn,hasCalledPablo,roundScore,totalScore);

@override
String toString() {
  return 'PlayerModel(id: $id, name: $name, isHost: $isHost, isReady: $isReady, handSize: $handSize, hand: $hand, isConnected: $isConnected, isCurrentTurn: $isCurrentTurn, hasCalledPablo: $hasCalledPablo, roundScore: $roundScore, totalScore: $totalScore)';
}


}

/// @nodoc
abstract mixin class $PlayerModelCopyWith<$Res>  {
  factory $PlayerModelCopyWith(PlayerModel value, $Res Function(PlayerModel) _then) = _$PlayerModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, bool isHost, bool isReady, int handSize, List<CardModel> hand, bool isConnected, bool isCurrentTurn, bool hasCalledPablo, int? roundScore, int totalScore
});




}
/// @nodoc
class _$PlayerModelCopyWithImpl<$Res>
    implements $PlayerModelCopyWith<$Res> {
  _$PlayerModelCopyWithImpl(this._self, this._then);

  final PlayerModel _self;
  final $Res Function(PlayerModel) _then;

/// Create a copy of PlayerModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? isHost = null,Object? isReady = null,Object? handSize = null,Object? hand = null,Object? isConnected = null,Object? isCurrentTurn = null,Object? hasCalledPablo = null,Object? roundScore = freezed,Object? totalScore = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isHost: null == isHost ? _self.isHost : isHost // ignore: cast_nullable_to_non_nullable
as bool,isReady: null == isReady ? _self.isReady : isReady // ignore: cast_nullable_to_non_nullable
as bool,handSize: null == handSize ? _self.handSize : handSize // ignore: cast_nullable_to_non_nullable
as int,hand: null == hand ? _self.hand : hand // ignore: cast_nullable_to_non_nullable
as List<CardModel>,isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,isCurrentTurn: null == isCurrentTurn ? _self.isCurrentTurn : isCurrentTurn // ignore: cast_nullable_to_non_nullable
as bool,hasCalledPablo: null == hasCalledPablo ? _self.hasCalledPablo : hasCalledPablo // ignore: cast_nullable_to_non_nullable
as bool,roundScore: freezed == roundScore ? _self.roundScore : roundScore // ignore: cast_nullable_to_non_nullable
as int?,totalScore: null == totalScore ? _self.totalScore : totalScore // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayerModel].
extension PlayerModelPatterns on PlayerModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerModel value)  $default,){
final _that = this;
switch (_that) {
case _PlayerModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerModel value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  bool isHost,  bool isReady,  int handSize,  List<CardModel> hand,  bool isConnected,  bool isCurrentTurn,  bool hasCalledPablo,  int? roundScore,  int totalScore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerModel() when $default != null:
return $default(_that.id,_that.name,_that.isHost,_that.isReady,_that.handSize,_that.hand,_that.isConnected,_that.isCurrentTurn,_that.hasCalledPablo,_that.roundScore,_that.totalScore);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  bool isHost,  bool isReady,  int handSize,  List<CardModel> hand,  bool isConnected,  bool isCurrentTurn,  bool hasCalledPablo,  int? roundScore,  int totalScore)  $default,) {final _that = this;
switch (_that) {
case _PlayerModel():
return $default(_that.id,_that.name,_that.isHost,_that.isReady,_that.handSize,_that.hand,_that.isConnected,_that.isCurrentTurn,_that.hasCalledPablo,_that.roundScore,_that.totalScore);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  bool isHost,  bool isReady,  int handSize,  List<CardModel> hand,  bool isConnected,  bool isCurrentTurn,  bool hasCalledPablo,  int? roundScore,  int totalScore)?  $default,) {final _that = this;
switch (_that) {
case _PlayerModel() when $default != null:
return $default(_that.id,_that.name,_that.isHost,_that.isReady,_that.handSize,_that.hand,_that.isConnected,_that.isCurrentTurn,_that.hasCalledPablo,_that.roundScore,_that.totalScore);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlayerModel extends PlayerModel {
  const _PlayerModel({required this.id, required this.name, this.isHost = false, this.isReady = false, required this.handSize, final  List<CardModel> hand = const [], required this.isConnected, required this.isCurrentTurn, this.hasCalledPablo = false, this.roundScore, this.totalScore = 0}): _hand = hand,super._();
  factory _PlayerModel.fromJson(Map<String, dynamic> json) => _$PlayerModelFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  bool isHost;
@override@JsonKey() final  bool isReady;
@override final  int handSize;
 final  List<CardModel> _hand;
@override@JsonKey() List<CardModel> get hand {
  if (_hand is EqualUnmodifiableListView) return _hand;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hand);
}

@override final  bool isConnected;
@override final  bool isCurrentTurn;
@override@JsonKey() final  bool hasCalledPablo;
@override final  int? roundScore;
@override@JsonKey() final  int totalScore;

/// Create a copy of PlayerModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerModelCopyWith<_PlayerModel> get copyWith => __$PlayerModelCopyWithImpl<_PlayerModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isHost, isHost) || other.isHost == isHost)&&(identical(other.isReady, isReady) || other.isReady == isReady)&&(identical(other.handSize, handSize) || other.handSize == handSize)&&const DeepCollectionEquality().equals(other._hand, _hand)&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected)&&(identical(other.isCurrentTurn, isCurrentTurn) || other.isCurrentTurn == isCurrentTurn)&&(identical(other.hasCalledPablo, hasCalledPablo) || other.hasCalledPablo == hasCalledPablo)&&(identical(other.roundScore, roundScore) || other.roundScore == roundScore)&&(identical(other.totalScore, totalScore) || other.totalScore == totalScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,isHost,isReady,handSize,const DeepCollectionEquality().hash(_hand),isConnected,isCurrentTurn,hasCalledPablo,roundScore,totalScore);

@override
String toString() {
  return 'PlayerModel(id: $id, name: $name, isHost: $isHost, isReady: $isReady, handSize: $handSize, hand: $hand, isConnected: $isConnected, isCurrentTurn: $isCurrentTurn, hasCalledPablo: $hasCalledPablo, roundScore: $roundScore, totalScore: $totalScore)';
}


}

/// @nodoc
abstract mixin class _$PlayerModelCopyWith<$Res> implements $PlayerModelCopyWith<$Res> {
  factory _$PlayerModelCopyWith(_PlayerModel value, $Res Function(_PlayerModel) _then) = __$PlayerModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, bool isHost, bool isReady, int handSize, List<CardModel> hand, bool isConnected, bool isCurrentTurn, bool hasCalledPablo, int? roundScore, int totalScore
});




}
/// @nodoc
class __$PlayerModelCopyWithImpl<$Res>
    implements _$PlayerModelCopyWith<$Res> {
  __$PlayerModelCopyWithImpl(this._self, this._then);

  final _PlayerModel _self;
  final $Res Function(_PlayerModel) _then;

/// Create a copy of PlayerModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? isHost = null,Object? isReady = null,Object? handSize = null,Object? hand = null,Object? isConnected = null,Object? isCurrentTurn = null,Object? hasCalledPablo = null,Object? roundScore = freezed,Object? totalScore = null,}) {
  return _then(_PlayerModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isHost: null == isHost ? _self.isHost : isHost // ignore: cast_nullable_to_non_nullable
as bool,isReady: null == isReady ? _self.isReady : isReady // ignore: cast_nullable_to_non_nullable
as bool,handSize: null == handSize ? _self.handSize : handSize // ignore: cast_nullable_to_non_nullable
as int,hand: null == hand ? _self._hand : hand // ignore: cast_nullable_to_non_nullable
as List<CardModel>,isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,isCurrentTurn: null == isCurrentTurn ? _self.isCurrentTurn : isCurrentTurn // ignore: cast_nullable_to_non_nullable
as bool,hasCalledPablo: null == hasCalledPablo ? _self.hasCalledPablo : hasCalledPablo // ignore: cast_nullable_to_non_nullable
as bool,roundScore: freezed == roundScore ? _self.roundScore : roundScore // ignore: cast_nullable_to_non_nullable
as int?,totalScore: null == totalScore ? _self.totalScore : totalScore // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
