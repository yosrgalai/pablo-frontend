import 'package:freezed_annotation/freezed_annotation.dart';

part 'pair_attempt_dto.freezed.dart';
part 'pair_attempt_dto.g.dart';

/// Miroir de `PairAttemptDto` (backend) — doc §4, Option B.
///
/// Le joueur choisit deux cartes de sa main et parie qu'elles ont la
/// même valeur. [firstPosition] et [secondPosition] doivent être entre
/// 0 et 3, et OBLIGATOIREMENT différents (contrainte `IsDifferentPositionConstraint`
/// côté backend — à revalider côté UI avant envoi, ex. désactiver la
/// sélection si les deux positions sont identiques).
///
/// Rappel (non vérifiable ici, dépend de l'état en base côté serveur) :
/// - le joueur doit avoir encore 4 cartes en main au début de son tour
/// - jamais disponible s'il ne lui reste que 2 ou 3 cartes
@freezed
abstract class PairAttemptDto with _$PairAttemptDto {
  const factory PairAttemptDto({
    required String gameId,
    required String playerId,
    required int firstPosition,
    required int secondPosition,
  }) = _PairAttemptDto;

  factory PairAttemptDto.fromJson(Map<String, dynamic> json) =>
      _$PairAttemptDtoFromJson(json);
}
