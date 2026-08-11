// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'choose_initial_peek_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChooseInitialPeekDto _$ChooseInitialPeekDtoFromJson(Map<String, dynamic> json) {
  return _ChooseInitialPeekDto.fromJson(json);
}

/// @nodoc
mixin _$ChooseInitialPeekDto {
  String get gameId => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;
  List<int> get positions => throw _privateConstructorUsedError;

  /// Serializes this ChooseInitialPeekDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChooseInitialPeekDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChooseInitialPeekDtoCopyWith<ChooseInitialPeekDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChooseInitialPeekDtoCopyWith<$Res> {
  factory $ChooseInitialPeekDtoCopyWith(
    ChooseInitialPeekDto value,
    $Res Function(ChooseInitialPeekDto) then,
  ) = _$ChooseInitialPeekDtoCopyWithImpl<$Res, ChooseInitialPeekDto>;
  @useResult
  $Res call({String gameId, String playerId, List<int> positions});
}

/// @nodoc
class _$ChooseInitialPeekDtoCopyWithImpl<
  $Res,
  $Val extends ChooseInitialPeekDto
>
    implements $ChooseInitialPeekDtoCopyWith<$Res> {
  _$ChooseInitialPeekDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChooseInitialPeekDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameId = null,
    Object? playerId = null,
    Object? positions = null,
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
            positions: null == positions
                ? _value.positions
                : positions // ignore: cast_nullable_to_non_nullable
                      as List<int>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChooseInitialPeekDtoImplCopyWith<$Res>
    implements $ChooseInitialPeekDtoCopyWith<$Res> {
  factory _$$ChooseInitialPeekDtoImplCopyWith(
    _$ChooseInitialPeekDtoImpl value,
    $Res Function(_$ChooseInitialPeekDtoImpl) then,
  ) = __$$ChooseInitialPeekDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String gameId, String playerId, List<int> positions});
}

/// @nodoc
class __$$ChooseInitialPeekDtoImplCopyWithImpl<$Res>
    extends _$ChooseInitialPeekDtoCopyWithImpl<$Res, _$ChooseInitialPeekDtoImpl>
    implements _$$ChooseInitialPeekDtoImplCopyWith<$Res> {
  __$$ChooseInitialPeekDtoImplCopyWithImpl(
    _$ChooseInitialPeekDtoImpl _value,
    $Res Function(_$ChooseInitialPeekDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChooseInitialPeekDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameId = null,
    Object? playerId = null,
    Object? positions = null,
  }) {
    return _then(
      _$ChooseInitialPeekDtoImpl(
        gameId: null == gameId
            ? _value.gameId
            : gameId // ignore: cast_nullable_to_non_nullable
                  as String,
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        positions: null == positions
            ? _value._positions
            : positions // ignore: cast_nullable_to_non_nullable
                  as List<int>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChooseInitialPeekDtoImpl implements _ChooseInitialPeekDto {
  const _$ChooseInitialPeekDtoImpl({
    required this.gameId,
    required this.playerId,
    required final List<int> positions,
  }) : _positions = positions;

  factory _$ChooseInitialPeekDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChooseInitialPeekDtoImplFromJson(json);

  @override
  final String gameId;
  @override
  final String playerId;
  final List<int> _positions;
  @override
  List<int> get positions {
    if (_positions is EqualUnmodifiableListView) return _positions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_positions);
  }

  @override
  String toString() {
    return 'ChooseInitialPeekDto(gameId: $gameId, playerId: $playerId, positions: $positions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChooseInitialPeekDtoImpl &&
            (identical(other.gameId, gameId) || other.gameId == gameId) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            const DeepCollectionEquality().equals(
              other._positions,
              _positions,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    gameId,
    playerId,
    const DeepCollectionEquality().hash(_positions),
  );

  /// Create a copy of ChooseInitialPeekDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChooseInitialPeekDtoImplCopyWith<_$ChooseInitialPeekDtoImpl>
  get copyWith =>
      __$$ChooseInitialPeekDtoImplCopyWithImpl<_$ChooseInitialPeekDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ChooseInitialPeekDtoImplToJson(this);
  }
}

abstract class _ChooseInitialPeekDto implements ChooseInitialPeekDto {
  const factory _ChooseInitialPeekDto({
    required final String gameId,
    required final String playerId,
    required final List<int> positions,
  }) = _$ChooseInitialPeekDtoImpl;

  factory _ChooseInitialPeekDto.fromJson(Map<String, dynamic> json) =
      _$ChooseInitialPeekDtoImpl.fromJson;

  @override
  String get gameId;
  @override
  String get playerId;
  @override
  List<int> get positions;

  /// Create a copy of ChooseInitialPeekDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChooseInitialPeekDtoImplCopyWith<_$ChooseInitialPeekDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
