import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import '../../../core/theme/app_theme.dart';
import '../../../core/di/injector.dart';
import '../../../data/repositories/game_repository.dart';
import '../bloc/game_bloc.dart';
import 'game_over_placeholder_screen.dart';
import 'initial_peek_screen.dart';
import 'player_turn_screen.dart';
import 'round_scoring_placeholder_screen.dart';

class GameFlowScreen extends StatefulWidget {
  const GameFlowScreen({super.key});

  @override
  State<GameFlowScreen> createState() => _GameFlowScreenState();
}

class _GameFlowScreenState extends State<GameFlowScreen> {
  StreamSubscription<String>? _errorSub;

  @override
  void initState() {
    super.initState();
    // Messages informatifs du backend (ex: "joueur X déconnecté", "pouvoir
    // expiré") : affichés en toast, SANS jamais casser l'écran en cours —
    // contrairement à avant où ça écrasait tout le GameState (bug corrigé).
    _errorSub = getIt<GameRepository>().onError.listen((message) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    });
  }

  @override
  void dispose() {
    _errorSub?.cancel();
    super.dispose();
  }

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