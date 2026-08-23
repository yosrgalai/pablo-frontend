import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../bloc/lobby_bloc.dart';

/// Reproduit la modale "Create New Lobby" de la maquette El Bat7a.
///
/// ⚠️ IMPORTANT : `CreateGameDto` côté backend ne contient QUE
/// `scoreLimit` (50/100/150). Les contrôles Max Players / Public /
/// AFK Tolerance / Vote Kick / Allow Spectators n'ont aucun équivalent
/// serveur actuellement (confirmé en lisant create-game.dto.ts). Ils
/// restent affichés (cohérence visuelle avec la plateforme El Bat7a) mais
/// sont pour l'instant purement décoratifs — à activer si/quand ces
/// réglages sont ajoutés côté backend central ou Pablo.
class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final _nameController = TextEditingController();

  int _maxPlayers = 4; // décoratif, non envoyé
  int _scoreLimit = 100; // seul champ réellement envoyé
  bool _isPublic = true; // décoratif
  int _afkToleranceSeconds = 300; // décoratif
  bool _voteKick = false; // décoratif
  bool _allowSpectators = false; // décoratif
  bool _submitting = false;

  static const _afkOptions = [
    (label: '2m', seconds: 120, icon: Icons.hourglass_bottom),
    (label: '5m', seconds: 300, icon: Icons.timer_outlined),
    (label: '10m', seconds: 600, icon: Icons.hourglass_top),
  ];

  static const _scoreLimitOptions = [50, 100, 150];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() => _submitting = true);
    context.read<LobbyBloc>().add(
          LobbyCreateRequested(scoreLimit: _scoreLimit),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LobbyBloc, LobbyState>(
      listener: (context, state) {
        if (state is LobbyRoomJoined) {
          Navigator.of(context).pop(true);
        } else if (state is LobbyError) {
          setState(() => _submitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.add_circle_outline,
                          color: AppColors.gold),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Create New Lobby',
                              style: AppTextStyles.body
                                  .copyWith(fontWeight: FontWeight.w700)),
                          const Text('Pablo',
                              style: TextStyle(
                                color: AppColors.gold,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              )),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Text('Lobby Name', style: AppTextStyles.sectionLabel),
                  const SizedBox(height: 2),
                  Text('Décoratif pour l\'instant (pas stocké côté serveur).',
                      style: AppTextStyles.caption),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    style: AppTextStyles.body,
                    decoration: const InputDecoration(
                      hintText: "Final Boss Only",
                      prefixIcon:
                          Icon(Icons.drive_file_rename_outline, size: 18),
                    ),
                  ),
                  const SizedBox(height: 18),

                  Text('Max Players', style: AppTextStyles.sectionLabel),
                  const SizedBox(height: 8),
                  _ChipRow(
                    values: const [2, 3, 4, 5, 6, 7, 8],
                    selected: _maxPlayers,
                    labelBuilder: (v) => '$v',
                    onSelected: (v) => setState(() => _maxPlayers = v),
                  ),
                  const SizedBox(height: 18),

                  Text('Score Limit', style: AppTextStyles.sectionLabel),
                  const SizedBox(height: 4),
                  Text(
                    'Fin de partie dès qu’un joueur atteint ce score.',
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: 8),
                  _ChipRow(
                    values: _scoreLimitOptions,
                    selected: _scoreLimit,
                    labelBuilder: (v) => '$v pts',
                    onSelected: (v) => setState(() => _scoreLimit = v),
                  ),
                  const SizedBox(height: 18),

                  _ToggleRow(
                    icon: Icons.public,
                    title: 'Public Lobby',
                    subtitle: _isPublic
                        ? 'Anyone can see and join'
                        : 'Seuls les joueurs avec le code peuvent rejoindre',
                    value: _isPublic,
                    onChanged: (v) => setState(() => _isPublic = v),
                  ),
                  const SizedBox(height: 14),

                  Text('AFK Tolerance', style: AppTextStyles.sectionLabel),
                  const SizedBox(height: 8),
                  Row(
                    children: _afkOptions.map((opt) {
                      final isSelected =
                          _afkToleranceSeconds == opt.seconds;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _AfkOption(
                            label: opt.label,
                            icon: opt.icon,
                            selected: isSelected,
                            onTap: () => setState(
                                () => _afkToleranceSeconds = opt.seconds),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),

                  _ToggleRow(
                    icon: Icons.how_to_vote_outlined,
                    title: 'Vote Kick',
                    subtitle: _voteKick
                        ? 'Les joueurs peuvent voter pour exclure'
                        : 'Only automatic AFK quota applies',
                    value: _voteKick,
                    onChanged: (v) => setState(() => _voteKick = v),
                  ),
                  const SizedBox(height: 10),

                  _ToggleRow(
                    icon: Icons.visibility_off_outlined,
                    title: 'Allow Spectators',
                    subtitle: _allowSpectators
                        ? 'Les spectateurs peuvent regarder'
                        : 'No spectators allowed',
                    value: _allowSpectators,
                    onChanged: (v) => setState(() => _allowSpectators = v),
                  ),
                  const SizedBox(height: 22),

                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: _submitting
                              ? null
                              : () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _submitting ? null : _submit,
                          child: _submitting
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.black,
                                  ),
                                )
                              : const Text('Create Lobby'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChipRow extends StatelessWidget {
  final List<int> values;
  final int selected;
  final String Function(int) labelBuilder;
  final ValueChanged<int> onSelected;

  const _ChipRow({
    required this.values,
    required this.selected,
    required this.labelBuilder,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: values.map((v) {
        final isSelected = v == selected;
        return GestureDetector(
          onTap: () => onSelected(v),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.gold : AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(AppRadii.sm),
              border: Border.all(
                color: isSelected ? AppColors.gold : AppColors.border,
              ),
            ),
            child: Text(
              labelBuilder(v),
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: isSelected ? Colors.black : AppColors.textPrimary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _AfkOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _AfkOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.gold : AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(AppRadii.sm),
          border: Border.all(
            color: selected ? AppColors.gold : AppColors.border,
          ),
        ),
        child: Column(
          children: [
            Icon(icon,
                size: 16,
                color: selected ? Colors.black : AppColors.textSecondary),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.black : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadii.sm),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.gold),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.body),
                Text(subtitle, style: AppTextStyles.caption),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.gold,
          ),
        ],
      ),
    );
  }
}