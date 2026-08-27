import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/player_model.dart';

class PlayerListItem extends StatelessWidget {
  final PlayerModel player;

  const PlayerListItem({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadii.sm),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.gold.withValues(alpha: 0.15),
            child: Text(
              player.name.isNotEmpty ? player.name[0].toUpperCase() : '?',
              style: const TextStyle(
                color: AppColors.gold,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    player.name,
                    style: AppTextStyles.body,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (player.isHost) ...[
                  const SizedBox(width: 6),
                  const Icon(Icons.emoji_events,
                      size: 16, color: AppColors.gold),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            flex: 2,
            child: _ConnectionBadge(isConnected: player.isConnected),
          ),
        ],
      ),
    );
  }
}

/// Pas de notion "prêt" côté backend — on reflète l'état réel :
/// isConnected passe à true uniquement une fois que le joueur a
/// effectivement rejoint le socket de la room (join_game).
///
/// `LayoutBuilder` : dégrade en icône seule (sans le mot "Connecté" /
/// "Hors ligne") si l'espace qui lui est réellement accordé est trop
/// étroit pour tenir le texte — évite l'overflow observé quand le nom du
/// joueur + ce badge ne tiennent plus tous les deux sur la largeur de la
/// carte (petits écrans, ou redimensionnement de fenêtre en web).
class _ConnectionBadge extends StatelessWidget {
  final bool isConnected;
  const _ConnectionBadge({required this.isConnected});

  static const double _minWidthForLabel = 78;

  @override
  Widget build(BuildContext context) {
    final color = isConnected ? AppColors.success : AppColors.textDisabled;
    final label = isConnected ? 'Connecté' : 'Hors ligne';

    return LayoutBuilder(
      builder: (context, constraints) {
        final showLabel = constraints.maxWidth >= _minWidthForLabel;
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: showLabel ? 10 : 6,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isConnected ? Icons.wifi : Icons.wifi_off,
                size: 13,
                color: color,
              ),
              if (showLabel) ...[
                const SizedBox(width: 5),
                Text(label, style: AppTextStyles.caption.copyWith(color: color)),
              ],
            ],
          ),
        );
      },
    );
  }
}