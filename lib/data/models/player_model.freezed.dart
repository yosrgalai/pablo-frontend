// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PlayerModel _$PlayerModelFromJson(Map<String, dynamic> json) {
  return _PlayerModel.fromJson(json);
}

/// @nodoc
mixin _$PlayerModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get handSize => throw _privateConstructorUsedError;
  List<CardModel> get hand => throw _privateConstructorUsedError;
  bool get isConnected => throw _privateConstructorUsedError;
  bool get isCurrentTurn => throw _privateConstructorUsedError;
  bool get hasCalledPablo => throw _privateConstructorUsedError;
  int? get roundScore => throw _privateConstructorUsedError;
  int get totalScore => throw _privateConstructorUsedError;

  /// Serializes this PlayerModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerModelCopyWith<PlayerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerModelCopyWith<$Res> {
  factory $PlayerModelCopyWith(
    PlayerModel value,
    $Res Function(PlayerModel) then,
  ) = _$PlayerModelCopyWithImpl<$Res, PlayerModel>;
  @useResult
  $Res call({
    String id,
    String name,
    int handSize,
    List<CardModel> hand,
    bool isConnected,
    bool isCurrentTurn,
    bool hasCalledPablo,
    int? roundScore,
    int totalScore,
  });
}

/// @nodoc
class _$PlayerModelCopyWithImpl<$Res, $Val extends PlayerModel>
    implements $PlayerModelCopyWith<$Res> {
  _$PlayerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? handSize = null,
    Object? hand = null,
    Object? isConnected = null,
    Object? isCurrentTurn = null,
    Object? hasCalledPablo = null,
    Object? roundScore = freezed,
    Object? totalScore = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            handSize: null == handSize
                ? _value.handSize
                : handSize // ignore: cast_nullable_to_non_nullable
                      as int,
            hand: null == hand
                ? _value.hand
                : hand // ignore: cast_nullable_to_non_nullable
                      as List<CardModel>,
            isConnected: null == isConnected
                ? _value.isConnected
                : isConnected // ignore: cast_nullable_to_non_nullable
                      as bool,
            isCurrentTurn: null == isCurrentTurn
                ? _value.isCurrentTurn
                : isCurrentTurn // ignore: cast_nullable_to_non_nullable
                      as bool,
            hasCalledPablo: null == hasCalledPablo
                ? _value.hasCalledPablo
                : hasCalledPablo // ignore: cast_nullable_to_non_nullable
                      as bool,
            roundScore: freezed == roundScore
                ? _value.roundScore
                : roundScore // ignore: cast_nullable_to_non_nullable
                      as int?,
            totalScore: null == totalScore
                ? _value.totalScore
                : totalScore // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlayerModelImplCopyWith<$Res>
    implements $PlayerModelCopyWith<$Res> {
  factory _$$PlayerModelImplCopyWith(
    _$PlayerModelImpl value,
    $Res Function(_$PlayerModelImpl) then,
  ) = __$$PlayerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    int handSize,
    List<CardModel> hand,
    bool isConnected,
    bool isCurrentTurn,
    bool hasCalledPablo,
    int? roundScore,
    int totalScore,
  });
}

/// @nodoc
class __$$PlayerModelImplCopyWithImpl<$Res>
    extends _$PlayerModelCopyWithImpl<$Res, _$PlayerModelImpl>
    implements _$$PlayerModelImplCopyWith<$Res> {
  __$$PlayerModelImplCopyWithImpl(
    _$PlayerModelImpl _value,
    $Res Function(_$PlayerModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? handSize = null,
    Object? hand = null,
    Object? isConnected = null,
    Object? isCurrentTurn = null,
    Object? hasCalledPablo = null,
    Object? roundScore = freezed,
    Object? totalScore = null,
  }) {
    return _then(
      _$PlayerModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        handSize: null == handSize
            ? _value.handSize
            : handSize // ignore: cast_nullable_to_non_nullable
                  as int,
        hand: null == hand
            ? _value._hand
            : hand // ignore: cast_nullable_to_non_nullable
                  as List<CardModel>,
        isConnected: null == isConnected
            ? _value.isConnected
            : isConnected // ignore: cast_nullable_to_non_nullable
                  as bool,
        isCurrentTurn: null == isCurrentTurn
            ? _value.isCurrentTurn
            : isCurrentTurn // ignore: cast_nullable_to_non_nullable
                  as bool,
        hasCalledPablo: null == hasCalledPablo
            ? _value.hasCalledPablo
            : hasCalledPablo // ignore: cast_nullable_to_non_nullable
                  as bool,
        roundScore: freezed == roundScore
            ? _value.roundScore
            : roundScore // ignore: cast_nullable_to_non_nullable
                  as int?,
        totalScore: null == totalScore
            ? _value.totalScore
            : totalScore // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerModelImpl extends _PlayerModel {
  const _$PlayerModelImpl({
    required this.id,
    required this.name,
    required this.handSize,
    final List<CardModel> hand = const [],
    required this.isConnected,
    required this.isCurrentTurn,
    this.hasCalledPablo = false,
    this.roundScore,
    this.totalScore = 0,
  }) : _hand = hand,
       super._();

  factory _$PlayerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final int handSize;
  final List<CardModel> _hand;
  @override
  @JsonKey()
  List<CardModel> get hand {
    if (_hand is EqualUnmodifiableListView) return _hand;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hand);
  }

  @override
  final bool isConnected;
  @override
  final bool isCurrentTurn;
  @override
  @JsonKey()
  final bool hasCalledPablo;
  @override
  final int? roundScore;
  @override
  @JsonKey()
  final int totalScore;

  @override
  String toString() {
    return 'PlayerModel(id: $id, name: $name, handSize: $handSize, hand: $hand, isConnected: $isConnected, isCurrentTurn: $isCurrentTurn, hasCalledPablo: $hasCalledPablo, roundScore: $roundScore, totalScore: $totalScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.handSize, handSize) ||
                other.handSize == handSize) &&
            const DeepCollectionEquality().equals(other._hand, _hand) &&
            (identical(other.isConnected, isConnected) ||
                other.isConnected == isConnected) &&
            (identical(other.isCurrentTurn, isCurrentTurn) ||
                other.isCurrentTurn == isCurrentTurn) &&
            (identical(other.hasCalledPablo, hasCalledPablo) ||
                other.hasCalledPablo == hasCalledPablo) &&
            (identical(other.roundScore, roundScore) ||
                other.roundScore == roundScore) &&
            (identical(other.totalScore, totalScore) ||
                other.totalScore == totalScore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    handSize,
    const DeepCollectionEquality().hash(_hand),
    isConnected,
    isCurrentTurn,
    hasCalledPablo,
    roundScore,
    totalScore,
  );

  /// Create a copy of PlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerModelImplCopyWith<_$PlayerModelImpl> get copyWith =>
      __$$PlayerModelImplCopyWithImpl<_$PlayerModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerModelImplToJson(this);
  }
}

abstract class _PlayerModel extends PlayerModel {
  const factory _PlayerModel({
    required final String id,
    required final String name,
    required final int handSize,
    final List<CardModel> hand,
    required final bool isConnected,
    required final bool isCurrentTurn,
    final bool hasCalledPablo,
    final int? roundScore,
    final int totalScore,
  }) = _$PlayerModelImpl;
  const _PlayerModel._() : super._();

  factory _PlayerModel.fromJson(Map<String, dynamic> json) =
      _$PlayerModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  int get handSize;
  @override
  List<CardModel> get hand;
  @override
  bool get isConnected;
  @override
  bool get isCurrentTurn;
  @override
  bool get hasCalledPablo;
  @override
  int? get roundScore;
  @override
  int get totalScore;

  /// Create a copy of PlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerModelImplCopyWith<_$PlayerModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
