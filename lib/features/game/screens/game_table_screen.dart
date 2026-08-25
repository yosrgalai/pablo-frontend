import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injector.dart';
import '../../../data/models/card_model.dart';
import '../../../data/models/game_round_state.dart';
import '../../../data/models/player_model.dart';
import '../../../data/models/round_model.dart';
import '../../../data/repositories/game_repository.dart';
import '../bloc/game_bloc.dart';
import '../widgets/game_turn_controller.dart';

/// Écran de plateau réel : branche `GameTurnController` sur le
/// `GameBloc`/`GameRepository` de Dev A.
class GameTableScreen extends StatefulWidget {
  const GameTableScreen({super.key});

  @override
  State<GameTableScreen> createState() => _GameTableScreenState();
}

class _GameTableScreenState extends State<GameTableScreen> {
  late final GameRepository _repository;
  late final GameBloc _gameBloc;

  List<CardModel> _hand = const [];
  List<PlayerModel> _opponents = const [];

  // TODO: pas de source confirmée pour le nombre de cartes en pioche —
  // `game:dealt` ne contient que `{gameId}` (confirmé dans le Gateway).
  // Valeur de test en attendant qu'un event/endpoint l'expose vraiment.
  int _drawPileCount = 40;
  CardModel? _discardTop;

  @override
  void initState() {
    super.initState();
    _repository = getIt<GameRepository>();
    _gameBloc = context.read<GameBloc>();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _seedHandFromCurrentState();
    _loadOpponentsFromRest();
    _listenToDiscardUpdates();
  }

  /// Tient `_discardTop` à jour depuis les events BROADCAST du serveur —
  /// autoritaire, fonctionne même si on ne connaissait pas la carte
  /// concernée (échange d'une carte jamais peekée, paire d'un adversaire,
  /// etc.). Remplace les mises à jour "au pif" faites localement avant.
  /// Construit une carte à partir d'un JSON de défausse/échange, qui n'a
  /// PAS la clé `hidden` (contrairement au contrat `CardModel.fromJson`
  /// habituel) — logique, une carte défaussée est toujours visible.
  /// `rank` peut arriver en nombre (`7`) ou en texte selon la carte —
  /// `toString()` couvre les deux cas.
  CardModel _cardFromRevealedJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'] as String,
      rank: json['rank']?.toString(),
      suit: json['suit'] as String?,
      hidden: false,
    );
  }

  void _listenToDiscardUpdates() {
    _repository.onCardSwapped.listen((payload) {
      debugPrint('[turn:swapped_card] payload reçu : $payload');
      try {
        Map<String, dynamic>? cardJson;
        if (payload.containsKey('id')) {
          cardJson = payload; // la racine EST déjà la carte
        } else {
          final nested = payload['discardedCard'] ?? payload['oldCard'] ?? payload['card'];
          if (nested is Map) cardJson = Map<String, dynamic>.from(nested);
        }
        if (cardJson != null && mounted) {
          setState(() => _discardTop = _cardFromRevealedJson(cardJson!));
        }
      } catch (e) {
        debugPrint('turn:swapped_card payload inattendu, à ajuster : $payload ($e)');
      }
    });

    _repository.onCardDiscarded.listen((payload) {
      debugPrint('[turn:discarded_card] payload reçu : $payload');
      try {
        if (payload.containsKey('discardedCards')) {
          final list = payload['discardedCards'] as List;
          if (list.isNotEmpty && mounted) {
            setState(() => _discardTop = _cardFromRevealedJson(
                  Map<String, dynamic>.from(list.last as Map),
                ));
          }
        } else if (payload.containsKey('id') && mounted) {
          setState(() => _discardTop = _cardFromRevealedJson(payload));
        }
      } catch (e) {
        debugPrint('turn:discarded_card payload inattendu, à ajuster : $payload ($e)');
      }
    });
  }

  void _seedHandFromCurrentState() {
    final state = _gameBloc.state;
    if (state is GameInitialPeekState) {
      _hand = state.positions;
    } else if (state is GameWaitingOthersPeekState) {
      _hand = state.revealedCards;
    }
  }

  /// Les adversaires viennent du REST (`findOne`), pas du socket :
  /// `game:dealt` ne contient que `{gameId}` (confirmé dans
  /// game.gateway.ts). Le lobby a déjà cette info au moment du "Démarrer
  /// la partie", mais elle n'est pas propagée jusqu'ici pour l'instant —
  /// on la re-fetch nous-mêmes en attendant mieux.
  Future<void> _loadOpponentsFromRest() async {
    try {
      final snapshot = await _repository.findOne(_gameBloc.gameId);
      final opponents = snapshot.players
          .where((p) => p.id != _gameBloc.localPlayerId)
          .toList();
      if (mounted) {
        setState(() {
          _opponents = opponents;
          // Valeur RÉELLE calculée (pas de dédié côté serveur, confirmé
          // via la console de test : aucun event de ce type n'existe) :
          // 104 cartes au total (doc jeu §2), 4 distribuées par joueur.
          final totalPlayers = opponents.length + 1; // + moi-même
          _drawPileCount = (104 - totalPlayers * 4).clamp(0, 104);
        });
      }
    } catch (e) {
      debugPrint('Impossible de charger les adversaires (findOne) : $e');
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  // --- INITIAL_PEEK ---

  Future<void> _handleConfirmPeek(List<int> positions) async {
    _repository.chooseInitialPeek(
      gameId: _gameBloc.gameId,
      playerId: _gameBloc.localPlayerId,
      positions: positions,
    );

    final state = await _gameBloc.stream.firstWhere(
      (s) => s is GameWaitingOthersPeekState,
      orElse: () => _gameBloc.state,
    );

    if (state is GameWaitingOthersPeekState && mounted) {
      final revealed = state.revealedCards;
      setState(() {
        final newHand = List<CardModel>.from(_hand);
        for (var i = 0; i < positions.length && i < revealed.length; i++) {
          newHand[positions[i]] = revealed[i];
        }
        _hand = newHand;
      });
    }
  }

  void _handlePeekComplete() {
    setState(() {
      _hand = _hand.map((c) => CardModel(id: c.id, hidden: true)).toList();
    });
  }

  // --- Tour normal ---

  Future<CardModel> _handleDrawCard() async {
    final card = await _repository.drawCard(
      gameId: _gameBloc.gameId,
      playerId: _gameBloc.localPlayerId,
    );
    if (mounted) setState(() => _drawPileCount = (_drawPileCount - 1).clamp(0, 999));
    return card;
  }

  void _handleSwapCard(CardModel drawnCard, int handPosition) {
    _repository.swapCard(
      gameId: _gameBloc.gameId,
      playerId: _gameBloc.localPlayerId,
      drawnCardId: drawnCard.id,
      handPosition: handPosition,
    );

    setState(() {
      final newHand = List<CardModel>.from(_hand);
      newHand[handPosition] = CardModel(id: drawnCard.id, hidden: true);
      _hand = newHand;
      // _discardTop est mis à jour par le listener `onCardSwapped`
      // (autoritaire, voir `_listenToDiscardUpdates`), pas ici.
    });
  }

  void _handleDiscardCard(CardModel drawnCard, {required bool usePower}) {
    _repository.discardCard(
      gameId: _gameBloc.gameId,
      playerId: _gameBloc.localPlayerId,
      drawnCardId: drawnCard.id,
      usePower: usePower,
    );
    setState(() => _discardTop = drawnCard);
  }

  Future<bool> _handlePairAttempt(int firstPosition, int secondPosition) async {
    final success = await _repository.pairAttempt(
      gameId: _gameBloc.gameId,
      playerId: _gameBloc.localPlayerId,
      firstPosition: firstPosition,
      secondPosition: secondPosition,
    );

    setState(() {
      if (success) {
        final hi = firstPosition > secondPosition ? firstPosition : secondPosition;
        final lo = firstPosition > secondPosition ? secondPosition : firstPosition;
        _hand = List<CardModel>.from(_hand)..removeAt(hi)..removeAt(lo);
      } else {
        _hand = List<CardModel>.from(_hand)
          ..add(CardModel(id: 'penalty_${DateTime.now().microsecondsSinceEpoch}', hidden: true));
      }
    });

    return success;
  }

  // --- Annoncer Pablo ---

  /// Passe par le `GameBloc` (pas directement par `_repository`) : c'est
  /// lui qui écoute déjà `cabo:called` (met à jour `pabloCalled` pour
  /// tout le monde) et `round:ended` (fait basculer `GameFlowScreen` vers
  /// l'écran de scoring dès que la manche est réellement terminée).
  void _handleCallPablo() {
    _gameBloc.add(const GameCallPabloPressed());
  }

  // --- Pouvoirs ---

  Future<CardModel> _handlePowerSelfPeek(int ownPosition) {
    return _repository.powerSelfPeek(
      gameId: _gameBloc.gameId,
      playerId: _gameBloc.localPlayerId,
      ownPosition: ownPosition,
    );
  }

  Future<CardModel> _handlePowerSpy(String opponentId, int opponentPosition) {
    return _repository.powerSpy(
      gameId: _gameBloc.gameId,
      playerId: _gameBloc.localPlayerId,
      opponentId: opponentId,
      opponentPosition: opponentPosition,
    );
  }

  Future<void> _handlePowerBlindSwap(
    int ownPosition,
    String opponentId,
    int opponentPosition,
  ) async {
    await _repository.powerBlindSwap(
      gameId: _gameBloc.gameId,
      playerId: _gameBloc.localPlayerId,
      ownPosition: ownPosition,
      opponentId: opponentId,
      opponentPosition: opponentPosition,
    );
    setState(() {
      final newHand = List<CardModel>.from(_hand);
      newHand[ownPosition] = CardModel(
        id: 'swapped_${DateTime.now().microsecondsSinceEpoch}',
        hidden: true,
      );
      _hand = newHand;
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameBloc>().state;

    final needsInitialPeek =
        gameState is GameInitialPeekState || gameState is GameWaitingOthersPeekState;
    final isMyTurn = gameState is GamePlayerTurnState && gameState.isLocalTurn;

    // Annonce Pablo (doc §6) : vient de `GamePlayerTurnState.pabloCalled`,
    // alimenté par `cabo:called`. Vrai pour TOUS les joueurs dès qu'un
    // seul a annoncé, pas seulement pour l'auteur de l'annonce.
    final pabloCalled = gameState is GamePlayerTurnState && gameState.pabloCalled;
    final pabloCallerId = gameState is GamePlayerTurnState ? gameState.pabloCallerId : null;
    final isLocalPabloCaller = pabloCallerId == _gameBloc.localPlayerId;

    String? pabloAnnouncementText;
    if (pabloCalled) {
      if (isLocalPabloCaller) {
        pabloAnnouncementText = 'Vous avez annoncé Pablo';
      } else {
        final caller = _opponents.where((o) => o.id == pabloCallerId);
        final callerName = caller.isNotEmpty ? caller.first.name : 'Un joueur';
        pabloAnnouncementText = '$callerName a annoncé Pablo';
      }
    }

    // Reflète l'annonce sur le siège de l'adversaire concerné (le badge
    // "Pablo !" existe déjà dans `OpponentSeatWidget`, il manquait juste
    // la mise à jour dynamique de `hasCalledPablo`).
    final displayedOpponents = pabloCalled && pabloCallerId != null
        ? _opponents
            .map((o) => o.id == pabloCallerId ? o.copyWith(hasCalledPablo: true) : o)
            .toList()
        : _opponents;

    final localPlayer = PlayerModel(
      id: _gameBloc.localPlayerId,
      name: 'Moi',
      handSize: _hand.length,
      isConnected: true,
      isCurrentTurn: isMyTurn,
      hand: _hand,
      hasCalledPablo: pabloCalled && isLocalPabloCaller,
    );

    final round = RoundModel(
      roundNumber: 1,
      drawPileCount: _drawPileCount,
      discardTop: _discardTop,
      state: GameRoundState.playerTurn,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0B6B4F),
      body: SafeArea(
        child: GameTurnController(
          localPlayer: localPlayer,
          opponents: displayedOpponents,
          round: round,
          needsInitialPeek: needsInitialPeek,
          onConfirmPeek: _handleConfirmPeek,
          onPeekComplete: _handlePeekComplete,
          onDrawCard: _handleDrawCard,
          onSwapCard: _handleSwapCard,
          onDiscardCard: _handleDiscardCard,
          onPairAttempt: _handlePairAttempt,
          onPowerSelfPeek: _handlePowerSelfPeek,
          onPowerSpy: _handlePowerSpy,
          onPowerBlindSwap: _handlePowerBlindSwap,
          onCallPablo: _handleCallPablo,
          pabloCalled: pabloCalled,
          pabloAnnouncementText: pabloAnnouncementText,
        ),
      ),
    );
  }
}