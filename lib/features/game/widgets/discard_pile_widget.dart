import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../data/models/card_model.dart';
import 'card_widget.dart';

/// Défausse : affiche toujours la carte du dessus, face visible
/// (jamais cachée — c'est une carte publique par définition).
/// Affiche un emplacement vide si aucune carte n'a encore été défaussée.
///
/// Chaque nouvelle carte (identifiée par son `id`) joue une animation
/// d'entrée (fondu + zoom léger) au moment où elle arrive en défausse.
class DiscardPileWidget extends StatelessWidget {
  const DiscardPileWidget({
    super.key,
    required this.topCard,
    this.onTap,
    this.width = 60,
  });

  final CardModel? topCard;
  final VoidCallback? onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    final height = width * 1.5;
    final card = topCard;

    if (card == null) {
      return _EmptySlot(width: width, height: height);
    }

    return CardWidget(
      card: card,
      width: width,
      height: height,
      visualState:
          onTap == null ? CardVisualState.normal : CardVisualState.selectable,
      onTap: onTap,
    )
        .animate(key: ValueKey('discard-${card.id}'))
        .fadeIn(duration: 220.ms, curve: Curves.easeOut)
        .scale(begin: const Offset(0.75, 0.75), end: const Offset(1, 1), duration: 220.ms, curve: Curves.easeOut);
  }
}

class _EmptySlot extends StatelessWidget {
  const _EmptySlot({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width * 0.12),
        border: Border.all(color: Colors.white24, width: 2),
      ),
    );
  }
}