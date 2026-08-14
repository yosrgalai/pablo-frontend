import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// ROUND_SCORING — placeholder minimal. Le payload brut de `round:ended`
/// (roundScores par playerId) est affiché tel quel en attendant une vraie
/// maquette de révélation des cartes + scores (nécessite les CardModel
/// des mains de chacun, pas encore exposés par cet event côté backend).
class RoundScoringPlaceholderScreen extends StatelessWidget {
  final Map<String, dynamic> payload;
  const RoundScoringPlaceholderScreen({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    final roundScores = payload['roundScores'] as Map<String, dynamic>?;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.flag_circle, color: AppColors.gold, size: 40),
              const SizedBox(height: 12),
              Text('Fin de la manche', style: AppTextStyles.screenTitle),
              const SizedBox(height: 16),
              if (roundScores != null)
                ...roundScores.entries.map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'Joueur ${e.key} : ${e.value} pts cette manche',
                      style: AppTextStyles.body,
                    ),
                  ),
                )
              else
                Text('En attente de la manche suivante...',
                    style: AppTextStyles.bodySecondary),
            ],
          ),
        ),
      ),
    );
  }
}