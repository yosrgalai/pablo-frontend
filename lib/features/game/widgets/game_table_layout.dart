import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../data/models/player_model.dart';
import '../../../data/models/round_model.dart';
import 'discard_pile_widget.dart';
import 'draw_pile_widget.dart';
import 'opponent_seat_widget.dart';
import 'player_hand_widget.dart';

/// Assemble le plateau complet : adversaires disposés en arc en haut,
/// pioche + défausse au centre, main du joueur local en bas.
///
/// Toutes les tailles sont calculées à partir de la HAUTEUR disponible,
/// pas seulement la largeur : en paysage, la hauteur d'écran est la
/// ressource la plus rare (~350-430dp), alors que la largeur est
/// abondante.
///
/// Les adversaires placés sur les côtés (angle > [_seatSideThresholdDeg])
/// affichent leurs cartes cachées empilées verticalement en éventail
/// plutôt qu'en rangée horizontale : ça libère de l'espace latéral et
/// permet des cartes plus grandes, l'espace vertical étant abondant sur
/// les côtés en paysage.
class GameTableLayout extends StatelessWidget {
  const GameTableLayout({
    super.key,
    required this.localPlayer,
    required this.opponents,
    required this.round,
    this.onDrawTap,
    this.onDiscardTap,
    this.onHandCardTap,
    this.selectedHandPositions = const {},
    this.disabledHandPositions = const {},
  });

  final PlayerModel localPlayer;
  final List<PlayerModel> opponents;
  final RoundModel round;
  final VoidCallback? onDrawTap;
  final VoidCallback? onDiscardTap;
  final void Function(int position)? onHandCardTap;
  final Set<int> selectedHandPositions;
  final Set<int> disabledHandPositions;

  /// Au-delà de cet angle (par rapport à la verticale du centre), un
  /// adversaire est considéré "sur le côté" -> cartes empilées verticalement.
  static const double _seatSideThresholdDeg = 55;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final isLandscape = width > height;

        // --- Budget vertical : combien de hauteur pour chaque zone ---
        final opponentAreaHeight =
            (height * (isLandscape ? 0.34 : 0.24)).clamp(80.0, 150.0);
        final handAreaHeight =
            (height * (isLandscape ? 0.38 : 0.26)).clamp(90.0, 170.0);

        // --- Tailles dérivées de ce budget (agrandies) ---
        final avatarSize = (opponentAreaHeight * 0.34).clamp(30.0, 50.0);
        final opponentCardHeight =
            (opponentAreaHeight * 0.55).clamp(44.0, 84.0);
        final opponentSeatWidthTop =
            (opponentCardHeight / 1.5 * 3 + 8).clamp(60.0, 96.0);
        // Côtés : le siège doit accueillir des cartes COUCHÉES (rotation
        // 90°), donc leur largeur affichée = opponentCardHeight (la
        // dimension "longue"), pas cardHeight/1.5 (dimension courte,
        // pertinente seulement pour les cartes debout d'en haut).
        final opponentSeatWidthSide =
            (opponentCardHeight + 20).clamp(70.0, 120.0);

        final handCardHeight = (handAreaHeight * 0.8).clamp(72.0, 120.0);

        final pileWidth = (height * 0.18).clamp(46.0, 70.0);

        // --- Disposition des adversaires ---
        final arcSpanDeg = isLandscape ? 220.0 : 140.0;
        final arcRadiusX = (width / 2) * (isLandscape ? 0.85 : 0.8);
        final arcRadiusY = (opponentAreaHeight * 0.55).clamp(35.0, 90.0);
        final arcTop = opponentAreaHeight * 0.6;

        return Stack(
          children: [
            ..._buildOpponentsArc(
              width: width,
              arcSpanDeg: arcSpanDeg,
              arcRadiusX: arcRadiusX,
              arcRadiusY: arcRadiusY,
              arcTop: arcTop,
              seatWidthTop: opponentSeatWidthTop,
              seatWidthSide: opponentSeatWidthSide,
              avatarSize: avatarSize,
              cardHeight: opponentCardHeight,
            ),

            // --- Centre de la table : pioche + défausse ---
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DrawPileWidget(count: round.drawPileCount, onTap: onDrawTap, width: pileWidth),
                  SizedBox(width: pileWidth * 0.4),
                  DiscardPileWidget(topCard: round.discardTop, onTap: onDiscardTap, width: pileWidth),
                ],
              ),
            ),

            // --- Main du joueur local, ancrée en bas ---
            Positioned(
              left: 16,
              right: 16,
              bottom: isLandscape ? 8 : 24,
              child: PlayerHandWidget(
                hand: localPlayer.hand,
                selectedPositions: selectedHandPositions,
                disabledPositions: disabledHandPositions,
                onCardTap: onHandCardTap,
                maxCardHeight: handCardHeight,
              ),
            ),
          ],
        );
      },
    );
  }

  /// Répartit les sièges adverses sur un arc de [arcSpanDeg]° au-dessus
  /// du centre de la table. Chaque siège reçoit `stackCardsVertically:
  /// true` si son angle dépasse [_seatSideThresholdDeg] (placé sur le
  /// côté plutôt qu'en haut au centre).
  List<Widget> _buildOpponentsArc({
    required double width,
    required double arcSpanDeg,
    required double arcRadiusX,
    required double arcRadiusY,
    required double arcTop,
    required double seatWidthTop,
    required double seatWidthSide,
    required double avatarSize,
    required double cardHeight,
  }) {
    final count = opponents.length;
    if (count == 0) return [];

    final centerX = width / 2;
    final halfSpan = arcSpanDeg / 2;

    return [
      for (var i = 0; i < count; i++)
        Builder(
          builder: (context) {
            final t = count == 1 ? 0.5 : i / (count - 1);
            final angleDeg = -halfSpan + (arcSpanDeg * t);
            final angle = angleDeg * math.pi / 180;
            final isSide = angleDeg.abs() > _seatSideThresholdDeg;
            final seatWidth = isSide ? seatWidthSide : seatWidthTop;

            final dx = centerX + arcRadiusX * math.sin(angle) - (seatWidth / 2);
            final dy = arcTop - arcRadiusY * math.cos(angle) + arcRadiusY;

            return Positioned(
              left: dx,
              top: dy,
              width: seatWidth,
              child: OpponentSeatWidget(
                player: opponents[i],
                maxWidth: seatWidth,
                avatarSize: avatarSize,
                maxCardHeight: cardHeight,
                stackCardsVertically: isSide,
              ),
            );
          },
        ),
    ];
  }
}