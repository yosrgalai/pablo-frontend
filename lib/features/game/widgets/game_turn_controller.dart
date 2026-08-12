import 'dart:async';

import 'package:flutter/material.dart';

import '../../../data/models/card_model.dart';
import '../../../data/models/player_model.dart';
import '../../../data/models/round_model.dart';
import 'draw_decision_sheet.dart';
import 'game_table_layout.dart';

enum _TurnPhase {
  /// INITIAL_PEEK : le joueur sélectionne 2 cartes de sa main à regarder.
  awaitingPeekSelection,

  /// ChooseInitialPeekDto envoyé, en attente de la réponse serveur.
  confirmingPeek,

  /// Les 2 cartes choisies sont révélées, compte à rebours avant de se
  /// recacher automatiquement.
  revealingPeek,

  /// Rien en attente : le joueur peut piocher ou tenter une paire (si son tour).
  idle,

  /// Carte piochée reçue, la feuille de décision est affichée.
  awaitingDecision,

  /// Le joueur a choisi "échanger" : on attend qu'il tape une carte de sa
  /// main pour désigner la position à remplacer.
  awaitingSwapTarget,

  /// Mode "défausser une paire" (Option B) : le joueur sélectionne 2 cartes.
  awaitingPairSelection,

  /// PairAttemptDto envoyé, en attente de la réponse serveur.
  submittingPair,
}

enum _PairFeedback { none, success, failure }

/// Orchestre TOUTES les interactions du joueur local sur le plateau :
/// INITIAL_PEEK (sélection de 2 cartes), puis piocher/échanger/défausser,
/// puis défausser une paire (Option B).
///
/// Reste sur le MÊME plateau (`GameTableLayout`) du début à la fin — pas
/// d'écran séparé pour INITIAL_PEEK, juste un mode de sélection différent
/// sur la main, exactement comme le mode paire.
///
/// Ce widget ne connaît RIEN du socket : les callbacks sont ce que l'écran
/// parent (plus tard, le `GameBloc`) devra brancher aux vrais events.
class GameTurnController extends StatefulWidget {
  const GameTurnController({
    super.key,
    required this.localPlayer,
    required this.opponents,
    required this.round,
    required this.needsInitialPeek,
    required this.onConfirmPeek,
    required this.onPeekComplete,
    required this.onDrawCard,
    required this.onSwapCard,
    required this.onDiscardCard,
    required this.onPairAttempt,
    this.peekRevealDuration = const Duration(seconds: 5),
  });

  final PlayerModel localPlayer;
  final List<PlayerModel> opponents;
  final RoundModel round;

  /// `true` tant que le joueur n'a pas encore fait son INITIAL_PEEK.
  final bool needsInitialPeek;

  /// Émet `ChooseInitialPeekDto` (positions choisies). C'est à l'appelant
  /// de mettre à jour `localPlayer.hand` avec les 2 cartes révélées
  /// (le contrôleur ne stocke aucune donnée de carte lui-même).
  final Future<void> Function(List<int> positions) onConfirmPeek;

  /// Appelé une fois la fenêtre de révélation terminée -> l'appelant doit
  /// recacher les 2 cartes dans `localPlayer.hand`.
  final VoidCallback onPeekComplete;

  final Duration peekRevealDuration;

  /// Doit émettre `turn:draw` (DrawCardDto) et retourner la carte reçue.
  final Future<CardModel> Function() onDrawCard;

  /// Doit émettre `turn:swap` (SwapCardDto).
  final void Function(CardModel drawnCard, int handPosition) onSwapCard;

  /// Doit émettre `turn:discard` (DiscardCardDto).
  final void Function(CardModel drawnCard, {required bool usePower}) onDiscardCard;

  /// Doit émettre `turn:discard_pair` (PairAttemptDto) et retourner `true`
  /// en cas de succès.
  final Future<bool> Function(int firstPosition, int secondPosition) onPairAttempt;

  @override
  State<GameTurnController> createState() => _GameTurnControllerState();
}

class _GameTurnControllerState extends State<GameTurnController> {
  late _TurnPhase _phase;
  CardModel? _drawnCard;
  bool _isDrawing = false;

  final Set<int> _peekSelection = {};
  int _peekSecondsLeft = 0;
  Timer? _peekTimer;

  final Set<int> _pairSelection = {};
  _PairFeedback _pairFeedback = _PairFeedback.none;
  Timer? _pairFeedbackTimer;

  bool get _isMyTurn => widget.localPlayer.isCurrentTurn;
  bool get _canAttemptPair => widget.localPlayer.hand.length >= 4;

  @override
  void initState() {
    super.initState();
    _phase = widget.needsInitialPeek ? _TurnPhase.awaitingPeekSelection : _TurnPhase.idle;
  }

  @override
  void dispose() {
    _peekTimer?.cancel();
    _pairFeedbackTimer?.cancel();
    super.dispose();
  }

  // --- INITIAL_PEEK ---

  void _togglePeekPosition(int position) {
    setState(() {
      if (_peekSelection.contains(position)) {
        _peekSelection.remove(position);
      } else if (_peekSelection.length < 2) {
        _peekSelection.add(position);
      }
    });
  }

  Future<void> _confirmPeekSelection() async {
    if (_peekSelection.length != 2) return;
    final positions = _peekSelection.toList();

    setState(() => _phase = _TurnPhase.confirmingPeek);
    await widget.onConfirmPeek(positions);
    if (!mounted) return;

    setState(() {
      _phase = _TurnPhase.revealingPeek;
      _peekSecondsLeft = widget.peekRevealDuration.inSeconds;
      _peekSelection.clear();
    });

    _peekTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() => _peekSecondsLeft--);
      if (_peekSecondsLeft <= 0) {
        timer.cancel();
        widget.onPeekComplete();
        setState(() => _phase = _TurnPhase.idle);
      }
    });
  }

  // --- Piocher / échanger / défausser ---

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
      isDismissible: false,
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

  // --- Défausser une paire ---

  void _enterPairSelectionMode() {
    if (_phase != _TurnPhase.idle || !_isMyTurn || !_canAttemptPair) return;
    setState(() {
      _phase = _TurnPhase.awaitingPairSelection;
      _pairSelection.clear();
    });
  }

  void _cancelPairSelection() {
    setState(() {
      _phase = _TurnPhase.idle;
      _pairSelection.clear();
    });
  }

  void _togglePairPosition(int position) {
    setState(() {
      if (_pairSelection.contains(position)) {
        _pairSelection.remove(position);
      } else if (_pairSelection.length < 2) {
        _pairSelection.add(position);
      }
    });
  }

  Future<void> _confirmPairAttempt() async {
    if (_pairSelection.length != 2) return;
    final positions = _pairSelection.toList();

    setState(() => _phase = _TurnPhase.submittingPair);
    final success = await widget.onPairAttempt(positions[0], positions[1]);
    if (!mounted) return;

    setState(() {
      _pairFeedback = success ? _PairFeedback.success : _PairFeedback.failure;
      _pairSelection.clear();
      _phase = _TurnPhase.idle;
    });

    _pairFeedbackTimer?.cancel();
    _pairFeedbackTimer = Timer(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _pairFeedback = _PairFeedback.none);
    });
  }

  // --- Tap sur une carte de la main : le sens dépend de la phase ---

  void _handleHandCardTap(int position) {
    switch (_phase) {
      case _TurnPhase.awaitingPeekSelection:
        _togglePeekPosition(position);
      case _TurnPhase.awaitingSwapTarget:
        if (_drawnCard != null) {
          widget.onSwapCard(_drawnCard!, position);
          setState(() {
            _drawnCard = null;
            _phase = _TurnPhase.idle;
          });
        }
      case _TurnPhase.awaitingPairSelection:
        _togglePairPosition(position);
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPeekSelecting = _phase == _TurnPhase.awaitingPeekSelection;
    final isPeekConfirming = _phase == _TurnPhase.confirmingPeek;
    final isPeekRevealing = _phase == _TurnPhase.revealingPeek;
    final isSwapMode = _phase == _TurnPhase.awaitingSwapTarget;
    final isPairMode = _phase == _TurnPhase.awaitingPairSelection;
    final isSubmittingPair = _phase == _TurnPhase.submittingPair;

    final handInteractive = isPeekSelecting || isSwapMode || isPairMode;
    final drawInteractive = _isMyTurn && _phase == _TurnPhase.idle && !_isDrawing;

    final disabledPositions = (!_isMyTurn && _phase == _TurnPhase.idle)
        ? Set<int>.from(List.generate(widget.localPlayer.hand.length, (i) => i))
        : <int>{};

    final selectedPositions = isPeekSelecting ? _peekSelection : _pairSelection;

    return Stack(
      children: [
        GameTableLayout(
          localPlayer: widget.localPlayer,
          opponents: widget.opponents,
          round: widget.round,
          onDrawTap: drawInteractive ? _handleDrawTap : null,
          onHandCardTap: handInteractive ? _handleHandCardTap : null,
          disabledHandPositions: disabledPositions,
          selectedHandPositions: selectedPositions,
        ),

        if (isPeekSelecting) _buildPeekSelectionControls(),
        if (isPeekRevealing) _buildBanner('Mémorisez-les ! Elles se cachent dans $_peekSecondsLeft s'),

        if (isSwapMode) _buildBanner("Touchez une carte de votre main pour l'échanger"),

        if (isPairMode) _buildPairControls(),

        if (_isMyTurn && _phase == _TurnPhase.idle && _canAttemptPair && !_isDrawing)
          _buildPairEntryButton(),

        if (_isDrawing || isSubmittingPair || isPeekConfirming) const _LoadingOverlay(),

        if (_pairFeedback != _PairFeedback.none) _buildPairFeedbackFlash(),
      ],
    );
  }

  Widget _buildBanner(String text) {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 110,
      child: _Banner(text: text),
    );
  }

  Widget _buildPeekSelectionControls() {
    final canConfirm = _peekSelection.length == 2;
    final text = _peekSelection.isEmpty
        ? 'Choisissez 2 cartes de votre main à regarder'
        : _peekSelection.length == 1
            ? 'Choisissez une 2e carte'
            : 'Prêt ? Confirmez votre choix';

    return Positioned(
      left: 16,
      right: 16,
      bottom: 110,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Banner(text: text),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE0B24C),
              foregroundColor: Colors.black,
              disabledBackgroundColor: Colors.white24,
            ),
            onPressed: canConfirm ? _confirmPeekSelection : null,
            child: const Text('Confirmer mon choix'),
          ),
        ],
      ),
    );
  }

  Widget _buildPairEntryButton() {
    return Positioned(
      right: 16,
      bottom: 110,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE0B24C),
          foregroundColor: Colors.black,
        ),
        onPressed: _enterPairSelectionMode,
        child: const Text('Défausser une paire'),
      ),
    );
  }

  Widget _buildPairControls() {
    final canConfirm = _pairSelection.length == 2;
    return Positioned(
      left: 16,
      right: 16,
      bottom: 110,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Banner(
            text: _pairSelection.isEmpty
                ? 'Touchez 2 cartes de même valeur'
                : _pairSelection.length == 1
                    ? 'Touchez une 2e carte'
                    : 'Prêt à tenter la paire',
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white54),
                ),
                onPressed: _cancelPairSelection,
                child: const Text('Annuler'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE0B24C),
                  foregroundColor: Colors.black,
                  disabledBackgroundColor: Colors.white24,
                ),
                onPressed: canConfirm ? _confirmPairAttempt : null,
                child: const Text('Tenter la paire'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPairFeedbackFlash() {
    final isSuccess = _pairFeedback == _PairFeedback.success;
    return Positioned.fill(
      child: IgnorePointer(
        child: Container(
          color: (isSuccess ? const Color(0xFF3FA76B) : const Color(0xFFD64545)).withValues(alpha: 0.18),
          child: Center(
            child: Icon(
              isSuccess ? Icons.check_circle : Icons.cancel,
              color: isSuccess ? const Color(0xFF3FA76B) : const Color(0xFFD64545),
              size: 72,
            ),
          ),
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
    );
  }
}

class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
      child: IgnorePointer(
        child: Center(child: CircularProgressIndicator(color: Color(0xFFE0B24C))),
      ),
    );
  }
}