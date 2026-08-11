// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'start_game_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StartGameDto _$StartGameDtoFromJson(Map<String, dynamic> json) {
  return _StartGameDto.fromJson(json);
}

/// @nodoc
mixin _$StartGameDto {
  String get gameId => throw _privateConstructorUsedError;

  /// Serializes this StartGameDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StartGameDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StartGameDtoCopyWith<StartGameDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StartGameDtoCopyWith<$Res> {
  factory $StartGameDtoCopyWith(
    StartGameDto value,
    $Res Function(StartGameDto) then,
  ) = _$StartGameDtoCopyWithImpl<$Res, StartGameDto>;
  @useResult
  $Res call({String gameId});
}

/// @nodoc
class _$StartGameDtoCopyWithImpl<$Res, $Val extends StartGameDto>
    implements $StartGameDtoCopyWith<$Res> {
  _$StartGameDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StartGameDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? gameId = null}) {
    return _then(
      _value.copyWith(
            gameId: null == gameId
                ? _value.gameId
                : gameId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StartGameDtoImplCopyWith<$Res>
    implements $StartGameDtoCopyWith<$Res> {
  factory _$$StartGameDtoImplCopyWith(
    _$StartGameDtoImpl value,
    $Res Function(_$StartGameDtoImpl) then,
  ) = __$$StartGameDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String gameId});
}

/// @nodoc
class __$$StartGameDtoImplCopyWithImpl<$Res>
    extends _$StartGameDtoCopyWithImpl<$Res, _$StartGameDtoImpl>
    implements _$$StartGameDtoImplCopyWith<$Res> {
  __$$StartGameDtoImplCopyWithImpl(
    _$StartGameDtoImpl _value,
    $Res Function(_$StartGameDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StartGameDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? gameId = null}) {
    return _then(
      _$StartGameDtoImpl(
        gameId: null == gameId
            ? _value.gameId
            : gameId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StartGameDtoImpl implements _StartGameDto {
  const _$StartGameDtoImpl({required this.gameId});

  factory _$StartGameDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$StartGameDtoImplFromJson(json);

  @override
  final String gameId;

  @override
  String toString() {
    return 'StartGameDto(gameId: $gameId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StartGameDtoImpl &&
            (identical(other.gameId, gameId) || other.gameId == gameId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, gameId);

  /// Create a copy of StartGameDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StartGameDtoImplCopyWith<_$StartGameDtoImpl> get copyWith =>
      __$$StartGameDtoImplCopyWithImpl<_$StartGameDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StartGameDtoImplToJson(this);
  }
}

abstract class _StartGameDto implements StartGameDto {
  const factory _StartGameDto({required final String gameId}) =
      _$StartGameDtoImpl;

  factory _StartGameDto.fromJson(Map<String, dynamic> json) =
      _$StartGameDtoImpl.fromJson;

  @override
  String get gameId;

  /// Create a copy of StartGameDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StartGameDtoImplCopyWith<_$StartGameDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
