class AppConfig {
  // Configuración de URLs del backend
  static const String baseUrl = 'https://dynamic-dedication-production.up.railway.app';
  static const String authUrl = '$baseUrl/auth';
  static const String usersUrl = '$baseUrl/users';
  static const String chatsUrl = '$baseUrl/chats';
  static const String messagesUrl = '$baseUrl/messages';
  static const String uploadUrl = '$baseUrl/upload';
  static const String socketUrl = baseUrl; // Para WebSocket

  // Configuración de la aplicación
  static const String appName = 'MSG';
  static const String version = '1.0.0';

  // Configuración de debug
  static const bool debugMode = false; // Cambiar a true para desarrollo

  // Configuración de timeouts (en segundos)
  static const int httpTimeout = 30;
  static const int socketTimeout = 10;

  // Configuración de retry
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
}
