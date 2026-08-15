import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocBuilder<GameBloc, GameState>(
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