import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../data/models/card_model.dart';
import 'card_widget.dart';

/// Main du joueur local, affichée en bas de l'écran.
///
/// Calcule automatiquement la taille des cartes selon la largeur
/// disponible et le nombre de cartes (4 normalement, jusqu'à 5+ après une
/// pénalité de paire ratée) pour toujours tenir sans scroll horizontal
/// (contrainte "écran de téléphone", doc backend §3).
///
/// Chaque carte est identifiée par son `id` (via `ValueKey`) : quand une
/// NOUVELLE carte apparaît à une position (échange, pénalité), elle joue
/// une animation d'entrée (fondu + léger glissement). Les cartes déjà
/// présentes ne la rejouent jamais, y compris quand leur état visuel
/// change (sélection, désactivation).
class PlayerHandWidget extends StatelessWidget {
  const PlayerHandWidget({
    super.key,
    required this.hand,
    this.selectedPositions = const {},
    this.disabledPositions = const {},
    this.onCardTap,
    this.maxCardWidth = 70,
    this.maxCardHeight,
    this.spacing = 8,
  });

  /// Cartes du joueur local, dans l'ordre de position (index = position
  /// utilisée dans SwapCardDto / PairAttemptDto / PowerTargetDto).
  final List<CardModel> hand;

  /// Positions actuellement sélectionnées (ex: pendant une tentative de paire).
  final Set<int> selectedPositions;

  /// Positions non interactives dans le contexte actuel (ex: hors tour).
  final Set<int> disabledPositions;

  /// Appelé avec la position tapée. `null` = main non interactive.
  final void Function(int position)? onCardTap;

  final double maxCardWidth;

  /// Contrainte de hauteur (utile en paysage : la hauteur d'écran devient
  /// la ressource la plus rare, pas la largeur). Si fournie, la largeur de
  /// carte est aussi bornée par `maxCardHeight / 1.5` (ratio 2:3).
  final double? maxCardHeight;

  final double spacing;

  @override
  Widget build(BuildContext context) {
    if (hand.isEmpty) {
      return const SizedBox(height: 90);
    }

    final effectiveMaxWidth = maxCardHeight == null
        ? maxCardWidth
        : (maxCardWidth < maxCardHeight! / 1.5 ? maxCardWidth : maxCardHeight! / 1.5);

    return LayoutBuilder(
      builder: (context, constraints) {
        final count = hand.length;
        final totalSpacing = spacing * (count - 1);
        final widthPerCard = ((constraints.maxWidth - totalSpacing) / count)
            .clamp(36.0, effectiveMaxWidth);
        final height = widthPerCard * 1.5; // ratio 2:3, cf. design system

        return SizedBox(
          height: height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < count; i++) ...[
                if (i > 0) SizedBox(width: spacing),
                CardWidget(
                  card: hand[i],
                  width: widthPerCard,
                  height: height,
                  visualState: _stateFor(i),
                  onTap: onCardTap == null ? null : () => onCardTap!(i),
                )
                    .animate(key: ValueKey('hand-${hand[i].id}'))
                    .fadeIn(duration: 250.ms, curve: Curves.easeOut)
                    .slideY(begin: 0.18, end: 0, duration: 250.ms, curve: Curves.easeOut),
              ],
            ],
          ),
        );
      },
    );
  }

  CardVisualState _stateFor(int position) {
    if (disabledPositions.contains(position)) return CardVisualState.disabled;
    if (selectedPositions.contains(position)) return CardVisualState.selected;
    if (onCardTap != null) return CardVisualState.selectable;
    return CardVisualState.normal;
  }
}