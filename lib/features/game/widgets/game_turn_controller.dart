import 'dart:async';

import 'package:flutter/material.dart';

import '../../../data/models/card_model.dart';
import '../../../data/models/player_model.dart';
import '../../../data/models/round_model.dart';
import 'draw_decision_sheet.dart';
import 'game_table_layout.dart';
import 'power_target_dialogs.dart';

enum _TurnPhase {
  awaitingPeekSelection,
  confirmingPeek,
  revealingPeek,
  idle,
  awaitingDecision,
  awaitingSwapTarget,
  awaitingPairSelection,
  submittingPair,

  /// Pouvoir 7 : sélection d'une de ses propres cartes cachées.
  awaitingPower7Target,

  /// Pouvoir 8 : dialogs en cours (choix adversaire puis position).
  awaitingPower8Target,

  /// Pouvoir 9 : sélection de sa propre carte (1re étape).
  awaitingPower9Source,

  /// Pouvoir 9 : dialogs en cours pour désigner la carte adverse.
  awaitingPower9Target,
}

enum _PairFeedback { none, success, failure }

/// Durée avant qu'un pouvoir non résolu soit annulé automatiquement
/// (doc §5 : "prévoir un timeout pour éviter de bloquer la partie").
const _powerTargetTimeout = Duration(seconds: 15);

/// Orchestre TOUTES les interactions du joueur local sur le plateau :
/// INITIAL_PEEK, piocher/échanger/défausser, défausser une paire, et
/// activer les pouvoirs (7 : regarder sa carte, 8 : espionner un
/// adversaire, 9 : échange aveugle avec un adversaire).
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
    required this.onPowerSelfPeek,
    required this.onPowerSpy,
    required this.onPowerBlindSwap,
    this.peekRevealDuration = const Duration(seconds: 5),
  });

  final PlayerModel localPlayer;
  final List<PlayerModel> opponents;
  final RoundModel round;

  final bool needsInitialPeek;
  final Future<void> Function(List<int> positions) onConfirmPeek;
  final VoidCallback onPeekComplete;
  final Duration peekRevealDuration;

  final Future<CardModel> Function() onDrawCard;
  final void Function(CardModel drawnCard, int handPosition) onSwapCard;
  final void Function(CardModel drawnCard, {required bool usePower}) onDiscardCard;
  final Future<bool> Function(int firstPosition, int secondPosition) onPairAttempt;

  /// Pouvoir 7 : émet PowerTargetDto (powerRank=7, targetPlayerId=soi-même,
  /// targetPosition=ownPosition) et retourne la carte révélée.
  final Future<CardModel> Function(int ownPosition) onPowerSelfPeek;

  /// Pouvoir 8 : émet PowerTargetDto (powerRank=8) et retourne la carte
  /// révélée de l'adversaire ciblé.
  final Future<CardModel> Function(String opponentId, int opponentPosition) onPowerSpy;

  /// Pouvoir 9 : émet PowerTargetDto (powerRank=9) — échange sans révéler
  /// aucune des deux cartes.
  final Future<void> Function(int ownPosition, String opponentId, int opponentPosition)
      onPowerBlindSwap;

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

  /// Position de sa propre carte choisie pour le pouvoir 9, en attendant
  /// le choix de la carte adverse via les dialogs.
  int? _power9SourcePosition;

  Timer? _powerTimeoutTimer;

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
    _powerTimeoutTimer?.cancel();
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
          setState(() => _drawnCard = null);
          _afterDiscard(card, usePower: usePower);
        },
      ),
    );
  }

  /// Après une défausse directe : si le joueur a choisi d'activer le
  /// pouvoir, on entre dans le sous-état correspondant plutôt que de
  /// revenir directement à `idle`.
  void _afterDiscard(CardModel card, {required bool usePower}) {
    if (!usePower || !card.hasPower) {
      setState(() => _phase = _TurnPhase.idle);
      return;
    }

    switch (card.rank) {
      case '7':
        setState(() => _phase = _TurnPhase.awaitingPower7Target);
        _startPowerTimeout();
      case '8':
        setState(() => _phase = _TurnPhase.awaitingPower8Target);
        _startPowerTimeout();
        _runPower8Flow();
      case '9':
        setState(() => _phase = _TurnPhase.awaitingPower9Source);
        _startPowerTimeout();
      default:
        setState(() => _phase = _TurnPhase.idle);
    }
  }

  void _startPowerTimeout() {
    _powerTimeoutTimer?.cancel();
    _powerTimeoutTimer = Timer(_powerTargetTimeout, () {
      // Le joueur n'a pas répondu à temps : on annule proprement le
      // pouvoir plutôt que de bloquer la partie (doc §5).
      if (!mounted) return;
      setState(() {
        _phase = _TurnPhase.idle;
        _power9SourcePosition = null;
      });
    });
  }

  void _cancelPowerTimeout() {
    _powerTimeoutTimer?.cancel();
    _powerTimeoutTimer = null;
  }

  // --- Pouvoir 7 : regarder une de ses propres cartes ---

  Future<void> _handlePower7Tap(int position) async {
    _cancelPowerTimeout();
    final revealed = await widget.onPowerSelfPeek(position);
    if (!mounted) return;

    await showRevealedCardDialog(
      context,
      card: revealed,
      label: 'Votre carte (position ${position + 1})',
    );
    if (!mounted) return;
    setState(() => _phase = _TurnPhase.idle);
  }

  // --- Pouvoir 8 : espionner un adversaire ---

  Future<void> _runPower8Flow() async {
    final opponent = await showChooseOpponentDialog(
      context,
      opponents: widget.opponents,
      title: 'Espionner qui ?',
    );
    if (!mounted) return;
    if (opponent == null) {
      _cancelAndReturnToIdle();
      return;
    }

    final position = await showChoosePositionDialog(
      context,
      cardCount: opponent.hiddenCardCount,
      title: 'Quelle carte de ${opponent.name} ?',
    );
    if (!mounted) return;
    if (position == null) {
      _cancelAndReturnToIdle();
      return;
    }

    _cancelPowerTimeout();
    final revealed = await widget.onPowerSpy(opponent.id, position);
    if (!mounted) return;

    await showRevealedCardDialog(
      context,
      card: revealed,
      label: 'Carte de ${opponent.name} (position ${position + 1})',
    );
    if (!mounted) return;
    setState(() => _phase = _TurnPhase.idle);
  }

  // --- Pouvoir 9 : échange aveugle avec un adversaire ---

  Future<void> _handlePower9SourceTap(int position) async {
    setState(() {
      _power9SourcePosition = position;
      _phase = _TurnPhase.awaitingPower9Target;
    });
    await _runPower9TargetFlow();
  }

  Future<void> _runPower9TargetFlow() async {
    final sourcePosition = _power9SourcePosition;
    if (sourcePosition == null) return;

    final opponent = await showChooseOpponentDialog(
      context,
      opponents: widget.opponents,
      title: 'Échanger votre carte avec qui ?',
    );
    if (!mounted) return;
    if (opponent == null) {
      _cancelAndReturnToIdle();
      return;
    }

    final position = await showChoosePositionDialog(
      context,
      cardCount: opponent.hiddenCardCount,
      title: 'Quelle carte de ${opponent.name} ?',
    );
    if (!mounted) return;
    if (position == null) {
      _cancelAndReturnToIdle();
      return;
    }

    _cancelPowerTimeout();
    await widget.onPowerBlindSwap(sourcePosition, opponent.id, position);
    if (!mounted) return;
    setState(() {
      _power9SourcePosition = null;
      _phase = _TurnPhase.idle;
    });
  }

  void _cancelAndReturnToIdle() {
    _cancelPowerTimeout();
    setState(() {
      _power9SourcePosition = null;
      _phase = _TurnPhase.idle;
    });
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
      case _TurnPhase.awaitingPower7Target:
        _handlePower7Tap(position);
      case _TurnPhase.awaitingPower9Source:
        _handlePower9SourceTap(position);
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
    final isPower7 = _phase == _TurnPhase.awaitingPower7Target;
    final isPower9Source = _phase == _TurnPhase.awaitingPower9Source;

    final handInteractive =
        isPeekSelecting || isSwapMode || isPairMode || isPower7 || isPower9Source;
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
        if (isPower7) _buildBanner('Touchez une de vos cartes cachées pour la regarder'),
        if (isPower9Source) _buildBanner('Touchez votre carte à échanger (à l\'aveugle)'),

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