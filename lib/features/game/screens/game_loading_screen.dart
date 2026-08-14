import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Placeholder affiché juste après `game:dealt`, en attendant que le vrai
/// `GameBloc` + `game_table_screen` (Dev A pour le squelette de state
/// machine / Dev B pour les cartes) soient branchés ici.
///
/// Sans cet écran, LobbyScreen restait bloqué sur un spinner infini dès
/// que l'hôte démarrait la partie, car `LobbyGameStarting` n'avait nulle
/// part où naviguer (bug identifié en test).
class GameLoadingScreen extends StatelessWidget {
  final String gameId;
  const GameLoadingScreen({super.key, required this.gameId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.style, color: AppColors.gold, size: 48),
                const SizedBox(height: 16),
                Text('La partie a démarré !', style: AppTextStyles.screenTitle),
                const SizedBox(height: 8),
                Text(
                  'gameId: $gameId',
                  style: AppTextStyles.caption,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  "Écran de jeu (plateau, cartes, tours) pas encore branché ici.\n"
                  "TODO: remplacer par le vrai GameBloc + game_table_screen.",
                  style: AppTextStyles.bodySecondary,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}