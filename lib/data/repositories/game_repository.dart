import 'dart:async';

import '../../core/network/api_client.dart';
import '../../core/network/socket_service.dart';
import '../models/card_model.dart';
import '../models/player_model.dart';

/// Erreur métier renvoyée par le serveur via l'event `error` en réponse à
/// une action (ex: "Ce n'est pas votre tour"). Distincte de `TimeoutException`
/// pour permettre à l'UI d'afficher le vrai message plutôt qu'un message
/// générique de timeout.
class GameActionException implements Exception {
  GameActionException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Résumé d'une partie ouverte, retourné par GET /games/open.
class OpenGameSummary {
  final String gameId;
  final String name;  
  final int scoreLimit;
  final String hostName;
  final int playerCount;
  final int maxPlayers;

  OpenGameSummary({
    required this.gameId,
    required this.name, 
    required this.scoreLimit,
    required this.hostName,
    required this.playerCount,
    required this.maxPlayers,
  });

  factory OpenGameSummary.fromJson(Map<String, dynamic> json) => OpenGameSummary(
        gameId: json['gameId'] as String,
        name: json['name'] as String? ?? 'Partie sans nom',
        scoreLimit: json['scoreLimit'] as int,
        hostName: json['hostName'] as String,
        playerCount: json['playerCount'] as int,
        maxPlayers: json['maxPlayers'] as int,
      );
}

/// État complet d'une partie (lobby ou en cours), tel que renvoyé par
/// POST /games, POST /games/:id/join (partiellement) et GET /games/:id.
class GameSnapshot {
  final String gameId;
  final int scoreLimit;
  final String state;
  final String? hostPlayerId;
  final List<PlayerModel> players;

  GameSnapshot({
    required this.gameId,
    required this.scoreLimit,
    required this.state,
    required this.hostPlayerId,
    required this.players,
  });

  factory GameSnapshot.fromCreateResponse(Map<String, dynamic> json) {
    final rawPlayers = (json['players'] as List?) ?? const [];
    final hostPlayerId = json['hostPlayerId'] as String?;
    return GameSnapshot(
      gameId: json['gameId'] as String,
      scoreLimit: json['scoreLimit'] as int,
      state: json['state'] as String? ?? 'LOBBY',
      hostPlayerId: hostPlayerId,
      players: rawPlayers.map((p) {
        final map = Map<String, dynamic>.from(p);
        return _playerFromRestJson(map, hostPlayerId: hostPlayerId);
      }).toList(),
    );
  }

  factory GameSnapshot.fromGetOne(Map<String, dynamic> json) {
    final rawPlayers = (json['players'] as List?) ?? const [];
    final hostPlayerId = json['hostPlayerId'] as String?;
    return GameSnapshot(
      gameId: json['id'] as String,
      scoreLimit: json['scoreLimit'] as int,
      state: json['state'] as String? ?? 'LOBBY',
      hostPlayerId: hostPlayerId,
      players: rawPlayers.map((p) {
        final map = Map<String, dynamic>.from(p);
        return _playerFromRestJson(map, hostPlayerId: hostPlayerId);
      }).toList(),
    );
  }
}

/// `PlayerModel` (Dev B, freezed) a des champs requis liés à la partie en
/// cours (handSize, isCurrentTurn...) que le REST du lobby ne fournit pas.
/// On les remplit avec des valeurs par défaut neutres.
///
/// [handSize] est forcé à 4 (pas 0) : le REST ne connaît pas vraiment la
/// taille de main en cours, mais 0 afficherait un adversaire "sans
/// cartes" à tort dès le début de partie — 4 est la valeur réelle au
/// moment de la distribution initiale.
PlayerModel _playerFromRestJson(
  Map<String, dynamic> json, {
  required String? hostPlayerId,
}) {
  final id = json['id'] as String;
  return PlayerModel(
    id: id,
    name: json['name'] as String? ?? '?',
    isHost: hostPlayerId != null && id == hostPlayerId,
    isReady: false,
    handSize: 4,
    hand: const [],
    isConnected: json['isConnected'] as bool? ?? false,
    isCurrentTurn: false,
    hasCalledPablo: json['hasCalledPablo'] as bool? ?? false,
    totalScore: json['score'] as int? ?? 0,
  );
}

/// Traduit les appels REST (création/jonction/liste de parties) et les
/// events du namespace socket `/game` en objets Dart.
class GameRepository {
  final ApiClient _api;
  final SocketService _socket;

  GameRepository(this._api, this._socket);

  Future<GameSnapshot> createGame({required int scoreLimit,required String name,  }) async {
    final json = await _api.post('/games', body: {'scoreLimit': scoreLimit, 'name': name});
    return GameSnapshot.fromCreateResponse(Map<String, dynamic>.from(json));
  }

  Future<(String playerId, GameSnapshot snapshot)> joinGame({
    required String gameId,
  }) async {
    final joinJson = await _api.post('/games/$gameId/join');
    final playerId = Map<String, dynamic>.from(joinJson)['playerId'] as String;
    final snapshot = await findOne(gameId);
    return (playerId, snapshot);
  }

  Future<GameSnapshot> findOne(String gameId) async {
    final json = await _api.get('/games/$gameId');
    return GameSnapshot.fromGetOne(Map<String, dynamic>.from(json));
  }

  Future<List<OpenGameSummary>> listOpenGames() async {
    final json = await _api.get('/games/open') as List;
    return json
        .map((g) => OpenGameSummary.fromJson(Map<String, dynamic>.from(g)))
        .toList();
  }

  Future<void> connectToRoom({
    required String gameId,
    required String playerId,
    Duration timeout = const Duration(seconds: 6),
  }) {
    final completer = Completer<void>();
    late final StreamSubscription sub;

    sub = _socket.on('game:joined', (payload) => payload).listen(
      (payload) {
        final map = Map<String, dynamic>.from(payload as Map);
        if (map['gameId'] == gameId && map['playerId'] == playerId) {
          if (!completer.isCompleted) completer.complete();
          sub.cancel();
        }
      },
      onError: (Object e) {
        if (!completer.isCompleted) completer.completeError(e);
        sub.cancel();
      },
    );

    _socket.emit('join_game', {'gameId': gameId, 'playerId': playerId});

    return completer.future.timeout(
      timeout,
      onTimeout: () {
        sub.cancel();
        throw TimeoutException('Connexion à la room du jeu impossible.');
      },
    );
  }

  void startGame({required String gameId, required String playerId}) {
    _socket.emit('start_game', {'gameId': gameId, 'playerId': playerId});
  }

  /// `game:dealt` — payload minimal : `{ gameId }` UNIQUEMENT (confirmé
  /// dans game.gateway.ts : `emit(GAME_DEALT, { gameId })`). Ne contient
  /// PAS la liste des joueurs ni le nombre de cartes en pioche — ces
  /// infos viennent du REST (`findOne`), pas de cet event.
  Stream<Map<String, dynamic>> get onGameDealt => _socket.on(
        'game:dealt',
        (payload) => Map<String, dynamic>.from(payload as Map),
      );

  Stream<String> get onError => _socket.on(
        'error',
        (payload) => (payload as Map)['message']?.toString() ?? 'Erreur inconnue.',
      );

  void requestHandPositions({required String gameId, required String playerId}) {
    _socket.emit('get_hand_positions', {'gameId': gameId, 'playerId': playerId});
  }

  Stream<List<CardModel>> get onHandPositionsReady => _socket.on(
        'hand:positions',
        (payload) => ((payload as Map)['cards'] as List)
            .map((c) => _cardFromJson(Map<String, dynamic>.from(c)))
            .toList(),
      );

  void chooseInitialPeek({
    required String gameId,
    required String playerId,
    required List<int> positions,
  }) {
    _socket.emit('choose_initial_peek', {
      'gameId': gameId,
      'playerId': playerId,
      'positions': positions,
    });
  }

  Stream<List<CardModel>> get onPeekedInitial => _socket.on(
        'player:peeked_initial',
        (payload) => ((payload as Map)['cards'] as List)
            .map((c) => _cardFromJson(Map<String, dynamic>.from(c)))
            .toList(),
      );

  Stream<String> get onTurnStarted => _socket.on(
        'turn:started',
        (payload) => (payload as Map)['playerId'] as String,
      );

  void callPablo({required String gameId, required String playerId}) {
    _socket.emit('call_pablo', {'gameId': gameId, 'playerId': playerId});
  }

  Stream<String> get onCaboCalled => _socket.on(
        'cabo:called',
        (payload) => (payload as Map)['playerId'] as String,
      );

  Stream<Map<String, dynamic>> get onRoundEnded => _socket.on(
        'round:ended',
        (payload) => Map<String, dynamic>.from(payload as Map),
      );

  Stream<Map<String, dynamic>> get onGameEnded => _socket.on(
        'game:ended',
        (payload) => Map<String, dynamic>.from(payload as Map),
      );

  /// `turn:swapped_card` — broadcast à toute la room à chaque échange
  /// (le vôtre ou celui d'un adversaire). Payload = objet `result` brut
  /// de `cardService.swapCard()`, forme exacte non documentée — le
  /// consommateur (`GameTableScreen`) tente plusieurs clés usuelles.
  Stream<Map<String, dynamic>> get onCardSwapped => _socket.on(
        'turn:swapped_card',
        (payload) => Map<String, dynamic>.from(payload as Map),
      );

  /// `turn:discarded_card` — broadcast, DEUX formes possibles :
  /// - défausse simple : la carte directement (`{id, rank, suit, ...}`)
  /// - paire réussie : `{ discardedCards: [carte1, carte2] }`
  Stream<Map<String, dynamic>> get onCardDiscarded => _socket.on(
        'turn:discarded_card',
        (payload) => Map<String, dynamic>.from(payload as Map),
      );

  /// `power:target_selected` — normalement PRIVÉ (`isPrivate: true`) pour
  /// les pouvoirs 7 et 8 : le serveur n'envoie ce résultat qu'au client
  /// auteur, jamais aux autres. Broadcast en revanche pour le pouvoir 9
  /// (`isPrivate: false`, cf. doc de [powerBlindSwap] plus bas), payload
  /// `{ swapped: {...} }` sans révéler aucune carte.
  ///
  /// Ce flux permet aux AUTRES joueurs de détecter qu'un pouvoir 9 vient
  /// d'être joué (pour l'afficher dans l'UI). Pour les pouvoirs 7/8, ce
  /// stream ne recevra simplement rien chez un autre client que l'auteur
  /// — c'est le comportement de confidentialité voulu, pas un bug.
  ///
  /// ⚠️ Distinct de l'appel ponctuel fait en interne par [powerSelfPeek] /
  /// [powerSpy] / [powerBlindSwap] (`_emitAndAwaitOnce`) : les deux
  /// écoutent le même event socket — Socket.IO autorise plusieurs
  /// listeners simultanés dessus, aucun conflit entre eux.
  Stream<Map<String, dynamic>> get onPowerTargetSelected => _socket.on(
        'power:target_selected',
        (payload) => Map<String, dynamic>.from(payload as Map),
      );

  /// `turn:drew_card` filtré sur `{ penalty: true }` : carte de pénalité
  /// ajoutée après un `attempt_pair` raté (doc §5). Contrairement à un
  /// tirage normal (privé, révèle une valeur de carte), cette carte de
  /// pénalité ne révèle RIEN — elle peut donc raisonnablement être
  /// broadcast à toute la room. ⚠️ À confirmer côté backend : si ce n'est
  /// PAS broadcast aujourd'hui, ce flux ne recevra simplement rien chez
  /// les autres clients, et `handSize` des adversaires restera désynchro
  /// après une pénalité (cf. bug observé en jeu).
  ///
  /// Flux séparé de l'écoute interne faite par [pairAttempt] pour son
  /// propre completer : les deux écoutent le même event socket, sans
  /// conflit (Socket.IO supporte plusieurs listeners simultanés).
  Stream<Map<String, dynamic>> get onPenaltyCardDrawn => _socket
      .on('turn:drew_card', (payload) => Map<String, dynamic>.from(payload as Map))
      .where((payload) => payload['penalty'] == true);

  // ---------------------------------------------------------------------
  // Tour de jeu détaillé (Dev B) : piocher / échanger / défausser / paire
  // / pouvoirs.
  //
  // Noms d'events déduits de `game.gateway.ts` (constantes ClientEvents/
  // ServerEvents), en suivant le MÊME pattern que les 5 déjà confirmés
  // fonctionnels (JOIN_GAME->'join_game', START_GAME->'start_game', etc.) :
  //   ClientEvents.DRAW          -> 'draw'
  //   ClientEvents.SWAP          -> 'swap'
  //   ClientEvents.DISCARD       -> 'discard'
  //   ClientEvents.ATTEMPT_PAIR  -> 'attempt_pair'   (PAS 'pair_attempt' !)
  //   ClientEvents.POWER_TARGET  -> 'power_target'
  //   ServerEvents.TURN_DREW_CARD      -> 'turn:drew_card'
  //   ServerEvents.TURN_SWAPPED_CARD   -> 'turn:swapped_card'
  //   ServerEvents.TURN_DISCARDED_CARD -> 'turn:discarded_card'
  //   ServerEvents.POWER_ACTIVATED        -> 'power:activated'
  //   ServerEvents.POWER_TARGET_SELECTED  -> 'power:target_selected'
  //
  // ⚠️ Toujours déduit par pattern, pas lu directement dans
  // events.constants.ts — à corriger si un event ne répond toujours pas.
  // ---------------------------------------------------------------------

  /// Émet `draw`. Le serveur renvoie la carte DIRECTEMENT en payload
  /// (`client.emit(TURN_DREW_CARD, drawnCard)`), pas encapsulée.
  Future<CardModel> drawCard({
    required String gameId,
    required String playerId,
    Duration timeout = const Duration(seconds: 8),
  }) {
    return _emitAndAwaitOnce<CardModel>(
      emitEvent: 'draw',
      emitPayload: {'gameId': gameId, 'playerId': playerId},
      responseEvent: 'turn:drew_card',
      timeout: timeout,
      mapResponse: (payload) => _cardFromJson(Map<String, dynamic>.from(payload as Map)),
    );
  }

  /// Émet `swap`. Pas de réponse directe attendue par l'appelant local —
  /// le résultat (`turn:swapped_card`) est broadcast à toute la room.
  void swapCard({
    required String gameId,
    required String playerId,
    required String drawnCardId,
    required int handPosition,
  }) {
    _socket.emit('swap', {
      'gameId': gameId,
      'playerId': playerId,
      'drawnCardId': drawnCardId,
      'handPosition': handPosition,
    });
  }

  /// Émet `discard`. Même remarque que [swapCard] (`turn:discarded_card`
  /// broadcast, pas de réponse directe attendue ici).
  void discardCard({
    required String gameId,
    required String playerId,
    required String drawnCardId,
    required bool usePower,
  }) {
    _socket.emit('discard', {
      'gameId': gameId,
      'playerId': playerId,
      'drawnCardId': drawnCardId,
      'usePower': usePower,
    });
  }

  /// Émet `attempt_pair`.
  ///
  /// ⚠️ Il N'EXISTE PAS d'event dédié "résultat de paire" côté backend
  /// (confirmé dans `handleAttemptPair`) : le succès et l'échec empruntent
  /// deux events DIFFÉRENTS et DÉJÀ utilisés ailleurs :
  ///   - Succès -> `turn:discarded_card` broadcast, payload
  ///     `{ discardedCards: [...] }` (pluriel — à distinguer du payload
  ///     "carte unique" utilisé par une défausse normale).
  ///   - Échec  -> `turn:drew_card` PRIVÉ au joueur, payload
  ///     `{ penalty: true, card: {...} }` (à distinguer du payload "carte
  ///     piochée" normal, qui n'a pas la clé `penalty`).
  /// On écoute donc les DEUX events en parallèle et on retient celui qui
  /// correspond au bon "shape" de payload.
  Future<bool> pairAttempt({
    required String gameId,
    required String playerId,
    required int firstPosition,
    required int secondPosition,
    Duration timeout = const Duration(seconds: 8),
  }) {
    final completer = Completer<bool>();
    late final StreamSubscription discardSub;
    late final StreamSubscription drewSub;
    late final StreamSubscription errSub;

    void cancelAll() {
      discardSub.cancel();
      drewSub.cancel();
      errSub.cancel();
    }

    void finish(bool success) {
      if (!completer.isCompleted) completer.complete(success);
      cancelAll();
    }

    discardSub = _socket.on('turn:discarded_card', (payload) => payload).listen(
      (payload) {
        if (payload is Map && payload.containsKey('discardedCards')) {
          finish(true);
        }
      },
      onError: (Object e) {
        if (!completer.isCompleted) completer.completeError(e);
        cancelAll();
      },
    );

    drewSub = _socket.on('turn:drew_card', (payload) => payload).listen(
      (payload) {
        if (payload is Map && payload['penalty'] == true) {
          finish(false);
        }
      },
      onError: (Object e) {
        if (!completer.isCompleted) completer.completeError(e);
        cancelAll();
      },
    );

    errSub = _socket.on('error', (payload) => payload).listen((payload) {
      if (!completer.isCompleted) {
        final message = (payload as Map)['message']?.toString() ?? 'Erreur inconnue.';
        completer.completeError(GameActionException(message));
      }
      cancelAll();
    });

    _socket.emit('attempt_pair', {
      'gameId': gameId,
      'playerId': playerId,
      'firstPosition': firstPosition,
      'secondPosition': secondPosition,
    });

    return completer.future.timeout(
      timeout,
      onTimeout: () {
        cancelAll();
        throw TimeoutException('Pas de réponse du serveur pour "attempt_pair".');
      },
    );
  }

  /// Pouvoir 7 : regarder une de ses propres cartes cachées.
  /// Payload de réponse `{ card: {...} }` (pouvoir privé, `isPrivate: true`
  /// côté backend).
  Future<CardModel> powerSelfPeek({
    required String gameId,
    required String playerId,
    required int ownPosition,
    Duration timeout = const Duration(seconds: 8),
  }) {
    return _emitAndAwaitOnce<CardModel>(
      emitEvent: 'power_target',
      emitPayload: {
        'gameId': gameId,
        'playerId': playerId,
        'powerRank': 7,
        'targetPlayerId': playerId,
        'targetPosition': ownPosition,
      },
      responseEvent: 'power:target_selected',
      timeout: timeout,
      mapResponse: (payload) => _cardFromJson(
        Map<String, dynamic>.from((payload as Map)['card'] as Map),
      ),
    );
  }

  /// Pouvoir 8 : espionner une carte adverse. Même format de réponse que
  /// [powerSelfPeek] (`{ card: {...} }`, privé).
  Future<CardModel> powerSpy({
    required String gameId,
    required String playerId,
    required String opponentId,
    required int opponentPosition,
    Duration timeout = const Duration(seconds: 8),
  }) {
    return _emitAndAwaitOnce<CardModel>(
      emitEvent: 'power_target',
      emitPayload: {
        'gameId': gameId,
        'playerId': playerId,
        'powerRank': 8,
        'targetPlayerId': opponentId,
        'targetPosition': opponentPosition,
      },
      responseEvent: 'power:target_selected',
      timeout: timeout,
      mapResponse: (payload) => _cardFromJson(
        Map<String, dynamic>.from((payload as Map)['card'] as Map),
      ),
    );
  }

  /// Pouvoir 9 : échange aveugle. Réponse BROADCAST (`isPrivate: false`
  /// côté backend), payload `{ swapped: {...} }` — aucune carte révélée,
  /// on ignore le contenu, on attend juste la confirmation.
  Future<void> powerBlindSwap({
    required String gameId,
    required String playerId,
    required int ownPosition,
    required String opponentId,
    required int opponentPosition,
    Duration timeout = const Duration(seconds: 8),
  }) async {
    await _emitAndAwaitOnce<bool>(
      emitEvent: 'power_target',
      emitPayload: {
        'gameId': gameId,
        'playerId': playerId,
        'powerRank': 9,
        'targetPlayerId': playerId,
        'targetPosition': ownPosition,
        'secondTargetPlayerId': opponentId,
        'secondTargetPosition': opponentPosition,
      },
      responseEvent: 'power:target_selected',
      timeout: timeout,
      mapResponse: (_) => true,
    );
  }

  /// Helper générique : émet un event, attend le PREMIER event de retour
  /// correspondant, avec timeout — ET échoue immédiatement si le serveur
  /// répond par `error` (ex: "pas votre tour") plutôt que d'attendre les
  /// 8 secondes du timeout pour rien.
  Future<T> _emitAndAwaitOnce<T>({
    required String emitEvent,
    required Map<String, dynamic> emitPayload,
    required String responseEvent,
    required T Function(dynamic payload) mapResponse,
    required Duration timeout,
  }) {
    final completer = Completer<T>();
    late final StreamSubscription sub;
    late final StreamSubscription errSub;

    void cancelAll() {
      sub.cancel();
      errSub.cancel();
    }

    sub = _socket.on(responseEvent, (payload) => payload).listen(
      (payload) {
        if (!completer.isCompleted) {
          try {
            completer.complete(mapResponse(payload));
          } catch (e) {
            completer.completeError(e);
          }
        }
        cancelAll();
      },
      onError: (Object e) {
        if (!completer.isCompleted) completer.completeError(e);
        cancelAll();
      },
    );

    // `error` est émis en privé (`client.emit`) uniquement au socket
    // responsable de la requête fautive — sûr d'écouter ici sans risquer
    // d'intercepter l'erreur d'un autre joueur.
    errSub = _socket.on('error', (payload) => payload).listen((payload) {
      if (!completer.isCompleted) {
        final message = (payload as Map)['message']?.toString() ?? 'Erreur inconnue.';
        completer.completeError(GameActionException(message));
      }
      cancelAll();
    });

    _socket.emit(emitEvent, emitPayload);

    return completer.future.timeout(
      timeout,
      onTimeout: () {
        cancelAll();
        throw TimeoutException('Pas de réponse du serveur pour "$emitEvent".');
      },
    );
  }

  CardModel _cardFromJson(Map<String, dynamic> json) {
    try {
      return CardModel.fromJson(json);
    } catch (_) {
      return CardModel(
        id: json['id'] as String,
        rank: json['rank'] as String?,
        suit: json['suit'] as String?,
        hidden: json['hidden'] as bool? ?? (json['rank'] == null),
      );
    }
  }
}