// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'draw_card_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DrawCardDto _$DrawCardDtoFromJson(Map<String, dynamic> json) {
  return _DrawCardDto.fromJson(json);
}

/// @nodoc
mixin _$DrawCardDto {
  String get gameId => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;

  /// Serializes this DrawCardDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DrawCardDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DrawCardDtoCopyWith<DrawCardDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DrawCardDtoCopyWith<$Res> {
  factory $DrawCardDtoCopyWith(
    DrawCardDto value,
    $Res Function(DrawCardDto) then,
  ) = _$DrawCardDtoCopyWithImpl<$Res, DrawCardDto>;
  @useResult
  $Res call({String gameId, String playerId});
}

/// @nodoc
class _$DrawCardDtoCopyWithImpl<$Res, $Val extends DrawCardDto>
    implements $DrawCardDtoCopyWith<$Res> {
  _$DrawCardDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DrawCardDto
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
abstract class _$$DrawCardDtoImplCopyWith<$Res>
    implements $DrawCardDtoCopyWith<$Res> {
  factory _$$DrawCardDtoImplCopyWith(
    _$DrawCardDtoImpl value,
    $Res Function(_$DrawCardDtoImpl) then,
  ) = __$$DrawCardDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String gameId, String playerId});
}

/// @nodoc
class __$$DrawCardDtoImplCopyWithImpl<$Res>
    extends _$DrawCardDtoCopyWithImpl<$Res, _$DrawCardDtoImpl>
    implements _$$DrawCardDtoImplCopyWith<$Res> {
  __$$DrawCardDtoImplCopyWithImpl(
    _$DrawCardDtoImpl _value,
    $Res Function(_$DrawCardDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DrawCardDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? gameId = null, Object? playerId = null}) {
    return _then(
      _$DrawCardDtoImpl(
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
class _$DrawCardDtoImpl implements _DrawCardDto {
  const _$DrawCardDtoImpl({required this.gameId, required this.playerId});

  factory _$DrawCardDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DrawCardDtoImplFromJson(json);

  @override
  final String gameId;
  @override
  final String playerId;

  @override
  String toString() {
    return 'DrawCardDto(gameId: $gameId, playerId: $playerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DrawCardDtoImpl &&
            (identical(other.gameId, gameId) || other.gameId == gameId) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, gameId, playerId);

  /// Create a copy of DrawCardDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DrawCardDtoImplCopyWith<_$DrawCardDtoImpl> get copyWith =>
      __$$DrawCardDtoImplCopyWithImpl<_$DrawCardDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DrawCardDtoImplToJson(this);
  }
}

abstract class _DrawCardDto implements DrawCardDto {
  const factory _DrawCardDto({
    required final String gameId,
    required final String playerId,
  }) = _$DrawCardDtoImpl;

  factory _DrawCardDto.fromJson(Map<String, dynamic> json) =
      _$DrawCardDtoImpl.fromJson;

  @override
  String get gameId;
  @override
  String get playerId;

  /// Create a copy of DrawCardDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DrawCardDtoImplCopyWith<_$DrawCardDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
