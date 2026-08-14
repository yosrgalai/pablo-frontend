import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app.dart';
import '../di/injector.dart';

Future<void> bootstrapApp() async {
  // L'app démarre directement dans l'expérience de production.
  // Les écrans de jeu gèrent eux-mêmes l'orientation quand c'est nécessaire.

  const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  const socketUrl = String.fromEnvironment(
    'SOCKET_URL',
    defaultValue: 'http://localhost:3000/game',
  );

  setupInjector(apiBaseUrl: apiBaseUrl, socketUrl: socketUrl);

  await SystemChrome.setPreferredOrientations(const [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const PabloApp());
}