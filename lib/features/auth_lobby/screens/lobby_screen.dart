import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injector.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/repositories/game_repository.dart';
import '../../game/bloc/game_bloc.dart';
import '../../game/screens/game_flow_screen.dart';
import '../bloc/lobby_bloc.dart';
import '../widgets/player_list_item.dart';

/// Salle d'attente après création/join d'une room.
///
/// Pas de bouton "Prêt" : le backend n'a aucune notion de ready. Seul
/// l'hôte a un bouton "Démarrer la partie", actif dès que ≥2 joueurs sont
/// connectés (assertion faite côté serveur dans GameService.startGame).
class LobbyScreen extends StatelessWidget {
  const LobbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LobbyBloc, LobbyState>(
      listenWhen: (prev, curr) =>
          curr is LobbyGameStarting ||
          curr is LobbyInitial ||
          (curr is LobbyRoomJoined && curr.transientError != null),
      listener: (context, state) {
        debugPrint('[LobbyScreen] state reçu : $state');
        if (state is LobbyGameStarting) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => BlocProvider<GameBloc>(
                create: (_) => GameBloc(
                  getIt<GameRepository>(),
                  gameId: state.gameId,
                  localPlayerId: state.localPlayerId,
                )..add(const GameStarted()),
                child: const GameFlowScreen(),
              ),
            ),
          );
        } else if (state is LobbyInitial) {
          Navigator.of(context).pop();
        } else if (state is LobbyRoomJoined && state.transientError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.transientError!)),
          );
          // On efface l'erreur transitoire pour ne pas la réafficher au
          // prochain rebuild (ex: si un autre event fait rebuild l'UI).
          // (pas d'emit direct possible depuis l'UI -> géré au prochain
          // event du bloc ; acceptable ici car transientError est
          // remplacé, pas ré-émis, à chaque nouvelle erreur socket.)
        }
      },
      builder: (context, state) {
        if (state is! LobbyRoomJoined) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () =>
                  context.read<LobbyBloc>().add(const LobbyLeftRequested()),
            ),
            title: Text('Salle d\'attente', style: AppTextStyles.body),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _RoomCodeCard(gameId: state.gameId, scoreLimit: state.scoreLimit),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Text('JOUEURS', style: AppTextStyles.sectionLabel),
                      const SizedBox(width: 8),
                      Text(
                        '${state.connectedCount}/${state.players.length} connectés',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.players.length,
                      itemBuilder: (_, i) =>
                          PlayerListItem(player: state.players[i]),
                    ),
                  ),
                  _BottomAction(state: state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RoomCodeCard extends StatelessWidget {
  final String gameId;
  final int scoreLimit;
  const _RoomCodeCard({required this.gameId, required this.scoreLimit});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID DE LA PARTIE', style: AppTextStyles.sectionLabel),
                const SizedBox(height: 4),
                Text(
                  gameId,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.gold,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text('Score limit : $scoreLimit pts',
                    style: AppTextStyles.caption),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, color: AppColors.textSecondary),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: gameId));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Id copié !')),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BottomAction extends StatelessWidget {
  final LobbyRoomJoined state;
  const _BottomAction({required this.state});

  @override
  Widget build(BuildContext context) {
    if (!state.isHost) {
      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Text(
          "En attente que l'hôte démarre la partie...",
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySecondary,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          onPressed: state.canStart
              ? () => context
                  .read<LobbyBloc>()
                  .add(const LobbyStartGamePressed())
              : null,
          icon: const Icon(Icons.play_arrow, color: Colors.black),
          label: Text(
            state.canStart
                ? 'Démarrer la partie'
                : 'Il faut au moins 2 joueurs connectés',
          ),
        ),
      ),
    );
  }
}