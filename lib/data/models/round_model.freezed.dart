// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'round_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RoundModel _$RoundModelFromJson(Map<String, dynamic> json) {
  return _RoundModel.fromJson(json);
}

/// @nodoc
mixin _$RoundModel {
  int get roundNumber => throw _privateConstructorUsedError;
  int get drawPileCount => throw _privateConstructorUsedError;
  CardModel? get discardTop => throw _privateConstructorUsedError;
  GameRoundState get state => throw _privateConstructorUsedError;

  /// Serializes this RoundModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RoundModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoundModelCopyWith<RoundModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoundModelCopyWith<$Res> {
  factory $RoundModelCopyWith(
    RoundModel value,
    $Res Function(RoundModel) then,
  ) = _$RoundModelCopyWithImpl<$Res, RoundModel>;
  @useResult
  $Res call({
    int roundNumber,
    int drawPileCount,
    CardModel? discardTop,
    GameRoundState state,
  });

  $CardModelCopyWith<$Res>? get discardTop;
}

/// @nodoc
class _$RoundModelCopyWithImpl<$Res, $Val extends RoundModel>
    implements $RoundModelCopyWith<$Res> {
  _$RoundModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoundModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roundNumber = null,
    Object? drawPileCount = null,
    Object? discardTop = freezed,
    Object? state = null,
  }) {
    return _then(
      _value.copyWith(
            roundNumber: null == roundNumber
                ? _value.roundNumber
                : roundNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            drawPileCount: null == drawPileCount
                ? _value.drawPileCount
                : drawPileCount // ignore: cast_nullable_to_non_nullable
                      as int,
            discardTop: freezed == discardTop
                ? _value.discardTop
                : discardTop // ignore: cast_nullable_to_non_nullable
                      as CardModel?,
            state: null == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                      as GameRoundState,
          )
          as $Val,
    );
  }

  /// Create a copy of RoundModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CardModelCopyWith<$Res>? get discardTop {
    if (_value.discardTop == null) {
      return null;
    }

    return $CardModelCopyWith<$Res>(_value.discardTop!, (value) {
      return _then(_value.copyWith(discardTop: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RoundModelImplCopyWith<$Res>
    implements $RoundModelCopyWith<$Res> {
  factory _$$RoundModelImplCopyWith(
    _$RoundModelImpl value,
    $Res Function(_$RoundModelImpl) then,
  ) = __$$RoundModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int roundNumber,
    int drawPileCount,
    CardModel? discardTop,
    GameRoundState state,
  });

  @override
  $CardModelCopyWith<$Res>? get discardTop;
}

/// @nodoc
class __$$RoundModelImplCopyWithImpl<$Res>
    extends _$RoundModelCopyWithImpl<$Res, _$RoundModelImpl>
    implements _$$RoundModelImplCopyWith<$Res> {
  __$$RoundModelImplCopyWithImpl(
    _$RoundModelImpl _value,
    $Res Function(_$RoundModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RoundModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roundNumber = null,
    Object? drawPileCount = null,
    Object? discardTop = freezed,
    Object? state = null,
  }) {
    return _then(
      _$RoundModelImpl(
        roundNumber: null == roundNumber
            ? _value.roundNumber
            : roundNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        drawPileCount: null == drawPileCount
            ? _value.drawPileCount
            : drawPileCount // ignore: cast_nullable_to_non_nullable
                  as int,
        discardTop: freezed == discardTop
            ? _value.discardTop
            : discardTop // ignore: cast_nullable_to_non_nullable
                  as CardModel?,
        state: null == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as GameRoundState,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RoundModelImpl implements _RoundModel {
  const _$RoundModelImpl({
    required this.roundNumber,
    required this.drawPileCount,
    this.discardTop,
    required this.state,
  });

  factory _$RoundModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoundModelImplFromJson(json);

  @override
  final int roundNumber;
  @override
  final int drawPileCount;
  @override
  final CardModel? discardTop;
  @override
  final GameRoundState state;

  @override
  String toString() {
    return 'RoundModel(roundNumber: $roundNumber, drawPileCount: $drawPileCount, discardTop: $discardTop, state: $state)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoundModelImpl &&
            (identical(other.roundNumber, roundNumber) ||
                other.roundNumber == roundNumber) &&
            (identical(other.drawPileCount, drawPileCount) ||
                other.drawPileCount == drawPileCount) &&
            (identical(other.discardTop, discardTop) ||
                other.discardTop == discardTop) &&
            (identical(other.state, state) || other.state == state));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, roundNumber, drawPileCount, discardTop, state);

  /// Create a copy of RoundModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoundModelImplCopyWith<_$RoundModelImpl> get copyWith =>
      __$$RoundModelImplCopyWithImpl<_$RoundModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoundModelImplToJson(this);
  }
}

abstract class _RoundModel implements RoundModel {
  const factory _RoundModel({
    required final int roundNumber,
    required final int drawPileCount,
    final CardModel? discardTop,
    required final GameRoundState state,
  }) = _$RoundModelImpl;

  factory _RoundModel.fromJson(Map<String, dynamic> json) =
      _$RoundModelImpl.fromJson;

  @override
  int get roundNumber;
  @override
  int get drawPileCount;
  @override
  CardModel? get discardTop;
  @override
  GameRoundState get state;

  /// Create a copy of RoundModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoundModelImplCopyWith<_$RoundModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
