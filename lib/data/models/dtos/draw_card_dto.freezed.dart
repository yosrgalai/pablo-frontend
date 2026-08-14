// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'draw_card_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DrawCardDto {

 String get gameId; String get playerId;
/// Create a copy of DrawCardDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DrawCardDtoCopyWith<DrawCardDto> get copyWith => _$DrawCardDtoCopyWithImpl<DrawCardDto>(this as DrawCardDto, _$identity);

  /// Serializes this DrawCardDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DrawCardDto&&(identical(other.gameId, gameId) || other.gameId == gameId)&&(identical(other.playerId, playerId) || other.playerId == playerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gameId,playerId);

@override
String toString() {
  return 'DrawCardDto(gameId: $gameId, playerId: $playerId)';
}


}

/// @nodoc
abstract mixin class $DrawCardDtoCopyWith<$Res>  {
  factory $DrawCardDtoCopyWith(DrawCardDto value, $Res Function(DrawCardDto) _then) = _$DrawCardDtoCopyWithImpl;
@useResult
$Res call({
 String gameId, String playerId
});




}
/// @nodoc
class _$DrawCardDtoCopyWithImpl<$Res>
    implements $DrawCardDtoCopyWith<$Res> {
  _$DrawCardDtoCopyWithImpl(this._self, this._then);

  final DrawCardDto _self;
  final $Res Function(DrawCardDto) _then;

/// Create a copy of DrawCardDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? gameId = null,Object? playerId = null,}) {
  return _then(_self.copyWith(
gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DrawCardDto].
extension DrawCardDtoPatterns on DrawCardDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DrawCardDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DrawCardDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DrawCardDto value)  $default,){
final _that = this;
switch (_that) {
case _DrawCardDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DrawCardDto value)?  $default,){
final _that = this;
switch (_that) {
case _DrawCardDto() when $default != null:
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
case _DrawCardDto() when $default != null:
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
case _DrawCardDto():
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
case _DrawCardDto() when $default != null:
return $default(_that.gameId,_that.playerId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DrawCardDto implements DrawCardDto {
  const _DrawCardDto({required this.gameId, required this.playerId});
  factory _DrawCardDto.fromJson(Map<String, dynamic> json) => _$DrawCardDtoFromJson(json);

@override final  String gameId;
@override final  String playerId;

/// Create a copy of DrawCardDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DrawCardDtoCopyWith<_DrawCardDto> get copyWith => __$DrawCardDtoCopyWithImpl<_DrawCardDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DrawCardDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DrawCardDto&&(identical(other.gameId, gameId) || other.gameId == gameId)&&(identical(other.playerId, playerId) || other.playerId == playerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gameId,playerId);

@override
String toString() {
  return 'DrawCardDto(gameId: $gameId, playerId: $playerId)';
}


}

/// @nodoc
abstract mixin class _$DrawCardDtoCopyWith<$Res> implements $DrawCardDtoCopyWith<$Res> {
  factory _$DrawCardDtoCopyWith(_DrawCardDto value, $Res Function(_DrawCardDto) _then) = __$DrawCardDtoCopyWithImpl;
@override @useResult
$Res call({
 String gameId, String playerId
});




}
/// @nodoc
class __$DrawCardDtoCopyWithImpl<$Res>
    implements _$DrawCardDtoCopyWith<$Res> {
  __$DrawCardDtoCopyWithImpl(this._self, this._then);

  final _DrawCardDto _self;
  final $Res Function(_DrawCardDto) _then;

/// Create a copy of DrawCardDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? gameId = null,Object? playerId = null,}) {
  return _then(_DrawCardDto(
gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
