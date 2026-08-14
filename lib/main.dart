import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/injector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // NOTE pour la binôme : ton TestApp verrouillait l'orientation en
  // paysage dès main(). Je l'ai retiré ici car ça casserait les écrans de
  // lobby/login (portrait, cf. maquette El Bat7a). Le verrouillage paysage
  // doit plutôt être local à game_table_screen (initState() -> lock,
  // dispose() -> reset). Je le laisse en commentaire pour référence :
  //
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.landscapeLeft,
  //   DeviceOrientation.landscapeRight,
  // ]);

  // Racine REST du backend (routes /auth, /games...).
  // - Web / iOS simulator : localhost fonctionne tel quel.
  // - Émulateur Android : remplace par 10.0.2.2.
  // - Appareil physique : IP locale de ta machine (ex: 192.168.x.x).
  const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  // ⚠️ Le GameGateway déclare namespace: '/game' côté serveur — le
  // suffixe est obligatoire, sinon le socket se connecte au namespace
  // par défaut où aucun handler n'existe.
  const socketUrl = String.fromEnvironment(
    'SOCKET_URL',
    defaultValue: 'http://localhost:3000/game',
  );

  setupInjector(apiBaseUrl: apiBaseUrl, socketUrl: socketUrl);

  runApp(const PabloApp());
}