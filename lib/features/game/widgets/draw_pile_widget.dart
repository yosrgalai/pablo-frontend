import 'package:flutter/material.dart';

import '../../../data/models/card_model.dart';
import 'card_widget.dart';

/// Pioche affichée au centre de la table.
/// Purement visuel + callback : c'est à l'appelant d'émettre `turn:draw`
/// (via `DrawCardDto`) quand [onTap] est déclenché.
class DrawPileWidget extends StatelessWidget {
  const DrawPileWidget({
    super.key,
    required this.count,
    this.onTap,
    this.width = 60,
  });

  /// Nombre de cartes restantes (`drawPileCount` de [RoundModel]).
  /// Le contenu réel de la pioche n'est jamais connu côté client
  /// (règle de sécurité, doc 01 section 3).
  final int count;
  final VoidCallback? onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    final height = width * 1.5;
    final isEmpty = count <= 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CardWidget(
          card: const CardModel(id: 'draw_pile', hidden: true),
          width: width,
          height: height,
          visualState:
              isEmpty ? CardVisualState.disabled : CardVisualState.selectable,
          onTap: isEmpty ? null : onTap,
        ),
        const SizedBox(height: 4),
        Text('$count', style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}
