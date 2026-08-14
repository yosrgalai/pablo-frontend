import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/network/api_client.dart';
import '../../../data/models/auth_user_model.dart';
import '../../../data/repositories/auth_repository.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final AuthUser user;
  const AuthAuthenticated(this.user);
  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  final String? errorMessage;
  const AuthUnauthenticated({this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}

/// Cubit simple (pas besoin d'Events séparés ici, le flow est basique :
/// login, register, logout, restauration de session au démarrage).
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(const AuthInitial());

  Future<void> restoreSession() async {
    emit(const AuthLoading());
    final user = await _authRepository.tryRestoreSession();
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(const AuthLoading());
    try {
      final result = await _authRepository.login(email: email, password: password);
      emit(AuthAuthenticated(result.user));
    } on ApiException catch (e) {
      emit(AuthUnauthenticated(errorMessage: e.message));
    } catch (_) {
      emit(const AuthUnauthenticated(
        errorMessage: 'Impossible de se connecter. Vérifie ta connexion.',
      ));
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    emit(const AuthLoading());
    try {
      final result = await _authRepository.register(
        email: email,
        password: password,
        displayName: displayName,
      );
      emit(AuthAuthenticated(result.user));
    } on ApiException catch (e) {
      emit(AuthUnauthenticated(errorMessage: e.message));
    } catch (_) {
      emit(const AuthUnauthenticated(
        errorMessage: 'Impossible de créer le compte. Vérifie ta connexion.',
      ));
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    emit(const AuthUnauthenticated());
  }
}