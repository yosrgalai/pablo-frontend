import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injector.dart';
import '../../../core/network/socket_service.dart';
import '../../../core/theme/app_theme.dart';
import '../bloc/game_bloc.dart';
import 'game_over_placeholder_screen.dart';
import 'game_table_screen.dart';
import 'round_scoring_placeholder_screen.dart';

/// Bascule entre les écrans selon l'état du GameBloc.
///
/// IMPORTANT : `GameInitialPeekState`, `GameWaitingOthersPeekState` ET
/// `GamePlayerTurnState` pointent TOUS vers `GameTableScreen` (nos
/// widgets : `GameTurnController`).
///
/// ⚠️ `GameTableScreen()` est volontairement PAS `const` ici : avec
/// `const`, Flutter considère le widget comme strictement identique à
/// chaque reconstruction de ce `BlocBuilder` et saute la reconstruction
/// de l'écran enfant — ce qui bloquait toute mise à jour (tour qui
/// démarre, etc.) même quand `GameBloc` changeait bien d'état.
class GameFlowScreen extends StatelessWidget {
  const GameFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<GameBloc, GameState>(
          builder: (context, state) {
            if (state is GameDealingState) {
              return const _SimpleLoading(label: 'Distribution des cartes...');
            }
            if (state is GameInitialPeekState ||
                state is GameWaitingOthersPeekState ||
                state is GamePlayerTurnState) {
              return GameTableScreen(); // pas const, voir doc ci-dessus
            }
            if (state is GameRoundScoringState) {
              return RoundScoringPlaceholderScreen(payload: state.payload);
            }
            if (state is GameOverState) {
              return GameOverPlaceholderScreen(payload: state.payload);
            }
            if (state is GameErrorState) {
              return _SimpleError(message: state.message);
            }
            return const _SimpleLoading(label: 'Chargement...');
          },
        ),
        // Bouton "Quitter la partie" — toujours visible en overlay,
        // quel que soit l'écran affiché en dessous. N'affecte aucune
        // logique existante : c'est juste une couche au-dessus.
        const Positioned(
          top: 8,
          left: 8,
          child: SafeArea(
            child: _LeaveGameButton(),
          ),
        ),
      ],
    );
  }
}

/// Déconnecte réellement le socket (déclenche la vraie gestion de
/// déconnexion côté backend, doc §9.3 — timer de 30s avant exclusion),
/// puis se reconnecte immédiatement pour que le Home reste utilisable.
class _LeaveGameButton extends StatelessWidget {
  const _LeaveGameButton();

  Future<void> _confirmAndLeave(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Quitter la partie ?'),
        content: const Text(
          'Tu seras déconnecté. Si tu ne reviens pas assez vite, tu seras '
          'exclu de la partie en cours.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Quitter', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    getIt<SocketService>().disconnect();
    getIt<SocketService>().reconnect();

    if (context.mounted) {
      Navigator.of(context).popUntil((r) => r.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface.withOpacity(0.85),
      shape: const CircleBorder(),
      child: IconButton(
        icon: const Icon(Icons.logout, color: AppColors.danger),
        tooltip: 'Quitter la partie',
        onPressed: () => _confirmAndLeave(context),
      ),
    );
  }
}

class _SimpleLoading extends StatelessWidget {
  final String label;
  const _SimpleLoading({required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppColors.gold),
            const SizedBox(height: 12),
            Text(label, style: AppTextStyles.bodySecondary),
          ],
        ),
      ),
    );
  }
}

class _SimpleError extends StatelessWidget {
  final String message;
  const _SimpleError({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            message,
            style: AppTextStyles.body.copyWith(color: AppColors.danger),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}