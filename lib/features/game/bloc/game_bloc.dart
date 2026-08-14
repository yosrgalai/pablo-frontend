import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/card_model.dart';
import '../../../data/repositories/game_repository.dart';

part 'game_event.dart';
part 'game_state.dart';

/// Squelette de la state machine de partie (Dev A), en miroir de
/// `GameRoundState` côté backend : DEALING -> INITIAL_PEEK -> PLAYER_TURN
/// -> ROUND_SCORING -> GAME_OVER (PABLO_CALLED et NEXT_ROUND sont
/// représentés comme des variations de PLAYER_TURN/ROUND_SCORING ici,
/// plutôt que des states séparés, pour rester simple tant que le détail
/// fin du plateau n'est pas branché).
///
/// ⚠️ Ce Bloc ne gère PAS le détail des tours (piocher/échanger/défausser/
/// pouvoirs/paires) : c'est le terrain de Dev B (CardService côté
/// backend, widgets cartes côté frontend). Il fournit juste le squelette
/// de navigation + le strict nécessaire pour le peek initial et le bouton
/// Pablo, qui sont dans le périmètre Dev A.
class GameBloc extends Bloc<GameEvent, GameState> {
  final GameRepository _gameRepository;
  final String gameId;
  final String localPlayerId;

  StreamSubscription<List<CardModel>>? _handPositionsSub;
  StreamSubscription<List<CardModel>>? _peekedInitialSub;
  StreamSubscription<String>? _turnStartedSub;
  StreamSubscription<String>? _caboCalledSub;
  StreamSubscription<Map<String, dynamic>>? _roundEndedSub;
  StreamSubscription<Map<String, dynamic>>? _gameEndedSub;
  StreamSubscription<String>? _errorSub;

  GameBloc(
    this._gameRepository, {
    required this.gameId,
    required this.localPlayerId,
  }) : super(const GameDealingState()) {
    on<GameStarted>(_onStarted);
    on<GameHandPositionsReceived>(_onHandPositionsReceived);
    on<GamePeekPositionToggled>(_onPeekPositionToggled);
    on<GameConfirmInitialPeekPressed>(_onConfirmInitialPeekPressed);
    on<GamePeekedInitialReceived>(_onPeekedInitialReceived);
    on<GameTurnStartedReceived>(_onTurnStartedReceived);
    on<GameCallPabloPressed>(_onCallPabloPressed);
    on<GameCaboCalledReceived>(_onCaboCalledReceived);
    on<GameRoundEndedReceived>(_onRoundEndedReceived);
    on<GameEndedReceived>(_onEndedReceived);
    on<GameSocketErrorReceived>(_onSocketErrorReceived);
  }

  void _onStarted(GameStarted event, Emitter<GameState> emit) {
    _handPositionsSub = _gameRepository.onHandPositionsReady
        .listen((cards) => add(GameHandPositionsReceived(cards)));
    _peekedInitialSub = _gameRepository.onPeekedInitial
        .listen((cards) => add(GamePeekedInitialReceived(cards)));
    _turnStartedSub = _gameRepository.onTurnStarted
        .listen((playerId) => add(GameTurnStartedReceived(playerId)));
    _caboCalledSub = _gameRepository.onCaboCalled
        .listen((playerId) => add(GameCaboCalledReceived(playerId)));
    _roundEndedSub = _gameRepository.onRoundEnded
        .listen((payload) => add(GameRoundEndedReceived(payload)));
    _gameEndedSub = _gameRepository.onGameEnded
        .listen((payload) => add(GameEndedReceived(payload)));
    _errorSub = _gameRepository.onError
        .listen((msg) => add(GameSocketErrorReceived(msg)));

    // Filet de sécurité : le serveur envoie hand:positions automatiquement
    // juste après le dealing, mais si notre écoute démarre une fraction de
    // seconde trop tard on peut le manquer -> on le redemande activement.
    _gameRepository.requestHandPositions(gameId: gameId, playerId: localPlayerId);
  }

  void _onHandPositionsReceived(
    GameHandPositionsReceived event,
    Emitter<GameState> emit,
  ) {
    // Ignore les envois redondants une fois qu'on a avancé au-delà du peek.
    if (state is GameDealingState) {
      emit(GameInitialPeekState(positions: event.positions));
    }
  }

  void _onPeekPositionToggled(
    GamePeekPositionToggled event,
    Emitter<GameState> emit,
  ) {
    final current = state;
    if (current is! GameInitialPeekState || current.confirmed) return;

    final updated = Set<int>.from(current.selected);
    if (updated.contains(event.position)) {
      updated.remove(event.position);
    } else if (updated.length < 2) {
      updated.add(event.position);
    }
    // Si déjà 2 sélectionnées et qu'on tape une 3e position différente,
    // on ignore (le joueur doit d'abord désélectionner) plutôt que de
    // remplacer silencieusement son choix.

    emit(current.copyWith(selected: updated));
  }

  void _onConfirmInitialPeekPressed(
    GameConfirmInitialPeekPressed event,
    Emitter<GameState> emit,
  ) {
    final current = state;
    if (current is! GameInitialPeekState) return;
    if (current.selected.length != 2 || current.confirmed) return;

    _gameRepository.chooseInitialPeek(
      gameId: gameId,
      playerId: localPlayerId,
      positions: current.selected.toList()..sort(),
    );
    emit(current.copyWith(confirmed: true));
  }

  void _onPeekedInitialReceived(
    GamePeekedInitialReceived event,
    Emitter<GameState> emit,
  ) {
    emit(GameWaitingOthersPeekState(event.revealedCards));
  }

  void _onTurnStartedReceived(
    GameTurnStartedReceived event,
    Emitter<GameState> emit,
  ) {
    final current = state;
    if (current is GamePlayerTurnState) {
      emit(current.copyWith(currentPlayerId: event.currentPlayerId));
    } else {
      emit(GamePlayerTurnState(
        currentPlayerId: event.currentPlayerId,
        localPlayerId: localPlayerId,
      ));
    }
  }

  void _onCallPabloPressed(
    GameCallPabloPressed event,
    Emitter<GameState> emit,
  ) {
    final current = state;
    if (current is GamePlayerTurnState && current.isLocalTurn) {
      _gameRepository.callPablo(gameId: gameId, playerId: localPlayerId);
    }
  }

  void _onCaboCalledReceived(
    GameCaboCalledReceived event,
    Emitter<GameState> emit,
  ) {
    final current = state;
    if (current is GamePlayerTurnState) {
      emit(current.copyWith(pabloCalled: true, pabloCallerId: event.playerId));
    }
  }

  void _onRoundEndedReceived(
    GameRoundEndedReceived event,
    Emitter<GameState> emit,
  ) {
    emit(GameRoundScoringState(event.payload));
  }

  void _onEndedReceived(GameEndedReceived event, Emitter<GameState> emit) {
    emit(GameOverState(event.payload));
  }

  void _onSocketErrorReceived(
    GameSocketErrorReceived event,
    Emitter<GameState> emit,
  ) {
    emit(GameErrorState(event.message));
  }

  @override
  Future<void> close() {
    _handPositionsSub?.cancel();
    _peekedInitialSub?.cancel();
    _turnStartedSub?.cancel();
    _caboCalledSub?.cancel();
    _roundEndedSub?.cancel();
    _gameEndedSub?.cancel();
    _errorSub?.cancel();
    return super.close();
  }
}