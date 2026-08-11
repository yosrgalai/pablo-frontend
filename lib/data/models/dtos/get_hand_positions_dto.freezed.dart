// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_hand_positions_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GetHandPositionsDto _$GetHandPositionsDtoFromJson(Map<String, dynamic> json) {
  return _GetHandPositionsDto.fromJson(json);
}

/// @nodoc
mixin _$GetHandPositionsDto {
  String get gameId => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;

  /// Serializes this GetHandPositionsDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GetHandPositionsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetHandPositionsDtoCopyWith<GetHandPositionsDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetHandPositionsDtoCopyWith<$Res> {
  factory $GetHandPositionsDtoCopyWith(
    GetHandPositionsDto value,
    $Res Function(GetHandPositionsDto) then,
  ) = _$GetHandPositionsDtoCopyWithImpl<$Res, GetHandPositionsDto>;
  @useResult
  $Res call({String gameId, String playerId});
}

/// @nodoc
class _$GetHandPositionsDtoCopyWithImpl<$Res, $Val extends GetHandPositionsDto>
    implements $GetHandPositionsDtoCopyWith<$Res> {
  _$GetHandPositionsDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetHandPositionsDto
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
abstract class _$$GetHandPositionsDtoImplCopyWith<$Res>
    implements $GetHandPositionsDtoCopyWith<$Res> {
  factory _$$GetHandPositionsDtoImplCopyWith(
    _$GetHandPositionsDtoImpl value,
    $Res Function(_$GetHandPositionsDtoImpl) then,
  ) = __$$GetHandPositionsDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String gameId, String playerId});
}

/// @nodoc
class __$$GetHandPositionsDtoImplCopyWithImpl<$Res>
    extends _$GetHandPositionsDtoCopyWithImpl<$Res, _$GetHandPositionsDtoImpl>
    implements _$$GetHandPositionsDtoImplCopyWith<$Res> {
  __$$GetHandPositionsDtoImplCopyWithImpl(
    _$GetHandPositionsDtoImpl _value,
    $Res Function(_$GetHandPositionsDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetHandPositionsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? gameId = null, Object? playerId = null}) {
    return _then(
      _$GetHandPositionsDtoImpl(
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
class _$GetHandPositionsDtoImpl implements _GetHandPositionsDto {
  const _$GetHandPositionsDtoImpl({
    required this.gameId,
    required this.playerId,
  });

  factory _$GetHandPositionsDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetHandPositionsDtoImplFromJson(json);

  @override
  final String gameId;
  @override
  final String playerId;

  @override
  String toString() {
    return 'GetHandPositionsDto(gameId: $gameId, playerId: $playerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetHandPositionsDtoImpl &&
            (identical(other.gameId, gameId) || other.gameId == gameId) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, gameId, playerId);

  /// Create a copy of GetHandPositionsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetHandPositionsDtoImplCopyWith<_$GetHandPositionsDtoImpl> get copyWith =>
      __$$GetHandPositionsDtoImplCopyWithImpl<_$GetHandPositionsDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GetHandPositionsDtoImplToJson(this);
  }
}

abstract class _GetHandPositionsDto implements GetHandPositionsDto {
  const factory _GetHandPositionsDto({
    required final String gameId,
    required final String playerId,
  }) = _$GetHandPositionsDtoImpl;

  factory _GetHandPositionsDto.fromJson(Map<String, dynamic> json) =
      _$GetHandPositionsDtoImpl.fromJson;

  @override
  String get gameId;
  @override
  String get playerId;

  /// Create a copy of GetHandPositionsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetHandPositionsDtoImplCopyWith<_$GetHandPositionsDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
