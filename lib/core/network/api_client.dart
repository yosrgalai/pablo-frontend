import 'dart:convert';
import 'package:http/http.dart' as http;

/// Exception levée pour toute réponse HTTP en erreur (4xx/5xx).
/// [message] vient du body JSON du backend NestJS (`{ message: "..." }`,
/// forme standard des exceptions Nest : ConflictException,
/// UnauthorizedException, etc.)
class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Wrapper HTTP générique pour toutes les routes REST du backend
/// (auth, games...). Garde le token JWT en mémoire et l'attache
/// automatiquement aux requêtes une fois connecté.
class ApiClient {
  final String baseUrl;
  final http.Client _client;
  String? _token;

  ApiClient({required this.baseUrl, http.Client? client})
      : _client = client ?? http.Client();

  void setToken(String? token) => _token = token;
  bool get isAuthenticated => _token != null;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  Future<dynamic> get(String path) async {
    final res = await _client.get(Uri.parse('$baseUrl$path'), headers: _headers);
    return _handle(res);
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? body}) async {
    final res = await _client.post(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
      body: body != null ? jsonEncode(body) : null,
    );
    return _handle(res);
  }

  dynamic _handle(http.Response res) {
    final isJson = res.body.isNotEmpty;
    final decoded = isJson ? jsonDecode(res.body) : null;

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return decoded;
    }

    final message = (decoded is Map && decoded['message'] != null)
        ? (decoded['message'] is List
            ? (decoded['message'] as List).join(', ')
            : decoded['message'].toString())
        : 'Erreur serveur (${res.statusCode})';

    throw ApiException(res.statusCode, message);
  }
}