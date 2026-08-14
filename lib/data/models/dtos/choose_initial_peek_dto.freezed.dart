// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'choose_initial_peek_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChooseInitialPeekDto {

 String get gameId; String get playerId; List<int> get positions;
/// Create a copy of ChooseInitialPeekDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChooseInitialPeekDtoCopyWith<ChooseInitialPeekDto> get copyWith => _$ChooseInitialPeekDtoCopyWithImpl<ChooseInitialPeekDto>(this as ChooseInitialPeekDto, _$identity);

  /// Serializes this ChooseInitialPeekDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChooseInitialPeekDto&&(identical(other.gameId, gameId) || other.gameId == gameId)&&(identical(other.playerId, playerId) || other.playerId == playerId)&&const DeepCollectionEquality().equals(other.positions, positions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gameId,playerId,const DeepCollectionEquality().hash(positions));

@override
String toString() {
  return 'ChooseInitialPeekDto(gameId: $gameId, playerId: $playerId, positions: $positions)';
}


}

/// @nodoc
abstract mixin class $ChooseInitialPeekDtoCopyWith<$Res>  {
  factory $ChooseInitialPeekDtoCopyWith(ChooseInitialPeekDto value, $Res Function(ChooseInitialPeekDto) _then) = _$ChooseInitialPeekDtoCopyWithImpl;
@useResult
$Res call({
 String gameId, String playerId, List<int> positions
});




}
/// @nodoc
class _$ChooseInitialPeekDtoCopyWithImpl<$Res>
    implements $ChooseInitialPeekDtoCopyWith<$Res> {
  _$ChooseInitialPeekDtoCopyWithImpl(this._self, this._then);

  final ChooseInitialPeekDto _self;
  final $Res Function(ChooseInitialPeekDto) _then;

/// Create a copy of ChooseInitialPeekDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? gameId = null,Object? playerId = null,Object? positions = null,}) {
  return _then(_self.copyWith(
gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,positions: null == positions ? _self.positions : positions // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [ChooseInitialPeekDto].
extension ChooseInitialPeekDtoPatterns on ChooseInitialPeekDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChooseInitialPeekDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChooseInitialPeekDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChooseInitialPeekDto value)  $default,){
final _that = this;
switch (_that) {
case _ChooseInitialPeekDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChooseInitialPeekDto value)?  $default,){
final _that = this;
switch (_that) {
case _ChooseInitialPeekDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String gameId,  String playerId,  List<int> positions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChooseInitialPeekDto() when $default != null:
return $default(_that.gameId,_that.playerId,_that.positions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String gameId,  String playerId,  List<int> positions)  $default,) {final _that = this;
switch (_that) {
case _ChooseInitialPeekDto():
return $default(_that.gameId,_that.playerId,_that.positions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String gameId,  String playerId,  List<int> positions)?  $default,) {final _that = this;
switch (_that) {
case _ChooseInitialPeekDto() when $default != null:
return $default(_that.gameId,_that.playerId,_that.positions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChooseInitialPeekDto implements ChooseInitialPeekDto {
  const _ChooseInitialPeekDto({required this.gameId, required this.playerId, required final  List<int> positions}): _positions = positions;
  factory _ChooseInitialPeekDto.fromJson(Map<String, dynamic> json) => _$ChooseInitialPeekDtoFromJson(json);

@override final  String gameId;
@override final  String playerId;
 final  List<int> _positions;
@override List<int> get positions {
  if (_positions is EqualUnmodifiableListView) return _positions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_positions);
}


/// Create a copy of ChooseInitialPeekDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChooseInitialPeekDtoCopyWith<_ChooseInitialPeekDto> get copyWith => __$ChooseInitialPeekDtoCopyWithImpl<_ChooseInitialPeekDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChooseInitialPeekDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChooseInitialPeekDto&&(identical(other.gameId, gameId) || other.gameId == gameId)&&(identical(other.playerId, playerId) || other.playerId == playerId)&&const DeepCollectionEquality().equals(other._positions, _positions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gameId,playerId,const DeepCollectionEquality().hash(_positions));

@override
String toString() {
  return 'ChooseInitialPeekDto(gameId: $gameId, playerId: $playerId, positions: $positions)';
}


}

/// @nodoc
abstract mixin class _$ChooseInitialPeekDtoCopyWith<$Res> implements $ChooseInitialPeekDtoCopyWith<$Res> {
  factory _$ChooseInitialPeekDtoCopyWith(_ChooseInitialPeekDto value, $Res Function(_ChooseInitialPeekDto) _then) = __$ChooseInitialPeekDtoCopyWithImpl;
@override @useResult
$Res call({
 String gameId, String playerId, List<int> positions
});




}
/// @nodoc
class __$ChooseInitialPeekDtoCopyWithImpl<$Res>
    implements _$ChooseInitialPeekDtoCopyWith<$Res> {
  __$ChooseInitialPeekDtoCopyWithImpl(this._self, this._then);

  final _ChooseInitialPeekDto _self;
  final $Res Function(_ChooseInitialPeekDto) _then;

/// Create a copy of ChooseInitialPeekDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? gameId = null,Object? playerId = null,Object? positions = null,}) {
  return _then(_ChooseInitialPeekDto(
gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,positions: null == positions ? _self._positions : positions // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

// dart format on
