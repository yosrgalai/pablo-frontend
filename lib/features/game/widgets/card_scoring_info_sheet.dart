import 'package:flutter/material.dart';

const _tableGreen = Color(0xFF0B6B4F);
const _accentGold = Color(0xFFE0B24C);
const _danger = Color(0xFFD64545);

/// Ouvre la feuille récapitulant la valeur de chaque carte (doc §7).
/// Accessible à tout moment via [ScoringInfoButton].
Future<void> showCardScoringInfo(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: _tableGreen,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => const _ScoringInfoSheet(),
  );
}

class _ScoringInfoSheet extends StatelessWidget {
  const _ScoringInfoSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info_outline, color: _accentGold),
                const SizedBox(width: 8),
                const Text(
                  'Valeur des cartes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Le but est de terminer la manche avec le score le plus bas.',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Alerte mise en avant : LA règle contre-intuitive du jeu.
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _danger.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _danger.withValues(alpha: 0.6)),
              ),
              child: Row(
                children: [
                  _ValueBadge(value: '0'),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Le Roi ROUGE (♥ ou ♦) vaut 0 point — c\'est la '
                      'meilleure carte du jeu. Le Roi NOIR (♠ ou ♣), lui, '
                      'vaut 10 points comme une figure normale.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            const _ScoreRow(label: 'As', value: '10'),
            const _ScoreRow(label: '2 à 10', value: 'valeur affichée'),
            const _ScoreRow(label: 'Valet / Dame', value: '10'),
            const _ScoreRow(label: 'Roi noir (♠ ♣)', value: '10'),
            const _ScoreRow(label: 'Roi rouge (♥ ♦)', value: '0', highlight: true),
            const _ScoreRow(label: 'Joker', value: '0', highlight: true),
          ],
        ),
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  const _ScoreRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: highlight ? _accentGold : Colors.white,
                fontSize: 14,
                fontWeight: highlight ? FontWeight.w700 : FontWeight.normal,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: highlight ? _accentGold : Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ValueBadge extends StatelessWidget {
  const _ValueBadge({required this.value});
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: _danger, width: 1.5),
      ),
      child: Text(
        value,
        style: const TextStyle(
          color: Color(0xFF1B1F3B),
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }
}