import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../bloc/lobby_bloc.dart';

/// Modale "Create New Lobby" — version simplifiée : seuls Lobby Name,
/// Max Players (2 à 4) et Score Limit restent affichés. Les réglages
/// Public/AFK/Vote Kick/Spectateurs ont été retirés (demande produit) —
/// de toute façon ils n'étaient que décoratifs, `CreateGameDto` côté
/// backend n'accepte que `scoreLimit`.
///
/// ⚠️ `maxPlayers` reste lui aussi décoratif pour l'instant : le backend
/// (`GameService.joinGameAsPlayer`) plafonne actuellement à 8 joueurs en
/// dur, pas selon la valeur choisie ici. Pour que "4 joueurs max" soit
/// réellement appliqué, il faut changer cette limite côté backend (à
/// faire avec ta binôme).
class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final _nameController = TextEditingController();

  int _maxPlayers = 4; // décoratif, non envoyé au backend
  int _scoreLimit = 100;
  bool _submitting = false;

  static const _maxPlayersOptions = [2, 3, 4];
  static const _scoreLimitOptions = [50, 100, 150];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
  setState(() => _submitting = true);
  context.read<LobbyBloc>().add(
        LobbyCreateRequested(
          scoreLimit: _scoreLimit,
          name: _nameController.text.trim().isEmpty
              ? 'Partie sans nom'
              : _nameController.text.trim(),
        ),
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
                          Text('Créer une partie',
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

                  Text('Titre de la partie', style: AppTextStyles.sectionLabel),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    style: AppTextStyles.body,
                    decoration: const InputDecoration(
                      hintText: "Host seulement ",
                      prefixIcon:
                          Icon(Icons.drive_file_rename_outline, size: 18),
                    ),
                  ),
                  const SizedBox(height: 18),

                  Text('Nombre de joueurs max', style: AppTextStyles.sectionLabel),
                  const SizedBox(height: 8),
                  _ChipRow(
                    values: _maxPlayersOptions,
                    selected: _maxPlayers,
                    labelBuilder: (v) => '$v',
                    onSelected: (v) => setState(() => _maxPlayers = v),
                  ),
                  const SizedBox(height: 18),

                  Text('Score limite', style: AppTextStyles.sectionLabel),
                  const SizedBox(height: 4),
                  Text(
                    'Fin de partie dès qu\'un joueur atteint ce score.',
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: 8),
                  _ChipRow(
                    values: _scoreLimitOptions,
                    selected: _scoreLimit,
                    labelBuilder: (v) => '$v pts',
                    onSelected: (v) => setState(() => _scoreLimit = v),
                  ),
                  const SizedBox(height: 22),

                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: _submitting
                              ? null
                              : () => Navigator.of(context).pop(false),
                          child: const Text('Annuler'),
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
                              : const Text('Créer la partie'),
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