// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'power_target_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PowerTargetDto {

 String get gameId; String get playerId; int get powerRank; String get targetPlayerId; int get targetPosition; String? get secondTargetPlayerId; int? get secondTargetPosition;
/// Create a copy of PowerTargetDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PowerTargetDtoCopyWith<PowerTargetDto> get copyWith => _$PowerTargetDtoCopyWithImpl<PowerTargetDto>(this as PowerTargetDto, _$identity);

  /// Serializes this PowerTargetDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PowerTargetDto&&(identical(other.gameId, gameId) || other.gameId == gameId)&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.powerRank, powerRank) || other.powerRank == powerRank)&&(identical(other.targetPlayerId, targetPlayerId) || other.targetPlayerId == targetPlayerId)&&(identical(other.targetPosition, targetPosition) || other.targetPosition == targetPosition)&&(identical(other.secondTargetPlayerId, secondTargetPlayerId) || other.secondTargetPlayerId == secondTargetPlayerId)&&(identical(other.secondTargetPosition, secondTargetPosition) || other.secondTargetPosition == secondTargetPosition));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gameId,playerId,powerRank,targetPlayerId,targetPosition,secondTargetPlayerId,secondTargetPosition);

@override
String toString() {
  return 'PowerTargetDto(gameId: $gameId, playerId: $playerId, powerRank: $powerRank, targetPlayerId: $targetPlayerId, targetPosition: $targetPosition, secondTargetPlayerId: $secondTargetPlayerId, secondTargetPosition: $secondTargetPosition)';
}


}

/// @nodoc
abstract mixin class $PowerTargetDtoCopyWith<$Res>  {
  factory $PowerTargetDtoCopyWith(PowerTargetDto value, $Res Function(PowerTargetDto) _then) = _$PowerTargetDtoCopyWithImpl;
@useResult
$Res call({
 String gameId, String playerId, int powerRank, String targetPlayerId, int targetPosition, String? secondTargetPlayerId, int? secondTargetPosition
});




}
/// @nodoc
class _$PowerTargetDtoCopyWithImpl<$Res>
    implements $PowerTargetDtoCopyWith<$Res> {
  _$PowerTargetDtoCopyWithImpl(this._self, this._then);

  final PowerTargetDto _self;
  final $Res Function(PowerTargetDto) _then;

/// Create a copy of PowerTargetDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? gameId = null,Object? playerId = null,Object? powerRank = null,Object? targetPlayerId = null,Object? targetPosition = null,Object? secondTargetPlayerId = freezed,Object? secondTargetPosition = freezed,}) {
  return _then(_self.copyWith(
gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,powerRank: null == powerRank ? _self.powerRank : powerRank // ignore: cast_nullable_to_non_nullable
as int,targetPlayerId: null == targetPlayerId ? _self.targetPlayerId : targetPlayerId // ignore: cast_nullable_to_non_nullable
as String,targetPosition: null == targetPosition ? _self.targetPosition : targetPosition // ignore: cast_nullable_to_non_nullable
as int,secondTargetPlayerId: freezed == secondTargetPlayerId ? _self.secondTargetPlayerId : secondTargetPlayerId // ignore: cast_nullable_to_non_nullable
as String?,secondTargetPosition: freezed == secondTargetPosition ? _self.secondTargetPosition : secondTargetPosition // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [PowerTargetDto].
extension PowerTargetDtoPatterns on PowerTargetDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PowerTargetDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PowerTargetDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PowerTargetDto value)  $default,){
final _that = this;
switch (_that) {
case _PowerTargetDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PowerTargetDto value)?  $default,){
final _that = this;
switch (_that) {
case _PowerTargetDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String gameId,  String playerId,  int powerRank,  String targetPlayerId,  int targetPosition,  String? secondTargetPlayerId,  int? secondTargetPosition)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PowerTargetDto() when $default != null:
return $default(_that.gameId,_that.playerId,_that.powerRank,_that.targetPlayerId,_that.targetPosition,_that.secondTargetPlayerId,_that.secondTargetPosition);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String gameId,  String playerId,  int powerRank,  String targetPlayerId,  int targetPosition,  String? secondTargetPlayerId,  int? secondTargetPosition)  $default,) {final _that = this;
switch (_that) {
case _PowerTargetDto():
return $default(_that.gameId,_that.playerId,_that.powerRank,_that.targetPlayerId,_that.targetPosition,_that.secondTargetPlayerId,_that.secondTargetPosition);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String gameId,  String playerId,  int powerRank,  String targetPlayerId,  int targetPosition,  String? secondTargetPlayerId,  int? secondTargetPosition)?  $default,) {final _that = this;
switch (_that) {
case _PowerTargetDto() when $default != null:
return $default(_that.gameId,_that.playerId,_that.powerRank,_that.targetPlayerId,_that.targetPosition,_that.secondTargetPlayerId,_that.secondTargetPosition);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PowerTargetDto implements PowerTargetDto {
  const _PowerTargetDto({required this.gameId, required this.playerId, required this.powerRank, required this.targetPlayerId, required this.targetPosition, this.secondTargetPlayerId, this.secondTargetPosition});
  factory _PowerTargetDto.fromJson(Map<String, dynamic> json) => _$PowerTargetDtoFromJson(json);

@override final  String gameId;
@override final  String playerId;
@override final  int powerRank;
@override final  String targetPlayerId;
@override final  int targetPosition;
@override final  String? secondTargetPlayerId;
@override final  int? secondTargetPosition;

/// Create a copy of PowerTargetDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PowerTargetDtoCopyWith<_PowerTargetDto> get copyWith => __$PowerTargetDtoCopyWithImpl<_PowerTargetDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PowerTargetDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PowerTargetDto&&(identical(other.gameId, gameId) || other.gameId == gameId)&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.powerRank, powerRank) || other.powerRank == powerRank)&&(identical(other.targetPlayerId, targetPlayerId) || other.targetPlayerId == targetPlayerId)&&(identical(other.targetPosition, targetPosition) || other.targetPosition == targetPosition)&&(identical(other.secondTargetPlayerId, secondTargetPlayerId) || other.secondTargetPlayerId == secondTargetPlayerId)&&(identical(other.secondTargetPosition, secondTargetPosition) || other.secondTargetPosition == secondTargetPosition));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gameId,playerId,powerRank,targetPlayerId,targetPosition,secondTargetPlayerId,secondTargetPosition);

@override
String toString() {
  return 'PowerTargetDto(gameId: $gameId, playerId: $playerId, powerRank: $powerRank, targetPlayerId: $targetPlayerId, targetPosition: $targetPosition, secondTargetPlayerId: $secondTargetPlayerId, secondTargetPosition: $secondTargetPosition)';
}


}

/// @nodoc
abstract mixin class _$PowerTargetDtoCopyWith<$Res> implements $PowerTargetDtoCopyWith<$Res> {
  factory _$PowerTargetDtoCopyWith(_PowerTargetDto value, $Res Function(_PowerTargetDto) _then) = __$PowerTargetDtoCopyWithImpl;
@override @useResult
$Res call({
 String gameId, String playerId, int powerRank, String targetPlayerId, int targetPosition, String? secondTargetPlayerId, int? secondTargetPosition
});




}
/// @nodoc
class __$PowerTargetDtoCopyWithImpl<$Res>
    implements _$PowerTargetDtoCopyWith<$Res> {
  __$PowerTargetDtoCopyWithImpl(this._self, this._then);

  final _PowerTargetDto _self;
  final $Res Function(_PowerTargetDto) _then;

/// Create a copy of PowerTargetDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? gameId = null,Object? playerId = null,Object? powerRank = null,Object? targetPlayerId = null,Object? targetPosition = null,Object? secondTargetPlayerId = freezed,Object? secondTargetPosition = freezed,}) {
  return _then(_PowerTargetDto(
gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,powerRank: null == powerRank ? _self.powerRank : powerRank // ignore: cast_nullable_to_non_nullable
as int,targetPlayerId: null == targetPlayerId ? _self.targetPlayerId : targetPlayerId // ignore: cast_nullable_to_non_nullable
as String,targetPosition: null == targetPosition ? _self.targetPosition : targetPosition // ignore: cast_nullable_to_non_nullable
as int,secondTargetPlayerId: freezed == secondTargetPlayerId ? _self.secondTargetPlayerId : secondTargetPlayerId // ignore: cast_nullable_to_non_nullable
as String?,secondTargetPosition: freezed == secondTargetPosition ? _self.secondTargetPosition : secondTargetPosition // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
