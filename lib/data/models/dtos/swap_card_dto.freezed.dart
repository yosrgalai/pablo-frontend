// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'swap_card_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SwapCardDto {

 String get gameId; String get playerId; String get drawnCardId; int get handPosition;
/// Create a copy of SwapCardDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SwapCardDtoCopyWith<SwapCardDto> get copyWith => _$SwapCardDtoCopyWithImpl<SwapCardDto>(this as SwapCardDto, _$identity);

  /// Serializes this SwapCardDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SwapCardDto&&(identical(other.gameId, gameId) || other.gameId == gameId)&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.drawnCardId, drawnCardId) || other.drawnCardId == drawnCardId)&&(identical(other.handPosition, handPosition) || other.handPosition == handPosition));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gameId,playerId,drawnCardId,handPosition);

@override
String toString() {
  return 'SwapCardDto(gameId: $gameId, playerId: $playerId, drawnCardId: $drawnCardId, handPosition: $handPosition)';
}


}

/// @nodoc
abstract mixin class $SwapCardDtoCopyWith<$Res>  {
  factory $SwapCardDtoCopyWith(SwapCardDto value, $Res Function(SwapCardDto) _then) = _$SwapCardDtoCopyWithImpl;
@useResult
$Res call({
 String gameId, String playerId, String drawnCardId, int handPosition
});




}
/// @nodoc
class _$SwapCardDtoCopyWithImpl<$Res>
    implements $SwapCardDtoCopyWith<$Res> {
  _$SwapCardDtoCopyWithImpl(this._self, this._then);

  final SwapCardDto _self;
  final $Res Function(SwapCardDto) _then;

/// Create a copy of SwapCardDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? gameId = null,Object? playerId = null,Object? drawnCardId = null,Object? handPosition = null,}) {
  return _then(_self.copyWith(
gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,drawnCardId: null == drawnCardId ? _self.drawnCardId : drawnCardId // ignore: cast_nullable_to_non_nullable
as String,handPosition: null == handPosition ? _self.handPosition : handPosition // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SwapCardDto].
extension SwapCardDtoPatterns on SwapCardDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SwapCardDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SwapCardDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SwapCardDto value)  $default,){
final _that = this;
switch (_that) {
case _SwapCardDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SwapCardDto value)?  $default,){
final _that = this;
switch (_that) {
case _SwapCardDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String gameId,  String playerId,  String drawnCardId,  int handPosition)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SwapCardDto() when $default != null:
return $default(_that.gameId,_that.playerId,_that.drawnCardId,_that.handPosition);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String gameId,  String playerId,  String drawnCardId,  int handPosition)  $default,) {final _that = this;
switch (_that) {
case _SwapCardDto():
return $default(_that.gameId,_that.playerId,_that.drawnCardId,_that.handPosition);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String gameId,  String playerId,  String drawnCardId,  int handPosition)?  $default,) {final _that = this;
switch (_that) {
case _SwapCardDto() when $default != null:
return $default(_that.gameId,_that.playerId,_that.drawnCardId,_that.handPosition);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SwapCardDto implements SwapCardDto {
  const _SwapCardDto({required this.gameId, required this.playerId, required this.drawnCardId, required this.handPosition});
  factory _SwapCardDto.fromJson(Map<String, dynamic> json) => _$SwapCardDtoFromJson(json);

@override final  String gameId;
@override final  String playerId;
@override final  String drawnCardId;
@override final  int handPosition;

/// Create a copy of SwapCardDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SwapCardDtoCopyWith<_SwapCardDto> get copyWith => __$SwapCardDtoCopyWithImpl<_SwapCardDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SwapCardDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SwapCardDto&&(identical(other.gameId, gameId) || other.gameId == gameId)&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.drawnCardId, drawnCardId) || other.drawnCardId == drawnCardId)&&(identical(other.handPosition, handPosition) || other.handPosition == handPosition));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gameId,playerId,drawnCardId,handPosition);

@override
String toString() {
  return 'SwapCardDto(gameId: $gameId, playerId: $playerId, drawnCardId: $drawnCardId, handPosition: $handPosition)';
}


}

/// @nodoc
abstract mixin class _$SwapCardDtoCopyWith<$Res> implements $SwapCardDtoCopyWith<$Res> {
  factory _$SwapCardDtoCopyWith(_SwapCardDto value, $Res Function(_SwapCardDto) _then) = __$SwapCardDtoCopyWithImpl;
@override @useResult
$Res call({
 String gameId, String playerId, String drawnCardId, int handPosition
});




}
/// @nodoc
class __$SwapCardDtoCopyWithImpl<$Res>
    implements _$SwapCardDtoCopyWith<$Res> {
  __$SwapCardDtoCopyWithImpl(this._self, this._then);

  final _SwapCardDto _self;
  final $Res Function(_SwapCardDto) _then;

/// Create a copy of SwapCardDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? gameId = null,Object? playerId = null,Object? drawnCardId = null,Object? handPosition = null,}) {
  return _then(_SwapCardDto(
gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,drawnCardId: null == drawnCardId ? _self.drawnCardId : drawnCardId // ignore: cast_nullable_to_non_nullable
as String,handPosition: null == handPosition ? _self.handPosition : handPosition // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
