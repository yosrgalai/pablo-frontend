// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pair_attempt_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PairAttemptDto _$PairAttemptDtoFromJson(Map<String, dynamic> json) {
  return _PairAttemptDto.fromJson(json);
}

/// @nodoc
mixin _$PairAttemptDto {
  String get gameId => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;
  int get firstPosition => throw _privateConstructorUsedError;
  int get secondPosition => throw _privateConstructorUsedError;

  /// Serializes this PairAttemptDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PairAttemptDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PairAttemptDtoCopyWith<PairAttemptDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PairAttemptDtoCopyWith<$Res> {
  factory $PairAttemptDtoCopyWith(
    PairAttemptDto value,
    $Res Function(PairAttemptDto) then,
  ) = _$PairAttemptDtoCopyWithImpl<$Res, PairAttemptDto>;
  @useResult
  $Res call({
    String gameId,
    String playerId,
    int firstPosition,
    int secondPosition,
  });
}

/// @nodoc
class _$PairAttemptDtoCopyWithImpl<$Res, $Val extends PairAttemptDto>
    implements $PairAttemptDtoCopyWith<$Res> {
  _$PairAttemptDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PairAttemptDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameId = null,
    Object? playerId = null,
    Object? firstPosition = null,
    Object? secondPosition = null,
  }) {
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
            firstPosition: null == firstPosition
                ? _value.firstPosition
                : firstPosition // ignore: cast_nullable_to_non_nullable
                      as int,
            secondPosition: null == secondPosition
                ? _value.secondPosition
                : secondPosition // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PairAttemptDtoImplCopyWith<$Res>
    implements $PairAttemptDtoCopyWith<$Res> {
  factory _$$PairAttemptDtoImplCopyWith(
    _$PairAttemptDtoImpl value,
    $Res Function(_$PairAttemptDtoImpl) then,
  ) = __$$PairAttemptDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String gameId,
    String playerId,
    int firstPosition,
    int secondPosition,
  });
}

/// @nodoc
class __$$PairAttemptDtoImplCopyWithImpl<$Res>
    extends _$PairAttemptDtoCopyWithImpl<$Res, _$PairAttemptDtoImpl>
    implements _$$PairAttemptDtoImplCopyWith<$Res> {
  __$$PairAttemptDtoImplCopyWithImpl(
    _$PairAttemptDtoImpl _value,
    $Res Function(_$PairAttemptDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PairAttemptDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameId = null,
    Object? playerId = null,
    Object? firstPosition = null,
    Object? secondPosition = null,
  }) {
    return _then(
      _$PairAttemptDtoImpl(
        gameId: null == gameId
            ? _value.gameId
            : gameId // ignore: cast_nullable_to_non_nullable
                  as String,
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        firstPosition: null == firstPosition
            ? _value.firstPosition
            : firstPosition // ignore: cast_nullable_to_non_nullable
                  as int,
        secondPosition: null == secondPosition
            ? _value.secondPosition
            : secondPosition // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PairAttemptDtoImpl implements _PairAttemptDto {
  const _$PairAttemptDtoImpl({
    required this.gameId,
    required this.playerId,
    required this.firstPosition,
    required this.secondPosition,
  });

  factory _$PairAttemptDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PairAttemptDtoImplFromJson(json);

  @override
  final String gameId;
  @override
  final String playerId;
  @override
  final int firstPosition;
  @override
  final int secondPosition;

  @override
  String toString() {
    return 'PairAttemptDto(gameId: $gameId, playerId: $playerId, firstPosition: $firstPosition, secondPosition: $secondPosition)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PairAttemptDtoImpl &&
            (identical(other.gameId, gameId) || other.gameId == gameId) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.firstPosition, firstPosition) ||
                other.firstPosition == firstPosition) &&
            (identical(other.secondPosition, secondPosition) ||
                other.secondPosition == secondPosition));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, gameId, playerId, firstPosition, secondPosition);

  /// Create a copy of PairAttemptDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PairAttemptDtoImplCopyWith<_$PairAttemptDtoImpl> get copyWith =>
      __$$PairAttemptDtoImplCopyWithImpl<_$PairAttemptDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PairAttemptDtoImplToJson(this);
  }
}

abstract class _PairAttemptDto implements PairAttemptDto {
  const factory _PairAttemptDto({
    required final String gameId,
    required final String playerId,
    required final int firstPosition,
    required final int secondPosition,
  }) = _$PairAttemptDtoImpl;

  factory _PairAttemptDto.fromJson(Map<String, dynamic> json) =
      _$PairAttemptDtoImpl.fromJson;

  @override
  String get gameId;
  @override
  String get playerId;
  @override
  int get firstPosition;
  @override
  int get secondPosition;

  /// Create a copy of PairAttemptDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PairAttemptDtoImplCopyWith<_$PairAttemptDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
