// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pair_attempt_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PairAttemptDto {

 String get gameId; String get playerId; int get firstPosition; int get secondPosition;
/// Create a copy of PairAttemptDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PairAttemptDtoCopyWith<PairAttemptDto> get copyWith => _$PairAttemptDtoCopyWithImpl<PairAttemptDto>(this as PairAttemptDto, _$identity);

  /// Serializes this PairAttemptDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PairAttemptDto&&(identical(other.gameId, gameId) || other.gameId == gameId)&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.firstPosition, firstPosition) || other.firstPosition == firstPosition)&&(identical(other.secondPosition, secondPosition) || other.secondPosition == secondPosition));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gameId,playerId,firstPosition,secondPosition);

@override
String toString() {
  return 'PairAttemptDto(gameId: $gameId, playerId: $playerId, firstPosition: $firstPosition, secondPosition: $secondPosition)';
}


}

/// @nodoc
abstract mixin class $PairAttemptDtoCopyWith<$Res>  {
  factory $PairAttemptDtoCopyWith(PairAttemptDto value, $Res Function(PairAttemptDto) _then) = _$PairAttemptDtoCopyWithImpl;
@useResult
$Res call({
 String gameId, String playerId, int firstPosition, int secondPosition
});




}
/// @nodoc
class _$PairAttemptDtoCopyWithImpl<$Res>
    implements $PairAttemptDtoCopyWith<$Res> {
  _$PairAttemptDtoCopyWithImpl(this._self, this._then);

  final PairAttemptDto _self;
  final $Res Function(PairAttemptDto) _then;

/// Create a copy of PairAttemptDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? gameId = null,Object? playerId = null,Object? firstPosition = null,Object? secondPosition = null,}) {
  return _then(_self.copyWith(
gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,firstPosition: null == firstPosition ? _self.firstPosition : firstPosition // ignore: cast_nullable_to_non_nullable
as int,secondPosition: null == secondPosition ? _self.secondPosition : secondPosition // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PairAttemptDto].
extension PairAttemptDtoPatterns on PairAttemptDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PairAttemptDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PairAttemptDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PairAttemptDto value)  $default,){
final _that = this;
switch (_that) {
case _PairAttemptDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PairAttemptDto value)?  $default,){
final _that = this;
switch (_that) {
case _PairAttemptDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String gameId,  String playerId,  int firstPosition,  int secondPosition)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PairAttemptDto() when $default != null:
return $default(_that.gameId,_that.playerId,_that.firstPosition,_that.secondPosition);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String gameId,  String playerId,  int firstPosition,  int secondPosition)  $default,) {final _that = this;
switch (_that) {
case _PairAttemptDto():
return $default(_that.gameId,_that.playerId,_that.firstPosition,_that.secondPosition);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String gameId,  String playerId,  int firstPosition,  int secondPosition)?  $default,) {final _that = this;
switch (_that) {
case _PairAttemptDto() when $default != null:
return $default(_that.gameId,_that.playerId,_that.firstPosition,_that.secondPosition);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PairAttemptDto implements PairAttemptDto {
  const _PairAttemptDto({required this.gameId, required this.playerId, required this.firstPosition, required this.secondPosition});
  factory _PairAttemptDto.fromJson(Map<String, dynamic> json) => _$PairAttemptDtoFromJson(json);

@override final  String gameId;
@override final  String playerId;
@override final  int firstPosition;
@override final  int secondPosition;

/// Create a copy of PairAttemptDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PairAttemptDtoCopyWith<_PairAttemptDto> get copyWith => __$PairAttemptDtoCopyWithImpl<_PairAttemptDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PairAttemptDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PairAttemptDto&&(identical(other.gameId, gameId) || other.gameId == gameId)&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.firstPosition, firstPosition) || other.firstPosition == firstPosition)&&(identical(other.secondPosition, secondPosition) || other.secondPosition == secondPosition));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gameId,playerId,firstPosition,secondPosition);

@override
String toString() {
  return 'PairAttemptDto(gameId: $gameId, playerId: $playerId, firstPosition: $firstPosition, secondPosition: $secondPosition)';
}


}

/// @nodoc
abstract mixin class _$PairAttemptDtoCopyWith<$Res> implements $PairAttemptDtoCopyWith<$Res> {
  factory _$PairAttemptDtoCopyWith(_PairAttemptDto value, $Res Function(_PairAttemptDto) _then) = __$PairAttemptDtoCopyWithImpl;
@override @useResult
$Res call({
 String gameId, String playerId, int firstPosition, int secondPosition
});




}
/// @nodoc
class __$PairAttemptDtoCopyWithImpl<$Res>
    implements _$PairAttemptDtoCopyWith<$Res> {
  __$PairAttemptDtoCopyWithImpl(this._self, this._then);

  final _PairAttemptDto _self;
  final $Res Function(_PairAttemptDto) _then;

/// Create a copy of PairAttemptDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? gameId = null,Object? playerId = null,Object? firstPosition = null,Object? secondPosition = null,}) {
  return _then(_PairAttemptDto(
gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,firstPosition: null == firstPosition ? _self.firstPosition : firstPosition // ignore: cast_nullable_to_non_nullable
as int,secondPosition: null == secondPosition ? _self.secondPosition : secondPosition // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
