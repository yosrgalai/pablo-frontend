
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../bloc/game_bloc.dart';

/// INITIAL_PEEK : le joueur choisit 2 de ses 4 cartes à regarder, avant
/// retournement automatique (doc §3). Utilise des cartes simplifiées
/// (rectangles) ici plutôt que le vrai `CardWidget` de Dev B — à
/// remplacer si on veut le rendu final identique au plateau de jeu.
class InitialPeekScreen extends StatefulWidget {
  const InitialPeekScreen({super.key});

  static const int timerSeconds = 20;

  @override
  State<InitialPeekScreen> createState() => _InitialPeekScreenState();
}

class _InitialPeekScreenState extends State<InitialPeekScreen> {
  Timer? _timer;
  int _secondsLeft = InitialPeekScreen.timerSeconds;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    _secondsLeft = InitialPeekScreen.timerSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) {
        _timer?.cancel();
        _autoConfirmIfNeeded();
      }
    });
  }

  /// Timeout écoulé : si le joueur n'a pas choisi 2 positions, on en
  /// sélectionne automatiquement pour lui (les 2 premières) plutôt que de
  /// bloquer indéfiniment la partie pour tout le monde.
  void _autoConfirmIfNeeded() {
    final bloc = context.read<GameBloc>();
    final state = bloc.state;
    if (state is! GameInitialPeekState || state.confirmed) return;

    if (state.selected.length < 2) {
      for (var i = 0; i < state.positions.length && bloc.state is GameInitialPeekState; i++) {
        final current = bloc.state as GameInitialPeekState;
        if (current.selected.length >= 2) break;
        if (!current.selected.contains(i)) {
          bloc.add(GamePeekPositionToggled(i));
        }
      }
    }
    bloc.add(const GameConfirmInitialPeekPressed());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameBloc, GameState>(
      listenWhen: (prev, curr) => curr is! GameInitialPeekState,
      listener: (context, state) {
        // Dès qu'on quitte INITIAL_PEEK (peek confirmé -> en attente des
        // autres, ou erreur), le timer local n'a plus lieu d'être.
        _timer?.cancel();
      },
      builder: (context, state) {
        if (state is GameWaitingOthersPeekState) {
          return _WaitingOthersView(revealedCount: state.revealedCards.length);
        }

        if (state is! GameInitialPeekState) {
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
                  Text('Mémorise 2 de tes cartes',
                      style: AppTextStyles.screenTitle,
                      textAlign: TextAlign.center),
                  const SizedBox(height: 6),
                  Text(
                    'Choisis 2 des 4 cartes ci-dessous — tu ne pourras plus '
                    'les revoir ensuite.',
                    style: AppTextStyles.bodySecondary,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                  _TimerRing(secondsLeft: _secondsLeft, total: InitialPeekScreen.timerSeconds),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < state.positions.length; i++) ...[
                        if (i > 0) const SizedBox(width: 12),
                        _PeekCardSlot(
                          position: i,
                          isSelected: state.selected.contains(i),
                          disabled: state.confirmed ||
                              (!state.selected.contains(i) && state.selected.length >= 2),
                          onTap: state.confirmed
                              ? null
                              : () => context
                                  .read<GameBloc>()
                                  .add(GamePeekPositionToggled(i)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: (state.selected.length == 2 && !state.confirmed)
                          ? () => context
                              .read<GameBloc>()
                              .add(const GameConfirmInitialPeekPressed())
                          : null,
                      child: Text(
                        state.confirmed
                            ? 'Confirmé, en attente...'
                            : 'Regarder ces cartes (${state.selected.length}/2)',
                      ),
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

class _TimerRing extends StatelessWidget {
  final int secondsLeft;
  final int total;
  const _TimerRing({required this.secondsLeft, required this.total});

  @override
  Widget build(BuildContext context) {
    final progress = (secondsLeft / total).clamp(0.0, 1.0);
    final urgent = secondsLeft <= 5;
    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 4,
            backgroundColor: AppColors.surfaceElevated,
            valueColor: AlwaysStoppedAnimation(
              urgent ? AppColors.danger : AppColors.gold,
            ),
          ),
          Text(
            '$secondsLeft',
            style: TextStyle(
              color: urgent ? AppColors.danger : AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _PeekCardSlot extends StatelessWidget {
  final int position;
  final bool isSelected;
  final bool disabled;
  final VoidCallback? onTap;

  const _PeekCardSlot({
    required this.position,
    required this.isSelected,
    required this.disabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Opacity(
        opacity: disabled && !isSelected ? 0.4 : 1.0,
        child: Container(
          width: 64,
          height: 96,
          decoration: BoxDecoration(
            color: AppColors.cardBack,
            borderRadius: BorderRadius.circular(AppRadii.sm),
            border: Border.all(
              color: isSelected ? AppColors.gold : AppColors.border,
              width: isSelected ? 3 : 1,
            ),
          ),
          child: Center(
            child: Icon(
              isSelected ? Icons.visibility : Icons.help_outline,
              color: isSelected ? AppColors.gold : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _WaitingOthersView extends StatelessWidget {
  final int revealedCount;
  const _WaitingOthersView({required this.revealedCount});

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
                const CircularProgressIndicator(color: AppColors.gold),
                const SizedBox(height: 16),
                Text('En attente des autres joueurs...',
                    style: AppTextStyles.body, textAlign: TextAlign.center),
                const SizedBox(height: 6),
                Text(
                  'Tu as mémorisé $revealedCount cartes.',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}