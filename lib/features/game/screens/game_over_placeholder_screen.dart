import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// GAME_OVER — placeholder minimal. `payload['winner']` = { id, name, score }
/// (cf. GameGateway -> ServerEvents.GAME_ENDED).
class GameOverPlaceholderScreen extends StatelessWidget {
  final Map<String, dynamic> payload;
  const GameOverPlaceholderScreen({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    final winner = payload['winner'] as Map<String, dynamic>?;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.emoji_events, color: AppColors.gold, size: 56),
                const SizedBox(height: 16),
                Text('Partie terminée !', style: AppTextStyles.screenTitle),
                const SizedBox(height: 8),
                if (winner != null)
                  Text(
                    '🏆 ${winner['name']} gagne avec ${winner['score']} pts',
                    style: AppTextStyles.body,
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).popUntil((r) => r.isFirst),
                  child: const Text('Retour à l\'accueil'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}