import 'package:freezed_annotation/freezed_annotation.dart';

part 'join_game_dto.freezed.dart';
part 'join_game_dto.g.dart';

/// Miroir de `JoinGameDto` (backend).
/// Envoyé juste après la connexion socket pour rejoindre la room
/// Socket.IO correspondant à la partie (`game:{gameId}`).
///
/// [gameId] et [playerId] doivent être des UUID valides.
@freezed
class JoinGameDto with _$JoinGameDto {
  const factory JoinGameDto({
    required String gameId,
    required String playerId,
  }) = _JoinGameDto;

  factory JoinGameDto.fromJson(Map<String, dynamic> json) =>
      _$JoinGameDtoFromJson(json);
}
