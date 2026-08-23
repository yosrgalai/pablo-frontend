import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import '../../../core/di/injector.dart';
import '../../../core/network/socket_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/repositories/game_repository.dart';
import '../bloc/game_bloc.dart';
import 'game_over_placeholder_screen.dart';
import 'game_table_screen.dart';
import 'round_scoring_placeholder_screen.dart';

/// Bascule entre les écrans selon l'état du GameBloc.
///
/// `GameInitialPeekState`, `GameWaitingOthersPeekState` ET
/// `GamePlayerTurnState` pointent TOUS vers `GameTableScreen` (widgets
/// Dev B : `GameTurnController`).
///
/// ⚠️ `GameTableScreen()` est volontairement PAS `const` dans build() :
/// avec `const`, Flutter considère le widget comme strictement identique
/// à chaque reconstruction de ce `BlocBuilder` et saute la reconstruction
/// de l'écran enfant — ce qui bloquait toute mise à jour (tour qui
/// démarre, etc.) même quand `GameBloc` changeait bien d'état.
///
/// Reste un `StatefulWidget` (pas `StatelessWidget`) : c'est nécessaire
/// pour l'abonnement à `GameRepository.onError` (affichage des messages
/// informatifs du backend en SnackBar, sans jamais casser l'écran en
/// cours — cf. bugfix précédent où un event "joueur déconnecté" écrasait
/// tout le GameState).
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
            return const _SimpleLoading(label: 'Chargement...');
          },
        ),
        Positioned(
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

/// Bouton "Quitter la partie" — toujours visible en overlay pendant la
/// partie, quel que soit l'écran affiché en dessous (initial peek, tour,
/// scoring...). Déconnecte réellement le socket (déclenche la vraie
/// gestion de déconnexion côté backend, doc §9.3 — timer de 30s avant
/// exclusion) plutôt que de juste naviguer en arrière sans le prévenir.
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