// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_pablo_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CallPabloDto _$CallPabloDtoFromJson(Map<String, dynamic> json) {
  return _CallPabloDto.fromJson(json);
}

/// @nodoc
mixin _$CallPabloDto {
  String get gameId => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;

  /// Serializes this CallPabloDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CallPabloDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CallPabloDtoCopyWith<CallPabloDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CallPabloDtoCopyWith<$Res> {
  factory $CallPabloDtoCopyWith(
    CallPabloDto value,
    $Res Function(CallPabloDto) then,
  ) = _$CallPabloDtoCopyWithImpl<$Res, CallPabloDto>;
  @useResult
  $Res call({String gameId, String playerId});
}

/// @nodoc
class _$CallPabloDtoCopyWithImpl<$Res, $Val extends CallPabloDto>
    implements $CallPabloDtoCopyWith<$Res> {
  _$CallPabloDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CallPabloDto
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
abstract class _$$CallPabloDtoImplCopyWith<$Res>
    implements $CallPabloDtoCopyWith<$Res> {
  factory _$$CallPabloDtoImplCopyWith(
    _$CallPabloDtoImpl value,
    $Res Function(_$CallPabloDtoImpl) then,
  ) = __$$CallPabloDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String gameId, String playerId});
}

/// @nodoc
class __$$CallPabloDtoImplCopyWithImpl<$Res>
    extends _$CallPabloDtoCopyWithImpl<$Res, _$CallPabloDtoImpl>
    implements _$$CallPabloDtoImplCopyWith<$Res> {
  __$$CallPabloDtoImplCopyWithImpl(
    _$CallPabloDtoImpl _value,
    $Res Function(_$CallPabloDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CallPabloDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? gameId = null, Object? playerId = null}) {
    return _then(
      _$CallPabloDtoImpl(
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
class _$CallPabloDtoImpl implements _CallPabloDto {
  const _$CallPabloDtoImpl({required this.gameId, required this.playerId});

  factory _$CallPabloDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CallPabloDtoImplFromJson(json);

  @override
  final String gameId;
  @override
  final String playerId;

  @override
  String toString() {
    return 'CallPabloDto(gameId: $gameId, playerId: $playerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CallPabloDtoImpl &&
            (identical(other.gameId, gameId) || other.gameId == gameId) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, gameId, playerId);

  /// Create a copy of CallPabloDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CallPabloDtoImplCopyWith<_$CallPabloDtoImpl> get copyWith =>
      __$$CallPabloDtoImplCopyWithImpl<_$CallPabloDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CallPabloDtoImplToJson(this);
  }
}

abstract class _CallPabloDto implements CallPabloDto {
  const factory _CallPabloDto({
    required final String gameId,
    required final String playerId,
  }) = _$CallPabloDtoImpl;

  factory _CallPabloDto.fromJson(Map<String, dynamic> json) =
      _$CallPabloDtoImpl.fromJson;

  @override
  String get gameId;
  @override
  String get playerId;

  /// Create a copy of CallPabloDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CallPabloDtoImplCopyWith<_$CallPabloDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
