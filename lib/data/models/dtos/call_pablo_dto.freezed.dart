// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_pablo_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallPabloDto {

 String get gameId; String get playerId;
/// Create a copy of CallPabloDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallPabloDtoCopyWith<CallPabloDto> get copyWith => _$CallPabloDtoCopyWithImpl<CallPabloDto>(this as CallPabloDto, _$identity);

  /// Serializes this CallPabloDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallPabloDto&&(identical(other.gameId, gameId) || other.gameId == gameId)&&(identical(other.playerId, playerId) || other.playerId == playerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gameId,playerId);

@override
String toString() {
  return 'CallPabloDto(gameId: $gameId, playerId: $playerId)';
}


}

/// @nodoc
abstract mixin class $CallPabloDtoCopyWith<$Res>  {
  factory $CallPabloDtoCopyWith(CallPabloDto value, $Res Function(CallPabloDto) _then) = _$CallPabloDtoCopyWithImpl;
@useResult
$Res call({
 String gameId, String playerId
});




}
/// @nodoc
class _$CallPabloDtoCopyWithImpl<$Res>
    implements $CallPabloDtoCopyWith<$Res> {
  _$CallPabloDtoCopyWithImpl(this._self, this._then);

  final CallPabloDto _self;
  final $Res Function(CallPabloDto) _then;

/// Create a copy of CallPabloDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? gameId = null,Object? playerId = null,}) {
  return _then(_self.copyWith(
gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CallPabloDto].
extension CallPabloDtoPatterns on CallPabloDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallPabloDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallPabloDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallPabloDto value)  $default,){
final _that = this;
switch (_that) {
case _CallPabloDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallPabloDto value)?  $default,){
final _that = this;
switch (_that) {
case _CallPabloDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String gameId,  String playerId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallPabloDto() when $default != null:
return $default(_that.gameId,_that.playerId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String gameId,  String playerId)  $default,) {final _that = this;
switch (_that) {
case _CallPabloDto():
return $default(_that.gameId,_that.playerId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String gameId,  String playerId)?  $default,) {final _that = this;
switch (_that) {
case _CallPabloDto() when $default != null:
return $default(_that.gameId,_that.playerId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CallPabloDto implements CallPabloDto {
  const _CallPabloDto({required this.gameId, required this.playerId});
  factory _CallPabloDto.fromJson(Map<String, dynamic> json) => _$CallPabloDtoFromJson(json);

@override final  String gameId;
@override final  String playerId;

/// Create a copy of CallPabloDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallPabloDtoCopyWith<_CallPabloDto> get copyWith => __$CallPabloDtoCopyWithImpl<_CallPabloDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CallPabloDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallPabloDto&&(identical(other.gameId, gameId) || other.gameId == gameId)&&(identical(other.playerId, playerId) || other.playerId == playerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gameId,playerId);

@override
String toString() {
  return 'CallPabloDto(gameId: $gameId, playerId: $playerId)';
}


}

/// @nodoc
abstract mixin class _$CallPabloDtoCopyWith<$Res> implements $CallPabloDtoCopyWith<$Res> {
  factory _$CallPabloDtoCopyWith(_CallPabloDto value, $Res Function(_CallPabloDto) _then) = __$CallPabloDtoCopyWithImpl;
@override @useResult
$Res call({
 String gameId, String playerId
});




}
/// @nodoc
class __$CallPabloDtoCopyWithImpl<$Res>
    implements _$CallPabloDtoCopyWith<$Res> {
  __$CallPabloDtoCopyWithImpl(this._self, this._then);

  final _CallPabloDto _self;
  final $Res Function(_CallPabloDto) _then;

/// Create a copy of CallPabloDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? gameId = null,Object? playerId = null,}) {
  return _then(_CallPabloDto(
gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
