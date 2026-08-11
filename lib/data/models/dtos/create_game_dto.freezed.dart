// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_game_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CreateGameDto _$CreateGameDtoFromJson(Map<String, dynamic> json) {
  return _CreateGameDto.fromJson(json);
}

/// @nodoc
mixin _$CreateGameDto {
  int get scoreLimit => throw _privateConstructorUsedError;
  List<String> get playerNames => throw _privateConstructorUsedError;

  /// Serializes this CreateGameDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateGameDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateGameDtoCopyWith<CreateGameDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateGameDtoCopyWith<$Res> {
  factory $CreateGameDtoCopyWith(
    CreateGameDto value,
    $Res Function(CreateGameDto) then,
  ) = _$CreateGameDtoCopyWithImpl<$Res, CreateGameDto>;
  @useResult
  $Res call({int scoreLimit, List<String> playerNames});
}

/// @nodoc
class _$CreateGameDtoCopyWithImpl<$Res, $Val extends CreateGameDto>
    implements $CreateGameDtoCopyWith<$Res> {
  _$CreateGameDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateGameDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? scoreLimit = null, Object? playerNames = null}) {
    return _then(
      _value.copyWith(
            scoreLimit: null == scoreLimit
                ? _value.scoreLimit
                : scoreLimit // ignore: cast_nullable_to_non_nullable
                      as int,
            playerNames: null == playerNames
                ? _value.playerNames
                : playerNames // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateGameDtoImplCopyWith<$Res>
    implements $CreateGameDtoCopyWith<$Res> {
  factory _$$CreateGameDtoImplCopyWith(
    _$CreateGameDtoImpl value,
    $Res Function(_$CreateGameDtoImpl) then,
  ) = __$$CreateGameDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int scoreLimit, List<String> playerNames});
}

/// @nodoc
class __$$CreateGameDtoImplCopyWithImpl<$Res>
    extends _$CreateGameDtoCopyWithImpl<$Res, _$CreateGameDtoImpl>
    implements _$$CreateGameDtoImplCopyWith<$Res> {
  __$$CreateGameDtoImplCopyWithImpl(
    _$CreateGameDtoImpl _value,
    $Res Function(_$CreateGameDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateGameDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? scoreLimit = null, Object? playerNames = null}) {
    return _then(
      _$CreateGameDtoImpl(
        scoreLimit: null == scoreLimit
            ? _value.scoreLimit
            : scoreLimit // ignore: cast_nullable_to_non_nullable
                  as int,
        playerNames: null == playerNames
            ? _value._playerNames
            : playerNames // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateGameDtoImpl implements _CreateGameDto {
  const _$CreateGameDtoImpl({
    required this.scoreLimit,
    required final List<String> playerNames,
  }) : _playerNames = playerNames;

  factory _$CreateGameDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateGameDtoImplFromJson(json);

  @override
  final int scoreLimit;
  final List<String> _playerNames;
  @override
  List<String> get playerNames {
    if (_playerNames is EqualUnmodifiableListView) return _playerNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_playerNames);
  }

  @override
  String toString() {
    return 'CreateGameDto(scoreLimit: $scoreLimit, playerNames: $playerNames)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateGameDtoImpl &&
            (identical(other.scoreLimit, scoreLimit) ||
                other.scoreLimit == scoreLimit) &&
            const DeepCollectionEquality().equals(
              other._playerNames,
              _playerNames,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    scoreLimit,
    const DeepCollectionEquality().hash(_playerNames),
  );

  /// Create a copy of CreateGameDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateGameDtoImplCopyWith<_$CreateGameDtoImpl> get copyWith =>
      __$$CreateGameDtoImplCopyWithImpl<_$CreateGameDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateGameDtoImplToJson(this);
  }
}

abstract class _CreateGameDto implements CreateGameDto {
  const factory _CreateGameDto({
    required final int scoreLimit,
    required final List<String> playerNames,
  }) = _$CreateGameDtoImpl;

  factory _CreateGameDto.fromJson(Map<String, dynamic> json) =
      _$CreateGameDtoImpl.fromJson;

  @override
  int get scoreLimit;
  @override
  List<String> get playerNames;

  /// Create a copy of CreateGameDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateGameDtoImplCopyWith<_$CreateGameDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
