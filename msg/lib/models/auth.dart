import 'user.dart';

class AuthResponse {
  final String token;
  final User? user; // Hacer opcional ya que backend no lo devuelve en login

  AuthResponse({required this.token, this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['access_token'],
      user: json['user'] != null ? User.fromJson(json['user']) : null, // Puede ser null
    );
  }
}
