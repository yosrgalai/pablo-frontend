/// Constantes de validation partagées entre les DTOs.
/// Miroir des contraintes `class-validator` du backend — à garder synchronisé.
class DtoConstraints {
  DtoConstraints._();

  /// Positions valides dans une main (4 cartes : index 0 à 3).
  static const int minHandPosition = 0;
  static const int maxHandPosition = 3;

  /// Rangs de cartes possédant un pouvoir spécial (doc §5).
  static const List<int> powerRanks = [7, 8, 9];

  /// Limites de score autorisées à la création d'une partie.
  static const List<int> allowedScoreLimits = [50, 100, 150];

  /// Nombre de joueurs autorisé.
  static const int minPlayers = 2;
  static const int maxPlayers = 8;
}
