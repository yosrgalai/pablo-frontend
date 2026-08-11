// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'join_game_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

JoinGameDto _$JoinGameDtoFromJson(Map<String, dynamic> json) {
  return _JoinGameDto.fromJson(json);
}

/// @nodoc
mixin _$JoinGameDto {
  String get gameId => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;

  /// Serializes this JoinGameDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JoinGameDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JoinGameDtoCopyWith<JoinGameDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JoinGameDtoCopyWith<$Res> {
  factory $JoinGameDtoCopyWith(
    JoinGameDto value,
    $Res Function(JoinGameDto) then,
  ) = _$JoinGameDtoCopyWithImpl<$Res, JoinGameDto>;
  @useResult
  $Res call({String gameId, String playerId});
}

/// @nodoc
class _$JoinGameDtoCopyWithImpl<$Res, $Val extends JoinGameDto>
    implements $JoinGameDtoCopyWith<$Res> {
  _$JoinGameDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JoinGameDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? gameId = null, Object? playerId = null}) {
    return _then(
      _value.copyWith(
            gameId: null == gameId
                ? _value.gameId
                : gameId // ignore: cast_nullable_to_non_nullable
                      as String,
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$JoinGameDtoImplCopyWith<$Res>
    implements $JoinGameDtoCopyWith<$Res> {
  factory _$$JoinGameDtoImplCopyWith(
    _$JoinGameDtoImpl value,
    $Res Function(_$JoinGameDtoImpl) then,
  ) = __$$JoinGameDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String gameId, String playerId});
}

/// @nodoc
class __$$JoinGameDtoImplCopyWithImpl<$Res>
    extends _$JoinGameDtoCopyWithImpl<$Res, _$JoinGameDtoImpl>
    implements _$$JoinGameDtoImplCopyWith<$Res> {
  __$$JoinGameDtoImplCopyWithImpl(
    _$JoinGameDtoImpl _value,
    $Res Function(_$JoinGameDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JoinGameDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? gameId = null, Object? playerId = null}) {
    return _then(
      _$JoinGameDtoImpl(
        gameId: null == gameId
            ? _value.gameId
            : gameId // ignore: cast_nullable_to_non_nullable
                  as String,
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$JoinGameDtoImpl implements _JoinGameDto {
  const _$JoinGameDtoImpl({required this.gameId, required this.playerId});

  factory _$JoinGameDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$JoinGameDtoImplFromJson(json);

  @override
  final String gameId;
  @override
  final String playerId;

  @override
  String toString() {
    return 'JoinGameDto(gameId: $gameId, playerId: $playerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JoinGameDtoImpl &&
            (identical(other.gameId, gameId) || other.gameId == gameId) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, gameId, playerId);

  /// Create a copy of JoinGameDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JoinGameDtoImplCopyWith<_$JoinGameDtoImpl> get copyWith =>
      __$$JoinGameDtoImplCopyWithImpl<_$JoinGameDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JoinGameDtoImplToJson(this);
  }
}

abstract class _JoinGameDto implements JoinGameDto {
  const factory _JoinGameDto({
    required final String gameId,
    required final String playerId,
  }) = _$JoinGameDtoImpl;

  factory _JoinGameDto.fromJson(Map<String, dynamic> json) =
      _$JoinGameDtoImpl.fromJson;

  @override
  String get gameId;
  @override
  String get playerId;

  /// Create a copy of JoinGameDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JoinGameDtoImplCopyWith<_$JoinGameDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
