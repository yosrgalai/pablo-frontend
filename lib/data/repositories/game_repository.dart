import 'dart:async';

import '../../core/network/api_client.dart';
import '../../core/network/socket_service.dart';
import '../models/card_model.dart';
import '../models/player_model.dart';

/// Résumé d'une partie ouverte, retourné par GET /games/open.
class OpenGameSummary {
  final String gameId;
  final int scoreLimit;
  final String hostName;
  final int playerCount;
  final int maxPlayers;

  OpenGameSummary({
    required this.gameId,
    required this.scoreLimit,
    required this.hostName,
    required this.playerCount,
    required this.maxPlayers,
  });

  factory OpenGameSummary.fromJson(Map<String, dynamic> json) => OpenGameSummary(
        gameId: json['gameId'] as String,
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

  /// Miroir de la réponse de POST /games (GameService.createGame) :
  /// { gameId, scoreLimit, state, roundId, hostPlayerId, players: [{id,name}] }
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

  /// Miroir de GET /games/:id (Prisma `Game` avec `include: { players: true }`).
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
PlayerModel _playerFromRestJson(
  Map<String, dynamic> json, {
  required String? hostPlayerId,
}) {
  final id = json['id'] as String;
  return PlayerModel(
    id: id,
    name: json['name'] as String? ?? '?',
    isHost: hostPlayerId != null && id == hostPlayerId,
    // Pas de notion de "ready" côté backend — champ gardé à false, non
    // utilisé pour l'affichage (voir isConnected à la place).
    isReady: false,
    handSize: 0,
    hand: const [],
    isConnected: json['isConnected'] as bool? ?? false,
    isCurrentTurn: false,
    hasCalledPablo: json['hasCalledPablo'] as bool? ?? false,
    totalScore: json['score'] as int? ?? 0,
  );
}

/// Traduit les appels REST (création/jonction/liste de parties) et les
/// events du namespace socket `/game` en objets Dart.
///
/// Rappel architecture (confirmé avec le backend réel) :
/// - Créer / rejoindre une partie = REST (`POST /games`, `POST /games/:id/join`),
///   authentifié par JWT (géré par ApiClient).
/// - Le socket ne sert QU'à synchroniser la connexion à la room
///   (`join_game`) et à démarrer la partie (`start_game`) — pas à devenir
///   joueur.
class GameRepository {
  final ApiClient _api;
  final SocketService _socket;

  GameRepository(this._api, this._socket);

  Future<GameSnapshot> createGame({required int scoreLimit}) async {
    final json = await _api.post('/games', body: {'scoreLimit': scoreLimit});
    return GameSnapshot.fromCreateResponse(Map<String, dynamic>.from(json));
  }

  /// Rejoint via REST puis re-fetch l'état complet (POST /games/:id/join
  /// ne renvoie que { playerId, gameId, name }, pas la liste des joueurs).
  /// Retourne le snapshot ET le playerId local (le plus fiable — on ne
  /// déduit jamais "qui est moi" par nom, plusieurs joueurs pouvant
  /// partager le même displayName).
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

  /// Émet `join_game` sur le namespace /game pour synchroniser la
  /// connexion socket à la room. Résout quand le serveur confirme via
  /// `game:joined` (émis au client lui-même, pas broadcast).
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

  /// Démarre la partie (hôte uniquement — vérifié côté serveur). Aucun ack
  /// direct : le succès se traduit par un `game:dealt` broadcasté à la
  /// room ; l'échec (ex: pas hôte, <2 joueurs connectés) arrive via
  /// l'event générique `error`.
  void startGame({required String gameId, required String playerId}) {
    _socket.emit('start_game', {'gameId': gameId, 'playerId': playerId});
  }

  /// `game:dealt` — la partie a démarré, distribution en cours.
  Stream<void> get onGameDealt => _socket.on('game:dealt', (_) {});

  /// Event générique d'erreur métier (mêmes canal pour "pas hôte",
  /// "déconnexion d'un joueur", etc. côté backend actuel — le message
  /// texte est la seule info disponible pour l'instant).
  Stream<String> get onError => _socket.on(
        'error',
        (payload) => (payload as Map)['message']?.toString() ?? 'Erreur inconnue.',
      );

  // ---------------------------------------------------------------------
  // Partie en cours (namespace /game) — squelette de la state machine
  // DEALING -> INITIAL_PEEK -> PLAYER_TURN -> ... (Dev A). Les
  // interactions détaillées d'un tour (swap/discard/paires/pouvoirs)
  // restent gérées par le GameBloc/les widgets de Dev B.
  // ---------------------------------------------------------------------

  /// (Re)demande les 4 positions de la main locale (sans valeurs). Utile
  /// en filet de sécurité si l'event privé auto-envoyé après le dealing a
  /// pu être manqué (souscription pas encore active à ce moment-là).
  void requestHandPositions({required String gameId, required String playerId}) {
    _socket.emit('get_hand_positions', {'gameId': gameId, 'playerId': playerId});
  }

  /// `hand:positions` — les 4 cartes de la main locale, position = index
  /// dans la liste, valeurs cachées (rank/suit null, hidden true).
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

  /// `player:peeked_initial` — les 2 cartes choisies, révélées (privé).
  Stream<List<CardModel>> get onPeekedInitial => _socket.on(
        'player:peeked_initial',
        (payload) => ((payload as Map)['cards'] as List)
            .map((c) => _cardFromJson(Map<String, dynamic>.from(c)))
            .toList(),
      );

  /// `turn:started` — tous les joueurs ont fait leur peek initial (ou
  /// tour suivant en PLAYER_TURN) : renvoie le playerId dont c'est le tour.
  Stream<String> get onTurnStarted => _socket.on(
        'turn:started',
        (payload) => (payload as Map)['playerId'] as String,
      );

  void callPablo({required String gameId, required String playerId}) {
    _socket.emit('call_pablo', {'gameId': gameId, 'playerId': playerId});
  }

  /// `cabo:called` — un joueur (potentiellement soi-même) a annoncé Pablo.
  Stream<String> get onCaboCalled => _socket.on(
        'cabo:called',
        (payload) => (payload as Map)['playerId'] as String,
      );

  /// `round:ended` — fin de manche, payload brut (contient `roundScores`,
  /// cf. GameGateway.emitTurnAdvanced). Laissé en Map générique : le détail
  /// fin (par carte/joueur) est affiné avec Dev B au besoin.
  Stream<Map<String, dynamic>> get onRoundEnded => _socket.on(
        'round:ended',
        (payload) => Map<String, dynamic>.from(payload as Map),
      );

  /// `game:ended` — partie terminée, `{ winner: {...} }`.
  Stream<Map<String, dynamic>> get onGameEnded => _socket.on(
        'game:ended',
        (payload) => Map<String, dynamic>.from(payload as Map),
      );

  /// Le JSON de carte pendant INITIAL_PEEK peut ne pas inclure rank/suit
  /// (carte cachée) — CardModel.fromJson (json_serializable) exige les
  /// clés du contrat ; si jamais le backend omet 'hidden' pour une carte
  /// non révélée, on retombe sur une construction manuelle plutôt que de
  /// planter toute la liste pour un champ manquant.
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