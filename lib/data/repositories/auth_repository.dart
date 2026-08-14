import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/api_client.dart';
import '../models/auth_user_model.dart';

/// Résultat d'un register/login réussi (miroir de `buildAuthResponse`).
class AuthResult {
  final String accessToken;
  final AuthUser user;
  AuthResult({required this.accessToken, required this.user});

  factory AuthResult.fromJson(Map<String, dynamic> json) => AuthResult(
        accessToken: json['accessToken'] as String,
        user: AuthUser.fromJson(Map<String, dynamic>.from(json['user'])),
      );
}

class AuthRepository {
  static const _tokenKey = 'auth_token';
  static const _userIdKey = 'auth_user_id';
  static const _emailKey = 'auth_email';
  static const _displayNameKey = 'auth_display_name';

  final ApiClient _api;

  AuthRepository(this._api);

  Future<AuthResult> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final json = await _api.post('/auth/register', body: {
      'email': email,
      'password': password,
      'displayName': displayName,
    });
    final result = AuthResult.fromJson(Map<String, dynamic>.from(json));
    await _persistSession(result);
    return result;
  }

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final json = await _api.post('/auth/login', body: {
      'email': email,
      'password': password,
    });
    final result = AuthResult.fromJson(Map<String, dynamic>.from(json));
    await _persistSession(result);
    return result;
  }

  /// Restaure une session sauvegardée localement (au lancement de l'app),
  /// pour éviter de redemander le login à chaque redémarrage.
  /// ⚠️ Pas de route `/auth/me` côté backend pour valider le token : on le
  /// considère valide jusqu'à preuve du contraire (un 401 sur une requête
  /// authentifiée devra alors forcer un logout — à gérer au niveau de
  /// l'ApiClient si besoin plus tard).
  Future<AuthUser?> tryRestoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final userId = prefs.getString(_userIdKey);
    final email = prefs.getString(_emailKey);
    final displayName = prefs.getString(_displayNameKey);

    if (token == null || userId == null || email == null || displayName == null) {
      return null;
    }

    _api.setToken(token);
    return AuthUser(id: userId, email: email, displayName: displayName);
  }

  Future<void> logout() async {
    _api.setToken(null);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_displayNameKey);
  }

  Future<void> _persistSession(AuthResult result) async {
    _api.setToken(result.accessToken);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, result.accessToken);
    await prefs.setString(_userIdKey, result.user.id);
    await prefs.setString(_emailKey, result.user.email);
    await prefs.setString(_displayNameKey, result.user.displayName);
  }
}