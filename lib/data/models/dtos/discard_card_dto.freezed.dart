// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discard_card_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DiscardCardDto _$DiscardCardDtoFromJson(Map<String, dynamic> json) {
  return _DiscardCardDto.fromJson(json);
}

/// @nodoc
mixin _$DiscardCardDto {
  String get gameId => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;
  String get drawnCardId => throw _privateConstructorUsedError;
  bool? get usePower => throw _privateConstructorUsedError;

  /// Serializes this DiscardCardDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DiscardCardDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiscardCardDtoCopyWith<DiscardCardDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiscardCardDtoCopyWith<$Res> {
  factory $DiscardCardDtoCopyWith(
    DiscardCardDto value,
    $Res Function(DiscardCardDto) then,
  ) = _$DiscardCardDtoCopyWithImpl<$Res, DiscardCardDto>;
  @useResult
  $Res call({
    String gameId,
    String playerId,
    String drawnCardId,
    bool? usePower,
  });
}

/// @nodoc
class _$DiscardCardDtoCopyWithImpl<$Res, $Val extends DiscardCardDto>
    implements $DiscardCardDtoCopyWith<$Res> {
  _$DiscardCardDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DiscardCardDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameId = null,
    Object? playerId = null,
    Object? drawnCardId = null,
    Object? usePower = freezed,
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
            usePower: freezed == usePower
                ? _value.usePower
                : usePower // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DiscardCardDtoImplCopyWith<$Res>
    implements $DiscardCardDtoCopyWith<$Res> {
  factory _$$DiscardCardDtoImplCopyWith(
    _$DiscardCardDtoImpl value,
    $Res Function(_$DiscardCardDtoImpl) then,
  ) = __$$DiscardCardDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String gameId,
    String playerId,
    String drawnCardId,
    bool? usePower,
  });
}

/// @nodoc
class __$$DiscardCardDtoImplCopyWithImpl<$Res>
    extends _$DiscardCardDtoCopyWithImpl<$Res, _$DiscardCardDtoImpl>
    implements _$$DiscardCardDtoImplCopyWith<$Res> {
  __$$DiscardCardDtoImplCopyWithImpl(
    _$DiscardCardDtoImpl _value,
    $Res Function(_$DiscardCardDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DiscardCardDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameId = null,
    Object? playerId = null,
    Object? drawnCardId = null,
    Object? usePower = freezed,
  }) {
    return _then(
      _$DiscardCardDtoImpl(
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
        usePower: freezed == usePower
            ? _value.usePower
            : usePower // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DiscardCardDtoImpl implements _DiscardCardDto {
  const _$DiscardCardDtoImpl({
    required this.gameId,
    required this.playerId,
    required this.drawnCardId,
    this.usePower,
  });

  factory _$DiscardCardDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DiscardCardDtoImplFromJson(json);

  @override
  final String gameId;
  @override
  final String playerId;
  @override
  final String drawnCardId;
  @override
  final bool? usePower;

  @override
  String toString() {
    return 'DiscardCardDto(gameId: $gameId, playerId: $playerId, drawnCardId: $drawnCardId, usePower: $usePower)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiscardCardDtoImpl &&
            (identical(other.gameId, gameId) || other.gameId == gameId) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.drawnCardId, drawnCardId) ||
                other.drawnCardId == drawnCardId) &&
            (identical(other.usePower, usePower) ||
                other.usePower == usePower));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, gameId, playerId, drawnCardId, usePower);

  /// Create a copy of DiscardCardDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiscardCardDtoImplCopyWith<_$DiscardCardDtoImpl> get copyWith =>
      __$$DiscardCardDtoImplCopyWithImpl<_$DiscardCardDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DiscardCardDtoImplToJson(this);
  }
}

abstract class _DiscardCardDto implements DiscardCardDto {
  const factory _DiscardCardDto({
    required final String gameId,
    required final String playerId,
    required final String drawnCardId,
    final bool? usePower,
  }) = _$DiscardCardDtoImpl;

  factory _DiscardCardDto.fromJson(Map<String, dynamic> json) =
      _$DiscardCardDtoImpl.fromJson;

  @override
  String get gameId;
  @override
  String get playerId;
  @override
  String get drawnCardId;
  @override
  bool? get usePower;

  /// Create a copy of DiscardCardDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiscardCardDtoImplCopyWith<_$DiscardCardDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
