import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../bloc/game_bloc.dart';

/// Squelette minimal de PLAYER_TURN (Dev A) : indique qui a la main et
/// expose le bouton "Annoncer Pablo". Le vrai plateau (pioche, défausse,
/// main visible, échanges, pouvoirs) reste à brancher avec les widgets de
/// Dev B (`GameTableLayout`, `CardWidget`...) une fois leurs events de
/// tour (turn:drew_card, turn:swapped_card, turn:discarded_card...)
/// intégrés ici ou dans un Bloc dédié.
class PlayerTurnScreen extends StatelessWidget {
  const PlayerTurnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        if (state is! GamePlayerTurnState) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state.pabloCalled)
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(AppRadii.sm),
                        border: Border.all(color: AppColors.gold),
                      ),
                      child: Text(
                        'Pablo annoncé ! Dernier tour en cours.',
                        style: AppTextStyles.body.copyWith(color: AppColors.gold),
                      ),
                    ),
                  Icon(
                    state.isLocalTurn ? Icons.priority_high : Icons.hourglass_top,
                    color: AppColors.gold,
                    size: 40,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    state.isLocalTurn
                        ? "C'est ton tour !"
                        : "En attente du joueur ${state.currentPlayerId}...",
                    style: AppTextStyles.screenTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Plateau de jeu (pioche, main, défausse) à venir ici.',
                    style: AppTextStyles.caption,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  if (state.isLocalTurn && !state.pabloCalled)
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () => context
                            .read<GameBloc>()
                            .add(const GameCallPabloPressed()),
                        icon: const Icon(Icons.flag, color: Colors.black),
                        label: const Text('Annoncer Pablo'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}