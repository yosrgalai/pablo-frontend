// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_game_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateGameDto {

 int get scoreLimit; List<String> get playerNames;
/// Create a copy of CreateGameDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateGameDtoCopyWith<CreateGameDto> get copyWith => _$CreateGameDtoCopyWithImpl<CreateGameDto>(this as CreateGameDto, _$identity);

  /// Serializes this CreateGameDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateGameDto&&(identical(other.scoreLimit, scoreLimit) || other.scoreLimit == scoreLimit)&&const DeepCollectionEquality().equals(other.playerNames, playerNames));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,scoreLimit,const DeepCollectionEquality().hash(playerNames));

@override
String toString() {
  return 'CreateGameDto(scoreLimit: $scoreLimit, playerNames: $playerNames)';
}


}

/// @nodoc
abstract mixin class $CreateGameDtoCopyWith<$Res>  {
  factory $CreateGameDtoCopyWith(CreateGameDto value, $Res Function(CreateGameDto) _then) = _$CreateGameDtoCopyWithImpl;
@useResult
$Res call({
 int scoreLimit, List<String> playerNames
});




}
/// @nodoc
class _$CreateGameDtoCopyWithImpl<$Res>
    implements $CreateGameDtoCopyWith<$Res> {
  _$CreateGameDtoCopyWithImpl(this._self, this._then);

  final CreateGameDto _self;
  final $Res Function(CreateGameDto) _then;

/// Create a copy of CreateGameDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scoreLimit = null,Object? playerNames = null,}) {
  return _then(_self.copyWith(
scoreLimit: null == scoreLimit ? _self.scoreLimit : scoreLimit // ignore: cast_nullable_to_non_nullable
as int,playerNames: null == playerNames ? _self.playerNames : playerNames // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateGameDto].
extension CreateGameDtoPatterns on CreateGameDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateGameDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateGameDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateGameDto value)  $default,){
final _that = this;
switch (_that) {
case _CreateGameDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateGameDto value)?  $default,){
final _that = this;
switch (_that) {
case _CreateGameDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int scoreLimit,  List<String> playerNames)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateGameDto() when $default != null:
return $default(_that.scoreLimit,_that.playerNames);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int scoreLimit,  List<String> playerNames)  $default,) {final _that = this;
switch (_that) {
case _CreateGameDto():
return $default(_that.scoreLimit,_that.playerNames);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int scoreLimit,  List<String> playerNames)?  $default,) {final _that = this;
switch (_that) {
case _CreateGameDto() when $default != null:
return $default(_that.scoreLimit,_that.playerNames);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateGameDto implements CreateGameDto {
  const _CreateGameDto({required this.scoreLimit, required final  List<String> playerNames}): _playerNames = playerNames;
  factory _CreateGameDto.fromJson(Map<String, dynamic> json) => _$CreateGameDtoFromJson(json);

@override final  int scoreLimit;
 final  List<String> _playerNames;
@override List<String> get playerNames {
  if (_playerNames is EqualUnmodifiableListView) return _playerNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_playerNames);
}


/// Create a copy of CreateGameDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateGameDtoCopyWith<_CreateGameDto> get copyWith => __$CreateGameDtoCopyWithImpl<_CreateGameDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateGameDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateGameDto&&(identical(other.scoreLimit, scoreLimit) || other.scoreLimit == scoreLimit)&&const DeepCollectionEquality().equals(other._playerNames, _playerNames));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,scoreLimit,const DeepCollectionEquality().hash(_playerNames));

@override
String toString() {
  return 'CreateGameDto(scoreLimit: $scoreLimit, playerNames: $playerNames)';
}


}

/// @nodoc
abstract mixin class _$CreateGameDtoCopyWith<$Res> implements $CreateGameDtoCopyWith<$Res> {
  factory _$CreateGameDtoCopyWith(_CreateGameDto value, $Res Function(_CreateGameDto) _then) = __$CreateGameDtoCopyWithImpl;
@override @useResult
$Res call({
 int scoreLimit, List<String> playerNames
});




}
/// @nodoc
class __$CreateGameDtoCopyWithImpl<$Res>
    implements _$CreateGameDtoCopyWith<$Res> {
  __$CreateGameDtoCopyWithImpl(this._self, this._then);

  final _CreateGameDto _self;
  final $Res Function(_CreateGameDto) _then;

/// Create a copy of CreateGameDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scoreLimit = null,Object? playerNames = null,}) {
  return _then(_CreateGameDto(
scoreLimit: null == scoreLimit ? _self.scoreLimit : scoreLimit // ignore: cast_nullable_to_non_nullable
as int,playerNames: null == playerNames ? _self._playerNames : playerNames // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
