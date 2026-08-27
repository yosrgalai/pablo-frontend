import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../data/models/card_model.dart';
import 'card_widget.dart';

/// Un vol de carte en cours entre deux points de l'écran.
class _Flight {
  _Flight({
    required this.id,
    required this.controller,
    required this.from,
    required this.to,
    this.revealCard,
  });

  final int id;
  final AnimationController controller;
  final Offset from;
  final Offset to;

  /// Si fourni, la carte se retourne pour révéler cette valeur dans la
  /// seconde moitié du vol. `null` = reste cachée du départ à l'arrivée
  /// (ex: pouvoir 9, qui ne révèle jamais rien à personne).
  final CardModel? revealCard;
}

/// Superpose des animations de cartes "volantes" par-dessus [child].
///
/// Remplace les labels textuels d'action ("échange une carte"...) : c'est
/// la carte elle-même qui se déplace visuellement d'un point à un autre
/// de la table (main d'un joueur, pioche, défausse), plutôt qu'un mot.
///
/// Utilisation : détenir une `GlobalKey<CardFlightLayerState>`, l'assigner
/// à ce widget, puis appeler `.currentState?.fly(...)` depuis n'importe
/// où (typiquement `GameTableScreen`, en réaction à un event serveur).
class CardFlightLayer extends StatefulWidget {
  const CardFlightLayer({super.key, required this.child});

  final Widget child;

  @override
  State<CardFlightLayer> createState() => CardFlightLayerState();
}

class CardFlightLayerState extends State<CardFlightLayer>
    with TickerProviderStateMixin {
  final List<_Flight> _flights = [];
  int _nextId = 0;

  static const double _flightCardWidth = 44;
  static const double _flightCardHeight = 66;

  /// Centre GLOBAL du widget porté par [key]. `null` si pas encore monté
  /// (première frame, layout pas stabilisé...) — dans ce cas l'appelant
  /// doit juste sauter l'animation plutôt que planter dessus : c'est un
  /// effet visuel, jamais une source de vérité pour l'état du jeu.
  Offset? _globalCenterOf(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject();
    if (box is! RenderBox || !box.hasSize || !box.attached) return null;
    final topLeft = box.localToGlobal(Offset.zero);
    return topLeft + Offset(box.size.width / 2, box.size.height / 2);
  }

  Offset? _toLocal(Offset global) {
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.attached) return null;
    return box.globalToLocal(global);
  }

  /// Lance une carte de [fromKey] vers [toKey].
  ///
  /// - [revealCard] fourni -> la carte se retourne pour la montrer à
  ///   mi-vol (échange, défausse : on apprend la valeur en la voyant
  ///   arriver, jamais avant).
  /// - [revealCard] omis -> reste cachée tout le vol (pouvoir 9,
  ///   pénalité : personne ne doit voir cette carte).
  /// - [onLanded] appelé à l'atterrissage : c'est le bon moment pour
  ///   mettre à jour l'état réel (défausse, taille de main...) en
  ///   synchro avec ce que l'œil vient de voir.
  ///
  /// Si l'une des deux positions n'est pas mesurable, saute directement
  /// à [onLanded] sans animation plutôt que de planter ou de bloquer la
  /// mise à jour d'état qui en dépend.
  void fly({
    required GlobalKey fromKey,
    required GlobalKey toKey,
    CardModel? revealCard,
    Duration duration = const Duration(milliseconds: 550),
    VoidCallback? onLanded,
  }) {
    final fromGlobal = _globalCenterOf(fromKey);
    final toGlobal = _globalCenterOf(toKey);
    final from = fromGlobal == null ? null : _toLocal(fromGlobal);
    final to = toGlobal == null ? null : _toLocal(toGlobal);
    if (from == null || to == null) {
      onLanded?.call();
      return;
    }

    final controller = AnimationController(vsync: this, duration: duration);
    final id = _nextId++;
    final flight = _Flight(
      id: id,
      controller: controller,
      from: from,
      to: to,
      revealCard: revealCard,
    );

    setState(() => _flights.add(flight));

    controller.forward().whenComplete(() {
      if (mounted) setState(() => _flights.removeWhere((f) => f.id == id));
      controller.dispose();
      onLanded?.call();
    });
  }

  @override
  void dispose() {
    for (final f in _flights) {
      f.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        widget.child,
        for (final flight in _flights) _buildFlight(flight),
      ],
    );
  }

  Widget _buildFlight(_Flight flight) {
    return AnimatedBuilder(
      animation: flight.controller,
      builder: (context, _) {
        final t = Curves.easeInOut.transform(flight.controller.value);
        final pos = Offset.lerp(flight.from, flight.to, t)!;

        // Petit arc vertical : un mouvement en cloche lit beaucoup mieux
        // à l'œil qu'une translation strictement en ligne droite.
        final arc = -28.0 * 4 * t * (1 - t);
        // Léger effet d'échelle au sommet du vol, purement cosmétique.
        final scale = 1.0 + 0.1 * math.sin(math.pi * t);

        // La carte se retourne dans la 2e moitié du vol (marge avant la
        // fin pour laisser le flip interne de CardWidget, ~300ms, le
        // temps de se terminer visuellement avant que le vol s'achève).
        final showRevealed = flight.revealCard != null && t > 0.4;
        final displayedCard = showRevealed
            ? flight.revealCard!
            : const CardModel(id: 'flight', hidden: true);

        return Positioned(
          left: pos.dx - _flightCardWidth / 2,
          top: pos.dy + arc - _flightCardHeight / 2,
          child: IgnorePointer(
            child: Transform.scale(
              scale: scale,
              child: CardWidget(
                card: displayedCard,
                width: _flightCardWidth,
                height: _flightCardHeight,
              ),
            ),
          ),
        );
      },
    );
  }
}