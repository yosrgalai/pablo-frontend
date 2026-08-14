// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'round_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RoundModel {

 int get roundNumber; int get drawPileCount; CardModel? get discardTop; GameRoundState get state;
/// Create a copy of RoundModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoundModelCopyWith<RoundModel> get copyWith => _$RoundModelCopyWithImpl<RoundModel>(this as RoundModel, _$identity);

  /// Serializes this RoundModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoundModel&&(identical(other.roundNumber, roundNumber) || other.roundNumber == roundNumber)&&(identical(other.drawPileCount, drawPileCount) || other.drawPileCount == drawPileCount)&&(identical(other.discardTop, discardTop) || other.discardTop == discardTop)&&(identical(other.state, state) || other.state == state));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,roundNumber,drawPileCount,discardTop,state);

@override
String toString() {
  return 'RoundModel(roundNumber: $roundNumber, drawPileCount: $drawPileCount, discardTop: $discardTop, state: $state)';
}


}

/// @nodoc
abstract mixin class $RoundModelCopyWith<$Res>  {
  factory $RoundModelCopyWith(RoundModel value, $Res Function(RoundModel) _then) = _$RoundModelCopyWithImpl;
@useResult
$Res call({
 int roundNumber, int drawPileCount, CardModel? discardTop, GameRoundState state
});


$CardModelCopyWith<$Res>? get discardTop;

}
/// @nodoc
class _$RoundModelCopyWithImpl<$Res>
    implements $RoundModelCopyWith<$Res> {
  _$RoundModelCopyWithImpl(this._self, this._then);

  final RoundModel _self;
  final $Res Function(RoundModel) _then;

/// Create a copy of RoundModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? roundNumber = null,Object? drawPileCount = null,Object? discardTop = freezed,Object? state = null,}) {
  return _then(_self.copyWith(
roundNumber: null == roundNumber ? _self.roundNumber : roundNumber // ignore: cast_nullable_to_non_nullable
as int,drawPileCount: null == drawPileCount ? _self.drawPileCount : drawPileCount // ignore: cast_nullable_to_non_nullable
as int,discardTop: freezed == discardTop ? _self.discardTop : discardTop // ignore: cast_nullable_to_non_nullable
as CardModel?,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as GameRoundState,
  ));
}
/// Create a copy of RoundModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CardModelCopyWith<$Res>? get discardTop {
    if (_self.discardTop == null) {
    return null;
  }

  return $CardModelCopyWith<$Res>(_self.discardTop!, (value) {
    return _then(_self.copyWith(discardTop: value));
  });
}
}


/// Adds pattern-matching-related methods to [RoundModel].
extension RoundModelPatterns on RoundModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoundModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoundModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoundModel value)  $default,){
final _that = this;
switch (_that) {
case _RoundModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoundModel value)?  $default,){
final _that = this;
switch (_that) {
case _RoundModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int roundNumber,  int drawPileCount,  CardModel? discardTop,  GameRoundState state)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoundModel() when $default != null:
return $default(_that.roundNumber,_that.drawPileCount,_that.discardTop,_that.state);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int roundNumber,  int drawPileCount,  CardModel? discardTop,  GameRoundState state)  $default,) {final _that = this;
switch (_that) {
case _RoundModel():
return $default(_that.roundNumber,_that.drawPileCount,_that.discardTop,_that.state);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int roundNumber,  int drawPileCount,  CardModel? discardTop,  GameRoundState state)?  $default,) {final _that = this;
switch (_that) {
case _RoundModel() when $default != null:
return $default(_that.roundNumber,_that.drawPileCount,_that.discardTop,_that.state);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RoundModel extends RoundModel {
  const _RoundModel({required this.roundNumber, required this.drawPileCount, this.discardTop, required this.state}): super._();
  factory _RoundModel.fromJson(Map<String, dynamic> json) => _$RoundModelFromJson(json);

@override final  int roundNumber;
@override final  int drawPileCount;
@override final  CardModel? discardTop;
@override final  GameRoundState state;

/// Create a copy of RoundModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoundModelCopyWith<_RoundModel> get copyWith => __$RoundModelCopyWithImpl<_RoundModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoundModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoundModel&&(identical(other.roundNumber, roundNumber) || other.roundNumber == roundNumber)&&(identical(other.drawPileCount, drawPileCount) || other.drawPileCount == drawPileCount)&&(identical(other.discardTop, discardTop) || other.discardTop == discardTop)&&(identical(other.state, state) || other.state == state));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,roundNumber,drawPileCount,discardTop,state);

@override
String toString() {
  return 'RoundModel(roundNumber: $roundNumber, drawPileCount: $drawPileCount, discardTop: $discardTop, state: $state)';
}


}

/// @nodoc
abstract mixin class _$RoundModelCopyWith<$Res> implements $RoundModelCopyWith<$Res> {
  factory _$RoundModelCopyWith(_RoundModel value, $Res Function(_RoundModel) _then) = __$RoundModelCopyWithImpl;
@override @useResult
$Res call({
 int roundNumber, int drawPileCount, CardModel? discardTop, GameRoundState state
});


@override $CardModelCopyWith<$Res>? get discardTop;

}
/// @nodoc
class __$RoundModelCopyWithImpl<$Res>
    implements _$RoundModelCopyWith<$Res> {
  __$RoundModelCopyWithImpl(this._self, this._then);

  final _RoundModel _self;
  final $Res Function(_RoundModel) _then;

/// Create a copy of RoundModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? roundNumber = null,Object? drawPileCount = null,Object? discardTop = freezed,Object? state = null,}) {
  return _then(_RoundModel(
roundNumber: null == roundNumber ? _self.roundNumber : roundNumber // ignore: cast_nullable_to_non_nullable
as int,drawPileCount: null == drawPileCount ? _self.drawPileCount : drawPileCount // ignore: cast_nullable_to_non_nullable
as int,discardTop: freezed == discardTop ? _self.discardTop : discardTop // ignore: cast_nullable_to_non_nullable
as CardModel?,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as GameRoundState,
  ));
}

/// Create a copy of RoundModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CardModelCopyWith<$Res>? get discardTop {
    if (_self.discardTop == null) {
    return null;
  }

  return $CardModelCopyWith<$Res>(_self.discardTop!, (value) {
    return _then(_self.copyWith(discardTop: value));
  });
}
}

// dart format on
