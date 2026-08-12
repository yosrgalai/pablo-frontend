import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../data/models/card_model.dart';
import '../../../data/models/player_model.dart';
import 'card_widget.dart';

/// Siège d'un adversaire : avatar, nom, cartes cachées, indicateurs de
/// tour en cours / déconnexion / annonce "Pablo" (design system, section 4).
class OpponentSeatWidget extends StatelessWidget {
  const OpponentSeatWidget({
    super.key,
    required this.player,
    this.maxWidth = 72,
    this.maxCardWidth = 46,
    this.maxCardHeight,
    this.avatarSize = 44,
    this.spacing = 3,
    this.stackCardsVertically = false,
  });

  final PlayerModel player;

  /// Largeur totale allouée au siège (avatar + nom + cartes).
  final double maxWidth;
  final double maxCardWidth;

  /// Contrainte de hauteur pour les mini-cartes (critique en paysage,
  /// où la hauteur d'écran est la ressource la plus rare).
  final double? maxCardHeight;

  final double avatarSize;
  final double spacing;

  /// Si `true`, les cartes cachées s'empilent verticalement en éventail
  /// (chevauchement partiel) au lieu d'une rangée horizontale. Utilisé
  /// pour les adversaires placés sur les côtés de la table en paysage,
  /// où l'espace vertical est plus abondant que l'espace horizontal.
  final bool stackCardsVertically;

  static const _accentGold = Color(0xFFE0B24C);

  @override
  Widget build(BuildContext context) {
    final hiddenCount = player.hiddenCardCount;

    return SizedBox(
      width: maxWidth,
      child: Opacity(
        // Déconnexion : indicateur visuel obligatoire (doc backend §9.3),
        // jamais uniquement déduit par le nom qui grise sans autre info.
        opacity: player.isConnected ? 1.0 : 0.4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAvatar(),
            const SizedBox(height: 2),
            Text(
              player.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            if (!player.isConnected)
              const Padding(
                padding: EdgeInsets.only(top: 1),
                child: Text(
                  'Déconnecté',
                  style: TextStyle(color: Colors.white70, fontSize: 9),
                ),
              ),
            if (player.hasCalledPablo)
              const Padding(
                padding: EdgeInsets.only(top: 1),
                child: Text(
                  'Pablo !',
                  style: TextStyle(
                    color: _accentGold,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 4),
            if (hiddenCount > 0)
              Center(
                child: stackCardsVertically
                    ? _buildHiddenCardsColumn(hiddenCount)
                    : _buildHiddenCardsRow(hiddenCount),
              ),
          ],
        ),
      ),
    );
  }

  /// Largeur de carte effective : bornée par [maxCardWidth] et, si fourni,
  /// par [maxCardHeight] (ratio 2:3).
  double get _baseCardWidth => maxCardHeight == null
      ? maxCardWidth
      : math.min(maxCardWidth, maxCardHeight! / 1.5);

  /// Rangée horizontale : les `hiddenCount` cartes se partagent [maxWidth].
  /// Utilisé pour l'adversaire placé en haut au centre.
  Widget _buildHiddenCardsRow(int hiddenCount) {
    final totalSpacing = spacing * (hiddenCount - 1);
    final cardWidth =
        ((maxWidth - totalSpacing) / hiddenCount).clamp(14.0, _baseCardWidth);
    final cardHeight = cardWidth * 1.5;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < hiddenCount; i++) ...[
          if (i > 0) SizedBox(width: spacing),
          CardWidget(
            card: CardModel(id: 'opponent_${player.id}_$i', hidden: true),
            width: cardWidth,
            height: cardHeight,
          ),
        ],
      ],
    );
  }

  /// Empilement vertical en éventail, cartes COUCHÉES (rotation 90°) :
  /// chaque carte est dessinée normalement en debout (ratio 2:3) puis
  /// tournée, ce qui donne une carte plus large que haute — plus grande
  /// et plus lisible sur les côtés, où l'espace horizontal est abondant
  /// mais où on veut limiter la hauteur totale de l'empilement.
  Widget _buildHiddenCardsColumn(int hiddenCount) {
    // Dimension "longue" affichée à l'écran une fois la carte couchée
    // (= la hauteur d'une carte debout, qui devient sa largeur après
    // rotation). Bornée par la largeur allouée au siège.
    final displayedLength =
        (maxCardHeight ?? (maxCardWidth * 1.8)).clamp(40.0, maxWidth);
    final displayedThickness = displayedLength / 1.5;

    final overlap = displayedThickness * 0.42;
    final totalHeight = displayedThickness + overlap * (hiddenCount - 1);

    return SizedBox(
      width: displayedLength,
      height: totalHeight,
      child: Stack(
        children: [
          for (var i = 0; i < hiddenCount; i++)
            Positioned(
              top: overlap * i,
              child: RotatedBox(
                quarterTurns: 1,
                child: CardWidget(
                  card: CardModel(id: 'opponent_${player.id}_$i', hidden: true),
                  // CardWidget reste construit en debout (ratio 2:3) ;
                  // c'est RotatedBox qui le couche à l'écran.
                  width: displayedThickness,
                  height: displayedLength,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    final isActive = player.isCurrentTurn;
    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF1B1F3B),
        border: Border.all(
          color: isActive ? _accentGold : Colors.white24,
          width: isActive ? 3 : 1,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: _accentGold.withValues(alpha: 0.6),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          player.name.isNotEmpty ? player.name[0].toUpperCase() : '?',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: avatarSize * 0.4,
          ),
        ),
      ),
    );
  }
}
