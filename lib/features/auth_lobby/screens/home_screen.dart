import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injector.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/repositories/game_repository.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/lobby_bloc.dart';
import 'create_room_screen.dart';
import 'lobby_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _joinCodeController = TextEditingController();
  bool _joining = false;
  // Tant que la modale Create Lobby est ouverte, c'est SON propre
  // BlocListener qui doit gérer LobbyRoomJoined (pop + navigation gérée
  // ensuite par _openCreateLobbyDialog). Sans ce garde-fou, les deux
  // listeners réagissent en même temps à la même émission d'état et se
  // marchent dessus : HomeScreen pousse LobbyScreen, puis le pop(true) de
  // la modale referme cette route fraîchement poussée au lieu de la
  // modale elle-même -> le Future de showDialog ne se résout jamais et
  // la modale reste figée indéfiniment (bug observé en test).
  bool _createDialogOpen = false;

  List<OpenGameSummary>? _openGames;
  bool _loadingOpenGames = false;
  String? _openGamesError;

  @override
  void initState() {
    super.initState();
    _loadOpenGames();
  }

  Future<void> _loadOpenGames() async {
    setState(() {
      _loadingOpenGames = true;
      _openGamesError = null;
    });
    try {
      final games = await getIt<GameRepository>().listOpenGames();
      if (!mounted) return;
      setState(() {
        _openGames = games;
        _loadingOpenGames = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _openGamesError = 'Impossible de charger les parties ouvertes.';
        _loadingOpenGames = false;
      });
    }
  }

  void _joinOpenGame(String gameId) {
    setState(() => _joining = true);
    context.read<LobbyBloc>().add(LobbyJoinRequested(gameId: gameId));
  }

  @override
  void dispose() {
    _joinCodeController.dispose();
    super.dispose();
  }

  void _openCreateLobbyDialog() async {
    setState(() => _createDialogOpen = true);
    final created = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => BlocProvider.value(
        value: context.read<LobbyBloc>(),
        child: const CreateRoomScreen(),
      ),
    );
    setState(() => _createDialogOpen = false);
    if (created == true && mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const LobbyScreen()),
      );
    }
  }

  void _submitJoinCode() {
    final gameId = _joinCodeController.text.trim();
    if (gameId.isEmpty) return;
    setState(() => _joining = true);
    context.read<LobbyBloc>().add(LobbyJoinRequested(gameId: gameId));
  }

  @override
  Widget build(BuildContext context) {
    final displayName = context.select<AuthCubit, String>((cubit) {
      final s = cubit.state;
      return s is AuthAuthenticated ? s.user.displayName : '';
    });

    return BlocListener<LobbyBloc, LobbyState>(
      listener: (context, state) {
        if (state is LobbyRoomJoined) {
          if (_createDialogOpen) return; // la modale gère déjà ce cas
          setState(() => _joining = false);
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const LobbyScreen()),
          );
        } else if (state is LobbyError) {
          setState(() => _joining = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: AppColors.textSecondary),
              onPressed: () => context.read<AuthCubit>().logout(),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pablo', style: AppTextStyles.screenTitle),
                const SizedBox(height: 4),
                Text(
                  displayName.isEmpty
                      ? 'Jeu de mémoire, de bluff et de gestion du risque.'
                      : 'Salut $displayName 👋',
                  style: AppTextStyles.bodySecondary,
                ),
                const SizedBox(height: 24),
                _GameHeroCard(onCreateLobby: _openCreateLobbyDialog),
                const SizedBox(height: 28),
                Text('REJOINDRE AVEC UN CODE',
                    style: AppTextStyles.sectionLabel),
                const SizedBox(height: 4),
                Text(
                  "L'id de la partie (donné par celui qui l'a créée).",
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 10),
                _JoinWithCodeField(
                  controller: _joinCodeController,
                  isLoading: _joining,
                  onSubmit: _submitJoinCode,
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('PARTIES OUVERTES', style: AppTextStyles.sectionLabel),
                    IconButton(
                      icon: const Icon(Icons.refresh,
                          color: AppColors.textSecondary, size: 18),
                      onPressed: _loadingOpenGames ? null : _loadOpenGames,
                    ),
                  ],
                ),
                _OpenGamesSection(
                  games: _openGames,
                  isLoading: _loadingOpenGames,
                  error: _openGamesError,
                  isJoining: _joining,
                  onJoin: _joinOpenGame,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GameHeroCard extends StatelessWidget {
  final VoidCallback onCreateLobby;
  const _GameHeroCard({required this.onCreateLobby});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.cardBack,
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            child: const Icon(Icons.style, color: AppColors.gold, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Pablo', style: AppTextStyles.body),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.people,
                        size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text('2–4 joueurs', style: AppTextStyles.caption),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: onCreateLobby,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Create Lobby'),
          ),
        ],
      ),
    );
  }
}

class _OpenGamesSection extends StatelessWidget {
  final List<OpenGameSummary>? games;
  final bool isLoading;
  final String? error;
  final bool isJoining;
  final ValueChanged<String> onJoin;

  const _OpenGamesSection({
    required this.games,
    required this.isLoading,
    required this.error,
    required this.isJoining,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && games == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.gold),
        ),
      );
    }
    if (error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(error!, style: AppTextStyles.caption),
      );
    }
    if (games == null || games!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text('Aucune partie ouverte pour le moment.',
            style: AppTextStyles.caption),
      );
    }

    return Column(
      children: games!.map((g) {
        return Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(AppRadii.sm),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nom de la partie (saisi par l'hôte à la création)
                    // en titre, nom de l'hôte en sous-texte — au lieu
                    // d'afficher seulement le hostName comme titre avant.
                    Text(
                      g.name,
                      style: AppTextStyles.body,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'par ${g.hostName}',
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${g.playerCount}/${g.maxPlayers} joueurs · limite ${g.scoreLimit} pts',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: isJoining ? null : () => onJoin(g.gameId),
                child: const Text('Rejoindre'),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _JoinWithCodeField extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSubmit;

  const _JoinWithCodeField({
    required this.controller,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            style: AppTextStyles.body,
            decoration: const InputDecoration(
              hintText: 'game id',
              prefixIcon: Icon(Icons.key, color: AppColors.gold, size: 18),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: isLoading ? null : onSubmit,
            child: isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  )
                : const Text('Join'),
          ),
        ),
      ],
    );
  }
}