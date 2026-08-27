import 'package:flutter/material.dart';

import 'card_scoring_info_sheet.dart';

/// Bouton "i" permanent — accessible à tout moment (peek, tour, scoring)
/// pour rappeler la valeur de chaque carte, en particulier l'exception du
/// Roi rouge (doc §7). Même style que le bouton "Quitter la partie"
/// (`game_flow_screen.dart`), pour rester cohérent visuellement, mais à
/// l'opposé sur l'écran pour ne jamais se chevaucher avec lui.
class ScoringInfoButton extends StatelessWidget {
  const ScoringInfoButton({super.key});

  static const _surface = Color(0xFF1B1F3B);
  static const _accentGold = Color(0xFFE0B24C);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _surface.withValues(alpha: 0.85),
      shape: const CircleBorder(),
      child: IconButton(
        icon: const Icon(Icons.info_outline, color: _accentGold),
        tooltip: 'Valeur des cartes',
        onPressed: () => showCardScoringInfo(context),
      ),
    );
  }
}