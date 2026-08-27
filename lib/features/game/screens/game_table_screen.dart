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
import '../widgets/card_flight_layer.dart';
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

  // --- Ancrages pour les animations de vol de carte (Point 3 UX) ---
  final GlobalKey<CardFlightLayerState> _flightKey = GlobalKey();
  final GlobalKey _drawPileKey = GlobalKey();
  final GlobalKey _discardPileKey = GlobalKey();
  final GlobalKey _localHandKey = GlobalKey();
  final Map<String, GlobalKey> _opponentSeatKeys = {};

  GlobalKey _keyForOpponent(String id) =>
      _opponentSeatKeys.putIfAbsent(id, () => GlobalKey());

  /// Clé d'ancrage "main" pour un joueur donné, adversaire ou local.
  GlobalKey _seatKeyFor(String playerId) =>
      playerId == _gameBloc.localPlayerId ? _localHandKey : _keyForOpponent(playerId);

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

  /// Identifie l'auteur de l'action en cours SANS dépendre d'une clé
  /// `playerId` non confirmée dans les payloads broadcast : seul le
  /// joueur dont c'est le tour peut piocher/échanger/défausser/utiliser
  /// un pouvoir, donc `GamePlayerTurnState.currentPlayerId` est une
  /// source fiable, contrairement à deviner la forme du payload.
  String? get _currentTurnPlayerId {
    final state = _gameBloc.state;
    return state is GamePlayerTurnState ? state.currentPlayerId : null;
  }

  /// Corrige `handSize` d'un adversaire dans `_opponents` (chargé UNE FOIS
  /// via REST au démarrage, jamais resynchronisé automatiquement sinon).
  /// Sans ça, une paire réussie/ratée chez un adversaire finit par
  /// afficher le mauvais nombre de cartes cachées sur son siège — bug
  /// observé en jeu (5e carte de Yossr jamais visible chez Maryem).
  void _adjustOpponentHandSize(String? playerId, int delta) {
    if (playerId == null || playerId == _gameBloc.localPlayerId) return;
    setState(() {
      _opponents = _opponents.map((o) {
        if (o.id != playerId) return o;
        return o.copyWith(handSize: (o.handSize + delta).clamp(0, 99));
      }).toList();
    });
  }

  void _listenToDiscardUpdates() {
    _repository.onCardSwapped.listen((payload) {
      debugPrint('[turn:swapped_card] payload reçu : $payload');
      final actingId = _currentTurnPlayerId;
      // Le joueur local a déjà son propre retour visuel immédiat (feuille
      // de décision + Hero) : on ne fait voler que pour les adversaires.
      if (actingId == null || actingId == _gameBloc.localPlayerId) return;

      Map<String, dynamic>? cardJson;
      try {
        if (payload.containsKey('id')) {
          cardJson = payload; // la racine EST déjà la carte
        } else {
          final nested = payload['discardedCard'] ?? payload['oldCard'] ?? payload['card'];
          if (nested is Map) cardJson = Map<String, dynamic>.from(nested);
        }
      } catch (e) {
        debugPrint('turn:swapped_card payload inattendu, à ajuster : $payload ($e)');
      }
      if (cardJson == null) return;
      final revealed = _cardFromRevealedJson(cardJson);

      // La carte cachée vole de la main de l'adversaire vers la
      // défausse, et ne se retourne (révèle sa valeur) qu'à l'arrivée —
      // jamais avant, fidèle à ce qu'un joueur peut réellement savoir.
      _flightKey.currentState?.fly(
        fromKey: _seatKeyFor(actingId),
        toKey: _discardPileKey,
        revealCard: revealed,
        onLanded: () {
          if (mounted) setState(() => _discardTop = revealed);
        },
      );
    });

    _repository.onCardDiscarded.listen((payload) {
      debugPrint('[turn:discarded_card] payload reçu : $payload');
      final actingId = _currentTurnPlayerId;
      if (actingId == null || actingId == _gameBloc.localPlayerId) return;

      final isPair = payload.containsKey('discardedCards');

      if (isPair) {
        try {
          final revealedList = (payload['discardedCards'] as List)
              .map((e) => _cardFromRevealedJson(Map<String, dynamic>.from(e as Map)))
              .toList();
          if (revealedList.isEmpty) return;

          // -2 cartes chez l'adversaire dès maintenant : la paire quitte
          // sa main immédiatement, indépendamment du temps que prend le
          // vol visuel — sinon son siège reste désynchronisé.
          _adjustOpponentHandSize(actingId, -2);

          // Les 2 cartes de la paire volent l'une après l'autre (léger
          // décalage) depuis sa main jusqu'à la défausse.
          for (var i = 0; i < revealedList.length; i++) {
            final card = revealedList[i];
            Future.delayed(Duration(milliseconds: i * 130), () {
              if (!mounted) return;
              _flightKey.currentState?.fly(
                fromKey: _seatKeyFor(actingId),
                toKey: _discardPileKey,
                revealCard: card,
                onLanded: () {
                  if (mounted) setState(() => _discardTop = card);
                },
              );
            });
          }
        } catch (e) {
          debugPrint('turn:discarded_card (paire) payload inattendu : $payload ($e)');
        }
      } else if (payload.containsKey('id')) {
        // Défausse directe (sans échange) : on la fait quand même voler
        // depuis le siège du joueur (pas la pioche) — plus lisible et
        // cohérent avec l'animation d'échange, même si techniquement la
        // carte n'a jamais "résidé" dans sa main.
        final revealed = _cardFromRevealedJson(payload);
        _flightKey.currentState?.fly(
          fromKey: _seatKeyFor(actingId),
          toKey: _discardPileKey,
          revealCard: revealed,
          onLanded: () {
            if (mounted) setState(() => _discardTop = revealed);
          },
        );
      }
    });

    // Pouvoir 9 (échange à l'aveugle) UNIQUEMENT : le serveur ne broadcast
    // jamais rien ici pour les pouvoirs 7/8 (privés par design), donc
    // tout ce qu'on reçoit sur ce flux est forcément un pouvoir 9.
    _repository.onPowerTargetSelected.listen((payload) {
      debugPrint('[power:target_selected] (broadcast, donc pouvoir 9) : $payload');
      final actingId = _currentTurnPlayerId;
      if (actingId == null || actingId == _gameBloc.localPlayerId) return;

      // Forme du payload non confirmée (doc : `{ swapped: {...} }`) — on
      // tente plusieurs clés plausibles pour identifier la cible.
      String? targetId;
      try {
        final swapped = payload['swapped'];
        final source = swapped is Map ? Map<String, dynamic>.from(swapped) : payload;
        targetId = source['opponentId']?.toString() ??
            source['targetPlayerId']?.toString() ??
            source['targetId']?.toString();
      } catch (_) {
        targetId = null;
      }

      if (targetId != null && targetId != actingId) {
        // Deux cartes cachées se croisent entre les deux mains — ni
        // l'une ni l'autre ne se révèle JAMAIS : le pouvoir 9 n'expose
        // aucune valeur, ni à l'auteur, ni à qui que ce soit d'autre.
        _flightKey.currentState?.fly(fromKey: _seatKeyFor(actingId), toKey: _seatKeyFor(targetId));
        _flightKey.currentState?.fly(fromKey: _seatKeyFor(targetId), toKey: _seatKeyFor(actingId));
      } else {
        // Cible non identifiable dans le payload (forme non confirmée) :
        // effet de secours plutôt que rien du tout — signale "quelque
        // chose vient de se passer ici" sans prétendre savoir où.
        _flightKey.currentState?.fly(fromKey: _seatKeyFor(actingId), toKey: _seatKeyFor(actingId));
      }
    });

    // Carte de pénalité (paire ratée) : elle vient de la pioche.
    _repository.onPenaltyCardDrawn.listen((payload) {
      debugPrint('[turn:drew_card] pénalité reçue : $payload');
      final actingId = _currentTurnPlayerId;
      if (actingId == null || actingId == _gameBloc.localPlayerId) return;

      _flightKey.currentState?.fly(
        fromKey: _drawPileKey,
        toKey: _seatKeyFor(actingId),
        onLanded: () => _adjustOpponentHandSize(actingId, 1),
      );
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
        child: CardFlightLayer(
          key: _flightKey,
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
            drawPileKey: _drawPileKey,
            discardPileKey: _discardPileKey,
            localHandKey: _localHandKey,
            opponentSeatKeyFor: _keyForOpponent,
          ),
        ),
      ),
    );
  }
}