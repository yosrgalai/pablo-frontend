import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as io;

/// Enveloppe fine autour de socket_io_client.
///
/// Objectif : que le reste du code (repositories, bloc) n'ait jamais besoin
/// d'importer `socket_io_client` directement. On expose :
///  - connect / disconnect
///  - emit (fire-and-forget)
///  - emitWithAck (attend la réponse du serveur via callback ack — utile pour
///    game:create / game:join qui doivent renvoyer un gameId / code)
///  - on<T> : Stream typée pour écouter un event serveur en continu
class SocketService {
  io.Socket? _socket;
  final _connectionController = StreamController<bool>.broadcast();

  /// Stream(true/false) de l'état de connexion, utile pour afficher un
  /// indicateur "reconnexion en cours" dans l'UI.
  Stream<bool> get connectionStream => _connectionController.stream;

  bool get isConnected => _socket?.connected ?? false;

  void connect({
    required String url,
    String? authToken,
  }) {
    _socket?.dispose();

    _socket = io.io(
      url,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setReconnectionAttempts(10)
          .setReconnectionDelay(1000)
          .setAuth(authToken != null ? {'token': authToken} : {})
          .build(),
    );

    _socket!
      ..onConnect((_) => _connectionController.add(true))
      ..onDisconnect((_) => _connectionController.add(false))
      ..onConnectError((err) => _connectionController.add(false))
      ..connect();
  }

  void disconnect() {
    _socket?.disconnect();
  }

  void dispose() {
    _socket?.dispose();
    _connectionController.close();
  }

  /// Émission simple, sans attendre de réponse (ex: player:ready).
  void emit(String event, [dynamic data]) {
    _socket?.emit(event, data);
  }

  /// Émission avec accusé de réception (ack) côté serveur.
  /// Utile pour game:create / game:join, qui doivent renvoyer un résultat
  /// (ex: { gameId, code }) directement en réponse à l'appel, sans event
  /// serveur→client dédié dans le contrat.
  Future<Map<String, dynamic>> emitWithAck(
    String event, {
    dynamic data,
    Duration timeout = const Duration(seconds: 6),
  }) {
    final completer = Completer<Map<String, dynamic>>();

    _socket?.emitWithAck(event, data, ack: (response) {
      if (completer.isCompleted) return;
      if (response is Map) {
        completer.complete(Map<String, dynamic>.from(response));
      } else {
        completer.complete(<String, dynamic>{});
      }
    });

    return completer.future.timeout(
      timeout,
      onTimeout: () => throw TimeoutException(
        'Pas de réponse du serveur pour "$event"',
      ),
    );
  }

  /// Stream typée pour un event serveur→client donné.
  /// [mapper] transforme le payload brut (dynamic/Map) en objet Dart.
  Stream<T> on<T>(String event, T Function(dynamic payload) mapper) {
    final controller = StreamController<T>.broadcast();

    void handler(dynamic payload) {
      try {
        // Sur Flutter Web, socket_io_client passe parfois le payload
        // encapsulé dans une List (ex: [ {gameId:...} ]) au lieu du Map
        // direct qu'on reçoit sur mobile/desktop. On normalise ici pour
        // que tous les appelants (mapper) reçoivent toujours la même
        // forme, quelle que soit la plateforme.
        final normalized =
            (payload is List && payload.isNotEmpty) ? payload.first : payload;
        controller.add(mapper(normalized));
      } catch (e) {
        controller.addError(e);
      }
    }

    _socket?.on(event, handler);

    controller.onCancel = () {
      _socket?.off(event, handler);
    };

    return controller.stream;
  }
}