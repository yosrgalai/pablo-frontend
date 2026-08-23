import 'dart:async';

import 'package:flutter/material.dart';

import '../../../data/models/card_model.dart';
import '../../../data/models/player_model.dart';
import 'card_widget.dart';

const _tableGreen = Color(0xFF0B6B4F);
const _accentGold = Color(0xFFE0B24C);

/// Dialog "Choisissez un adversaire" — utilisé par les pouvoirs 8 et 9.
/// Retourne `null` si le joueur annule.
Future<PlayerModel?> showChooseOpponentDialog(
  BuildContext context, {
  required List<PlayerModel> opponents,
  required String title,
}) {
  return showDialog<PlayerModel>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: _tableGreen,
      title: Text(title, style: const TextStyle(color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final opponent in opponents)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white54),
                  ),
                  onPressed: () => Navigator.of(context).pop(opponent),
                  child: Text(opponent.name),
                ),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler', style: TextStyle(color: Colors.white70)),
        ),
      ],
    ),
  );
}

/// Dialog "Choisissez une position" — grille de boutons "Carte 1", "Carte
/// 2"... selon le nombre de cartes du joueur ciblé. Retourne `null` si annulé.
Future<int?> showChoosePositionDialog(
  BuildContext context, {
  required int cardCount,
  required String title,
}) {
  return showDialog<int>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: _tableGreen,
      title: Text(title, style: const TextStyle(color: Colors.white)),
      content: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (var i = 0; i < cardCount; i++)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentGold,
                foregroundColor: Colors.black,
              ),
              onPressed: () => Navigator.of(context).pop(i),
              child: Text('Carte ${i + 1}'),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler', style: TextStyle(color: Colors.white70)),
        ),
      ],
    ),
  );
}

/// Popup affichant une carte révélée pendant [duration], se ferme
/// automatiquement — utilisé par le pouvoir 8 (espionner).
Future<void> showRevealedCardDialog(
  BuildContext context, {
  required CardModel card,
  required String label,
  Duration duration = const Duration(seconds: 4),
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) => _RevealedCardDialog(card: card, label: label, duration: duration),
  );
}

class _RevealedCardDialog extends StatefulWidget {
  const _RevealedCardDialog({required this.card, required this.label, required this.duration});

  final CardModel card;
  final String label;
  final Duration duration;

  @override
  State<_RevealedCardDialog> createState() => _RevealedCardDialogState();
}

class _RevealedCardDialogState extends State<_RevealedCardDialog> {
  late int _secondsLeft = widget.duration.inSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) {
        timer.cancel();
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: _tableGreen,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.label, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 16),
          CardWidget(card: widget.card, width: 90, height: 135),
          const SizedBox(height: 12),
          Text('Fermeture dans $_secondsLeft s', style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}