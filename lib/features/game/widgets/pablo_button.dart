import 'package:flutter/material.dart';

/// Bouton "Annoncer Pablo" (design system doc 03).
///
/// Rouge/alerte plutôt que doré comme le reste des CTA : c'est une action
/// engageante et IRRÉVERSIBLE (elle démarre le dernier tour pour tout le
/// monde), elle doit se distinguer visuellement des actions de tour
/// normales (piocher, échanger, défausser une paire).
///
/// Affiché par [GameTurnController] uniquement quand c'est au joueur
/// local de jouer, en phase `idle` (avant d'avoir pioché), et tant que
/// personne n'a encore annoncé Pablo dans la manche en cours.
class PabloButton extends StatelessWidget {
  const PabloButton({super.key, required this.onPressed});

  /// Appelé seulement après confirmation de l'utilisateur. C'est à
  /// l'appelant d'émettre `call_pablo` (via `GameCallPabloPressed` sur le
  /// `GameBloc`, qui délègue lui-même à `GameRepository.callPablo`).
  final VoidCallback onPressed;

  static const _accentGold = Color(0xFFE0B24C);
  static const _danger = Color(0xFFD64545);
  static const _tableGreen = Color(0xFF0B6B4F);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: _danger,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        elevation: 4,
      ),
      onPressed: () => _confirmAndCall(context),
      icon: const Icon(Icons.flag, size: 18),
      label: const Text(
        'Annoncer Pablo',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<void> _confirmAndCall(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: _tableGreen,
        title: const Text('Annoncer Pablo ?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'La manche se termine immédiatement et toutes les cartes sont '
          'révélées. Si un autre joueur a un score égal ou inférieur au '
          'vôtre, vous prenez une pénalité.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _accentGold,
              foregroundColor: Colors.black,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );

    if (confirmed == true) onPressed();
  }
}