import 'package:get_it/get_it.dart';

import '../network/api_client.dart';
import '../network/socket_service.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/game_repository.dart';
import '../../features/auth_lobby/bloc/auth_cubit.dart';
import '../../features/auth_lobby/bloc/lobby_bloc.dart';

final getIt = GetIt.instance;

/// À appeler une fois dans main() avant runApp().
///
/// [apiBaseUrl] : racine REST du backend NestJS, ex 'http://localhost:3000'
/// (sans suffixe — les routes /auth, /games sont à la racine).
/// [socketUrl] : URL du namespace socket du Gateway, ex
/// 'http://localhost:3000/game' (⚠️ le Gateway déclare
/// `@WebSocketGateway({ namespace: '/game' })`, le suffixe est obligatoire).
void setupInjector({
  required String apiBaseUrl,
  required String socketUrl,
}) {
  getIt.registerLazySingleton<ApiClient>(() => ApiClient(baseUrl: apiBaseUrl));

  getIt.registerLazySingleton<SocketService>(() {
    final service = SocketService();
    service.connect(url: socketUrl);
    return service;
  });

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<GameRepository>(
    () => GameRepository(getIt<ApiClient>(), getIt<SocketService>()),
  );

  // Singleton : l'état d'auth doit survivre à toute l'app, pas être
  // recréé à chaque écran.
  getIt.registerLazySingleton<AuthCubit>(
    () => AuthCubit(getIt<AuthRepository>()),
  );

  // Factory : un LobbyBloc frais à chaque entrée dans le flow lobby.
  getIt.registerFactory<LobbyBloc>(
    () => LobbyBloc(getIt<GameRepository>()),
  );
}