import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth.dart';
import '../models/user.dart';
import 'socket_service.dart'; // Importar SocketService

class AuthService {
  static const String baseUrl = 'http://localhost:3000/auth'; // Cambia si tu backend tiene otra URL
  final SocketService _socketService = SocketService(); // Instancia para desconectar

  // Registro
  Future<String?> register(String? email, String? phone, String username, String password) async {
    final Map<String, dynamic> body = {'username': username, 'password': password};
    if (email != null) body['email'] = email;
    if (phone != null) body['phone'] = phone;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print('Registro - Status: ${response.statusCode}, Body: ${response.body}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return null;
      } else {
        final errorData = jsonDecode(response.body);
        return errorData['message']?.join(', ') ?? 'Registration failed';
      }
    } catch (e) {
      return 'Network error: $e';
    }
  }

  // Login
  Future<AuthResponse?> login(String credential, String password) async {
    // Detectar si es email o teléfono
    final isEmail = credential.contains('@');
    final Map<String, dynamic> body = {'password': password};
    if (isEmail) {
      body['email'] = credential;
      print('Enviando login con email: $credential');
    } else {
      if (credential.length < 10) {
        print('Teléfono inválido: debe tener al menos 10 caracteres');
        return null;
      }
      body['phone'] = credential;
      print('Enviando login con teléfono: $credential');
    }
    print('Body enviado al backend: ${jsonEncode(body)}');

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print('Login - Status: ${response.statusCode}, Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('Login exitoso, token recibido');
        return AuthResponse.fromJson(data);
      } else {
        print('Login fallido: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error en login: $e');
      return null;
    }
  }

  // Almacenar JWT localmente
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Obtener JWT almacenado
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Obtener usuario actual
  Future<User?> getCurrentUser(String token) async {
    try {
      // Intentar obtener del backend primero
      print('getCurrentUser - Intentando obtener usuario del backend...');
      final response = await http.get(
        Uri.parse('http://localhost:3000/users/me'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('getCurrentUser - Respuesta del backend - Status: ${response.statusCode}');
      print('getCurrentUser - Body: ${response.body}');

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        try {
          final data = jsonDecode(response.body);
          print('getCurrentUser - Datos del usuario: $data');
          final user = User.fromJson(data);
          print('getCurrentUser - Usuario parseado: ${user.name} (${user.email})');
          return user;
        } catch (e) {
          print('getCurrentUser - Error al parsear respuesta del backend: $e');
        }
      } else {
        print('getCurrentUser - Error en la respuesta del backend. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('getCurrentUser - Error al obtener usuario del backend: $e');
    }

    // Fallback: decodificar token JWT
    print('getCurrentUser - Usando decodificado de token como fallback');
    return _decodeToken(token);
  }

  // Decodificar token JWT para obtener usuario (alternativa)
  User? _decodeToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final Map<String, dynamic> data = jsonDecode(decoded);
      
      // Usar 'name' si está disponible, de lo contrario 'username', o 'Unknown' si ninguno existe
      final name = data['name'] ?? data['username'] ?? 'Unknown';
      print('_decodeToken - Decoded user data: $data, resolved name: $name');

      return User(
        id: data['sub']?.toString() ?? '',
        email: data['email']?.toString() ?? '',
        name: name,
      );
    } catch (e) {
      print('Error decodificando token: $e');
      return null;
    }
  }

  // Cerrar sesión
  Future<void> logout() async {
    _socketService.disconnect(); // Desconectar WebSocket
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
