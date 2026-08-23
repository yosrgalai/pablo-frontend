import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injector.dart';
import 'core/theme/app_theme.dart';
import 'features/auth_lobby/bloc/auth_cubit.dart';
import 'features/auth_lobby/bloc/lobby_bloc.dart';
import 'features/auth_lobby/screens/home_screen.dart';
import 'features/auth_lobby/screens/login_screen.dart';

import 'core/widgets/connection_status_banner.dart';
/// Racine de l'application.
///
/// Fournit les Bloc/Cubit globaux (AuthCubit singleton, LobbyBloc — le
/// GameBloc viendra s'ajouter ici, en commentaire ci-dessous, une fois
/// branché) et le thème partagé de la plateforme El Bat7a.
class PabloApp extends StatelessWidget {
  const PabloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: getIt<AuthCubit>()),
        BlocProvider<LobbyBloc>(create: (_) => getIt<LobbyBloc>()),
        // BlocProvider<GameBloc>(create: (_) => getIt<GameBloc>()),
      ],
      child: MaterialApp(
        title: 'Pablo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        builder: (context, child) => ConnectionStatusBanner(child: child),
        home: const AuthGate(),
      ),
    );
  }
}

/// Décide Login vs Home selon l'état d'auth. Tente de restaurer une
/// session sauvegardée (shared_preferences) au tout premier lancement.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().restoreSession();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return const HomeScreen();
        }
        if (state is AuthInitial || state is AuthLoading) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            ),
          );
        }
        return const LoginScreen();
      },
    );
  }
}