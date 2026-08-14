import 'package:equatable/equatable.dart';

/// Miroir de `buildAuthResponse().user` côté backend (auth.service.ts).
class AuthUser extends Equatable {
  final String id;
  final String email;
  final String displayName;

  const AuthUser({
    required this.id,
    required this.email,
    required this.displayName,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: json['id'] as String,
        email: json['email'] as String,
        displayName: json['displayName'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'displayName': displayName,
      };

  @override
  List<Object?> get props => [id, email, displayName];
}