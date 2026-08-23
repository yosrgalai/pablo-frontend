import 'package:flutter/material.dart';

import '../di/injector.dart';
import '../network/socket_service.dart';
import '../theme/app_theme.dart';

/// Bannière globale affichée en haut de l'écran quand le socket est
/// déconnecté, quel que soit l'écran actif (Home, Lobby, ou en partie).
/// Branchée une seule fois via `MaterialApp.builder` dans app.dart.
class ConnectionStatusBanner extends StatelessWidget {
  final Widget? child;
  const ConnectionStatusBanner({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final socket = getIt<SocketService>();
    return StreamBuilder<bool>(
      stream: socket.connectionStream,
      initialData: socket.isConnected,
      builder: (context, snapshot) {
        final connected = snapshot.data ?? true;
        return Column(
          children: [
            if (!connected) const _ReconnectingBar(),
            Expanded(child: child ?? const SizedBox()),
          ],
        );
      },
    );
  }
}

class _ReconnectingBar extends StatelessWidget {
  const _ReconnectingBar();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.danger,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 10),
              Text(
                'Connexion perdue — reconnexion en cours...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}