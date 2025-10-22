import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/chat_service.dart';
import '../services/socket_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;
  final AuthService _authService = AuthService();
  final ChatService _chatService = ChatService();
  final SocketService _socketService = SocketService();

  User? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _token != null;

  // Login
  Future<bool> login(String credential, String password) async {
    final response = await _authService.login(credential, password);
    if (response != null) {
      _token = response.token;
      // Obtener usuario actual después del login
      if (_token != null) {
        _user = await _authService.getCurrentUser(_token!);
        print('Usuario obtenido después de login: ID ${_user?.id}, Email ${_user?.email}'); // Debug
      }
      print('Login exitoso: Usuario ID ${_user?.id}, Email ${_user?.email}'); // Debug
      await _authService.saveToken(_token!);
      _socketService.connect(_token!); // Conectar WebSocket al login
      notifyListeners();
      return true;
    }
    return false;
  }

  // Registro
  Future<String?> register(String? email, String? phone, String username, String password) async {
    final error = await _authService.register(email, phone, username, password);
    if (error == null) {
      // Éxito: asumir que _authService ya maneja el estado, o agregar lógica aquí
      notifyListeners();
      return null;
    }
    return error; // Devolver mensaje de error
  }

  // Logout
  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _token = null;
    notifyListeners();
    print('Logout exitoso'); // Debug
  }

  // Inicializar (cargar token al inicio)
  Future<void> initialize() async {
    _token = await _authService.getToken();
    if (_token != null) {
      _socketService.connect(_token!); // Reconectar si hay token
      notifyListeners();
    }
  }

  // Acceso a servicios (para otros providers o pantallas)
  ChatService get chatService => _chatService;
  SocketService get socketService => _socketService;
}
