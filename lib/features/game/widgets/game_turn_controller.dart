import 'package:flutter/material.dart';

import '../../../data/models/card_model.dart';
import '../../../data/models/player_model.dart';
import '../../../data/models/round_model.dart';
import 'draw_decision_sheet.dart';
import 'game_table_layout.dart';

enum _TurnPhase {
  /// Rien en attente : le joueur peut piocher (si c'est son tour).
  idle,

  /// Carte piochée reçue, la feuille de décision est affichée.
  awaitingDecision,

  /// Le joueur a choisi "échanger" : on attend qu'il tape une carte de sa
  /// main pour désigner la position à remplacer.
  awaitingSwapTarget,
}

/// Orchestre les interactions du tour local : piocher, puis décider
/// (échanger avec une carte de la main OU défausser directement, avec ou
/// sans activation du pouvoir).
///
/// Ce widget ne connaît RIEN du socket : les 3 callbacks (`onDrawCard`,
/// `onSwapCard`, `onDiscardCard`) sont ce que l'écran parent (plus tard,
/// le `GameBloc`) devra brancher aux vrais events (`DrawCardDto`,
/// `SwapCardDto`, `DiscardCardDto`). Ici, on ne gère que l'état "carte
/// piochée en attente de décision", purement côté UI.
class GameTurnController extends StatefulWidget {
  const GameTurnController({
    super.key,
    required this.localPlayer,
    required this.opponents,
    required this.round,
    required this.onDrawCard,
    required this.onSwapCard,
    required this.onDiscardCard,
  });

  final PlayerModel localPlayer;
  final List<PlayerModel> opponents;
  final RoundModel round;

  /// Doit émettre `turn:draw` (DrawCardDto) et retourner la carte reçue
  /// en retour. `async` car ça implique un aller-retour réseau.
  final Future<CardModel> Function() onDrawCard;

  /// Doit émettre `turn:swap` (SwapCardDto).
  final void Function(CardModel drawnCard, int handPosition) onSwapCard;

  /// Doit émettre `turn:discard` (DiscardCardDto). `usePower` reflète le
  /// choix explicite du joueur (jamais automatique, doc §4).
  final void Function(CardModel drawnCard, {required bool usePower}) onDiscardCard;

  @override
  State<GameTurnController> createState() => _GameTurnControllerState();
}

class _GameTurnControllerState extends State<GameTurnController> {
  _TurnPhase _phase = _TurnPhase.idle;
  CardModel? _drawnCard;
  bool _isDrawing = false;

  bool get _isMyTurn => widget.localPlayer.isCurrentTurn;

  Future<void> _handleDrawTap() async {
    if (_isDrawing || _phase != _TurnPhase.idle) return;
    setState(() => _isDrawing = true);

    final card = await widget.onDrawCard();
    if (!mounted) return;

    setState(() {
      _isDrawing = false;
      _drawnCard = card;
      _phase = _TurnPhase.awaitingDecision;
    });

    _showDecisionSheet(card);
  }

  void _showDecisionSheet(CardModel card) {
    showModalBottomSheet<void>(
      context: context,
      isDismissible: false, // décision obligatoire, pas de fermeture accidentelle
      enableDrag: false,
      backgroundColor: const Color(0xFF0B6B4F),
      builder: (sheetContext) => DrawDecisionSheet(
        drawnCard: card,
        onChooseSwap: () {
          Navigator.of(sheetContext).pop();
          setState(() => _phase = _TurnPhase.awaitingSwapTarget);
        },
        onChooseDiscard: (usePower) {
          Navigator.of(sheetContext).pop();
          widget.onDiscardCard(card, usePower: usePower);
          setState(() {
            _drawnCard = null;
            _phase = _TurnPhase.idle;
          });
        },
      ),
    );
  }

  void _handleHandCardTap(int position) {
    if (_phase != _TurnPhase.awaitingSwapTarget || _drawnCard == null) return;

    widget.onSwapCard(_drawnCard!, position);
    setState(() {
      _drawnCard = null;
      _phase = _TurnPhase.idle;
    });
  }

  @override
  Widget build(BuildContext context) {
    final handInteractive = _phase == _TurnPhase.awaitingSwapTarget;
    final drawInteractive = _isMyTurn && _phase == _TurnPhase.idle && !_isDrawing;

    // Hors tour : toute la main passe en état "disabled", feedback visuel
    // clair plutôt qu'une simple absence de réaction au tap.
    final disabledPositions = !_isMyTurn
        ? Set<int>.from(List.generate(widget.localPlayer.hand.length, (i) => i))
        : <int>{};

    return Stack(
      children: [
        GameTableLayout(
          localPlayer: widget.localPlayer,
          opponents: widget.opponents,
          round: widget.round,
          onDrawTap: drawInteractive ? _handleDrawTap : null,
          onHandCardTap: handInteractive ? _handleHandCardTap : null,
          disabledHandPositions: disabledPositions,
        ),
        if (_phase == _TurnPhase.awaitingSwapTarget) _buildSwapBanner(),
        if (_isDrawing) const _DrawingOverlay(),
      ],
    );
  }

  Widget _buildSwapBanner() {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 110,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.55),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          "Touchez une carte de votre main pour l'échanger",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 13),
        ),
      ),
    );
  }
}

class _DrawingOverlay extends StatelessWidget {
  const _DrawingOverlay();

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
      child: IgnorePointer(
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFFE0B24C)),
        ),
      ),
    );
  }
}