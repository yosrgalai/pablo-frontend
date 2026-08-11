// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'swap_card_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SwapCardDto _$SwapCardDtoFromJson(Map<String, dynamic> json) {
  return _SwapCardDto.fromJson(json);
}

/// @nodoc
mixin _$SwapCardDto {
  String get gameId => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;
  String get drawnCardId => throw _privateConstructorUsedError;
  int get handPosition => throw _privateConstructorUsedError;

  /// Serializes this SwapCardDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SwapCardDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SwapCardDtoCopyWith<SwapCardDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SwapCardDtoCopyWith<$Res> {
  factory $SwapCardDtoCopyWith(
    SwapCardDto value,
    $Res Function(SwapCardDto) then,
  ) = _$SwapCardDtoCopyWithImpl<$Res, SwapCardDto>;
  @useResult
  $Res call({
    String gameId,
    String playerId,
    String drawnCardId,
    int handPosition,
  });
}

/// @nodoc
class _$SwapCardDtoCopyWithImpl<$Res, $Val extends SwapCardDto>
    implements $SwapCardDtoCopyWith<$Res> {
  _$SwapCardDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SwapCardDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameId = null,
    Object? playerId = null,
    Object? drawnCardId = null,
    Object? handPosition = null,
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
            drawnCardId: null == drawnCardId
                ? _value.drawnCardId
                : drawnCardId // ignore: cast_nullable_to_non_nullable
                      as String,
            handPosition: null == handPosition
                ? _value.handPosition
                : handPosition // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SwapCardDtoImplCopyWith<$Res>
    implements $SwapCardDtoCopyWith<$Res> {
  factory _$$SwapCardDtoImplCopyWith(
    _$SwapCardDtoImpl value,
    $Res Function(_$SwapCardDtoImpl) then,
  ) = __$$SwapCardDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String gameId,
    String playerId,
    String drawnCardId,
    int handPosition,
  });
}

/// @nodoc
class __$$SwapCardDtoImplCopyWithImpl<$Res>
    extends _$SwapCardDtoCopyWithImpl<$Res, _$SwapCardDtoImpl>
    implements _$$SwapCardDtoImplCopyWith<$Res> {
  __$$SwapCardDtoImplCopyWithImpl(
    _$SwapCardDtoImpl _value,
    $Res Function(_$SwapCardDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SwapCardDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameId = null,
    Object? playerId = null,
    Object? drawnCardId = null,
    Object? handPosition = null,
  }) {
    return _then(
      _$SwapCardDtoImpl(
        gameId: null == gameId
            ? _value.gameId
            : gameId // ignore: cast_nullable_to_non_nullable
                  as String,
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        drawnCardId: null == drawnCardId
            ? _value.drawnCardId
            : drawnCardId // ignore: cast_nullable_to_non_nullable
                  as String,
        handPosition: null == handPosition
            ? _value.handPosition
            : handPosition // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SwapCardDtoImpl implements _SwapCardDto {
  const _$SwapCardDtoImpl({
    required this.gameId,
    required this.playerId,
    required this.drawnCardId,
    required this.handPosition,
  });

  factory _$SwapCardDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SwapCardDtoImplFromJson(json);

  @override
  final String gameId;
  @override
  final String playerId;
  @override
  final String drawnCardId;
  @override
  final int handPosition;

  @override
  String toString() {
    return 'SwapCardDto(gameId: $gameId, playerId: $playerId, drawnCardId: $drawnCardId, handPosition: $handPosition)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SwapCardDtoImpl &&
            (identical(other.gameId, gameId) || other.gameId == gameId) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.drawnCardId, drawnCardId) ||
                other.drawnCardId == drawnCardId) &&
            (identical(other.handPosition, handPosition) ||
                other.handPosition == handPosition));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, gameId, playerId, drawnCardId, handPosition);

  /// Create a copy of SwapCardDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SwapCardDtoImplCopyWith<_$SwapCardDtoImpl> get copyWith =>
      __$$SwapCardDtoImplCopyWithImpl<_$SwapCardDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SwapCardDtoImplToJson(this);
  }
}

abstract class _SwapCardDto implements SwapCardDto {
  const factory _SwapCardDto({
    required final String gameId,
    required final String playerId,
    required final String drawnCardId,
    required final int handPosition,
  }) = _$SwapCardDtoImpl;

  factory _SwapCardDto.fromJson(Map<String, dynamic> json) =
      _$SwapCardDtoImpl.fromJson;

  @override
  String get gameId;
  @override
  String get playerId;
  @override
  String get drawnCardId;
  @override
  int get handPosition;

  /// Create a copy of SwapCardDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SwapCardDtoImplCopyWith<_$SwapCardDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
