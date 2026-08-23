import 'package:flutter/material.dart';

import '../../../data/models/card_model.dart';
import 'card_widget.dart';
import 'draw_pile_widget.dart' show drawPileHeroTag;

/// Feuille de décision affichée juste après avoir pioché : le joueur
/// choisit d'échanger la carte avec une carte de sa main, ou de la
/// défausser directement.
///
/// Si la carte défaussée a un pouvoir (7, 8 ou 9), une confirmation
/// supplémentaire est demandée — l'activation n'est JAMAIS automatique
/// (doc backend §4 : "le joueur peut choisir de l'activer").
class DrawDecisionSheet extends StatelessWidget {
  const DrawDecisionSheet({
    super.key,
    required this.drawnCard,
    required this.onChooseSwap,
    required this.onChooseDiscard,
  });

  final CardModel drawnCard;
  final VoidCallback onChooseSwap;

  /// `usePower` reflète le choix explicite du joueur, uniquement pertinent
  /// si `drawnCard.hasPower` — ignoré sinon côté DiscardCardDto.
  final void Function(bool usePower) onChooseDiscard;

  static const _accentGold = Color(0xFFE0B24C);
  static const _tableGreen = Color(0xFF0B6B4F);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Carte piochée — que faire ?',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 12),
            // Même tag que DrawPileWidget : la carte "vole" visuellement
            // de la pioche jusqu'ici à l'ouverture de la feuille.
            Hero(
              tag: drawPileHeroTag,
              child: CardWidget(card: drawnCard, width: 80, height: 120),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white54),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: onChooseSwap,
                    child: const Text('Échanger avec ma main'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accentGold,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => _handleDiscardTap(context),
                    child: const Text('Défausser'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleDiscardTap(BuildContext context) {
    // Carte sans pouvoir -> pas de question à poser.
    if (!drawnCard.hasPower) {
      onChooseDiscard(false);
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: _tableGreen,
        title: const Text('Activer le pouvoir ?', style: TextStyle(color: Colors.white)),
        content: Text(
          _powerDescription(drawnCard.rank!),
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              onChooseDiscard(false);
            },
            child: const Text('Non, juste défausser'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _accentGold,
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              onChooseDiscard(true);
            },
            child: const Text('Oui, activer'),
          ),
        ],
      ),
    );
  }

  String _powerDescription(String rank) {
    switch (rank) {
      case '7':
        return 'Regardez une de vos propres cartes cachées.';
      case '8':
        return "Regardez une carte cachée d'un adversaire.";
      case '9':
        return 'Échangez une de vos cartes avec celle d\'un adversaire, sans regarder aucune des deux.';
      default:
        return '';
    }
  }
}