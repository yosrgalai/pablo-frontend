import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../bloc/game_bloc.dart';
import 'game_over_placeholder_screen.dart';
import 'initial_peek_screen.dart';
import 'player_turn_screen.dart';
import 'round_scoring_placeholder_screen.dart';

/// Bascule entre les écrans selon l'état du GameBloc — le squelette de
/// navigation demandé pour Dev A. Suppose qu'un GameBloc est déjà fourni
/// au-dessus dans l'arbre (BlocProvider) et que GameStarted a déjà été
/// dispatché (fait à la construction du provider, cf. lobby_screen.dart).
class GameFlowScreen extends StatelessWidget {
  const GameFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        if (state is GameDealingState) {
          return const _SimpleLoading(label: 'Distribution des cartes...');
        }
        if (state is GameInitialPeekState || state is GameWaitingOthersPeekState) {
          return const InitialPeekScreen();
        }
        if (state is GamePlayerTurnState) {
          return const PlayerTurnScreen();
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