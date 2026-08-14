// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discard_card_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DiscardCardDto {

 String get gameId; String get playerId; String get drawnCardId; bool? get usePower;
/// Create a copy of DiscardCardDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscardCardDtoCopyWith<DiscardCardDto> get copyWith => _$DiscardCardDtoCopyWithImpl<DiscardCardDto>(this as DiscardCardDto, _$identity);

  /// Serializes this DiscardCardDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscardCardDto&&(identical(other.gameId, gameId) || other.gameId == gameId)&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.drawnCardId, drawnCardId) || other.drawnCardId == drawnCardId)&&(identical(other.usePower, usePower) || other.usePower == usePower));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gameId,playerId,drawnCardId,usePower);

@override
String toString() {
  return 'DiscardCardDto(gameId: $gameId, playerId: $playerId, drawnCardId: $drawnCardId, usePower: $usePower)';
}


}

/// @nodoc
abstract mixin class $DiscardCardDtoCopyWith<$Res>  {
  factory $DiscardCardDtoCopyWith(DiscardCardDto value, $Res Function(DiscardCardDto) _then) = _$DiscardCardDtoCopyWithImpl;
@useResult
$Res call({
 String gameId, String playerId, String drawnCardId, bool? usePower
});




}
/// @nodoc
class _$DiscardCardDtoCopyWithImpl<$Res>
    implements $DiscardCardDtoCopyWith<$Res> {
  _$DiscardCardDtoCopyWithImpl(this._self, this._then);

  final DiscardCardDto _self;
  final $Res Function(DiscardCardDto) _then;

/// Create a copy of DiscardCardDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? gameId = null,Object? playerId = null,Object? drawnCardId = null,Object? usePower = freezed,}) {
  return _then(_self.copyWith(
gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,drawnCardId: null == drawnCardId ? _self.drawnCardId : drawnCardId // ignore: cast_nullable_to_non_nullable
as String,usePower: freezed == usePower ? _self.usePower : usePower // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [DiscardCardDto].
extension DiscardCardDtoPatterns on DiscardCardDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiscardCardDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiscardCardDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiscardCardDto value)  $default,){
final _that = this;
switch (_that) {
case _DiscardCardDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiscardCardDto value)?  $default,){
final _that = this;
switch (_that) {
case _DiscardCardDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String gameId,  String playerId,  String drawnCardId,  bool? usePower)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiscardCardDto() when $default != null:
return $default(_that.gameId,_that.playerId,_that.drawnCardId,_that.usePower);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String gameId,  String playerId,  String drawnCardId,  bool? usePower)  $default,) {final _that = this;
switch (_that) {
case _DiscardCardDto():
return $default(_that.gameId,_that.playerId,_that.drawnCardId,_that.usePower);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String gameId,  String playerId,  String drawnCardId,  bool? usePower)?  $default,) {final _that = this;
switch (_that) {
case _DiscardCardDto() when $default != null:
return $default(_that.gameId,_that.playerId,_that.drawnCardId,_that.usePower);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiscardCardDto implements DiscardCardDto {
  const _DiscardCardDto({required this.gameId, required this.playerId, required this.drawnCardId, this.usePower});
  factory _DiscardCardDto.fromJson(Map<String, dynamic> json) => _$DiscardCardDtoFromJson(json);

@override final  String gameId;
@override final  String playerId;
@override final  String drawnCardId;
@override final  bool? usePower;

/// Create a copy of DiscardCardDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscardCardDtoCopyWith<_DiscardCardDto> get copyWith => __$DiscardCardDtoCopyWithImpl<_DiscardCardDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiscardCardDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscardCardDto&&(identical(other.gameId, gameId) || other.gameId == gameId)&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.drawnCardId, drawnCardId) || other.drawnCardId == drawnCardId)&&(identical(other.usePower, usePower) || other.usePower == usePower));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gameId,playerId,drawnCardId,usePower);

@override
String toString() {
  return 'DiscardCardDto(gameId: $gameId, playerId: $playerId, drawnCardId: $drawnCardId, usePower: $usePower)';
}


}

/// @nodoc
abstract mixin class _$DiscardCardDtoCopyWith<$Res> implements $DiscardCardDtoCopyWith<$Res> {
  factory _$DiscardCardDtoCopyWith(_DiscardCardDto value, $Res Function(_DiscardCardDto) _then) = __$DiscardCardDtoCopyWithImpl;
@override @useResult
$Res call({
 String gameId, String playerId, String drawnCardId, bool? usePower
});




}
/// @nodoc
class __$DiscardCardDtoCopyWithImpl<$Res>
    implements _$DiscardCardDtoCopyWith<$Res> {
  __$DiscardCardDtoCopyWithImpl(this._self, this._then);

  final _DiscardCardDto _self;
  final $Res Function(_DiscardCardDto) _then;

/// Create a copy of DiscardCardDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? gameId = null,Object? playerId = null,Object? drawnCardId = null,Object? usePower = freezed,}) {
  return _then(_DiscardCardDto(
gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,drawnCardId: null == drawnCardId ? _self.drawnCardId : drawnCardId // ignore: cast_nullable_to_non_nullable
as String,usePower: freezed == usePower ? _self.usePower : usePower // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
