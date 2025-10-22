import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/message.dart';

class SocketService {
  late IO.Socket socket;
  bool _isConnected = false; // Bandera para verificar inicialización

  Function(Message)? onMessageReceived;
  Function(String)? onUserTyping;
  Function(String)? onMessageRead; // New callback for message read status updates

  void connect(String token) {
    socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {'token': token},
    });

    socket.connect();
    _isConnected = true; // Marcar como conectado

    socket.on('connect', (_) => print('Connected to WebSocket'));
    socket.on('disconnect', (_) => print('Disconnected from WebSocket'));

    // Escuchar mensajes entrantes
    socket.on('receive-message', (data) {
      final message = Message.fromJson(data);
      if (onMessageReceived != null) {
        onMessageReceived!(message);
      }
    });

    // Escuchar actualizaciones de estado de lectura
    socket.on('message-read', (data) {
      if (onMessageRead != null) {
        onMessageRead!(data['messageId']);
      }
    });

    // Escuchar indicador de escritura
    socket.on('user-typing', (data) {
      if (onUserTyping != null) {
        onUserTyping!(data['userId']);
      }
    });
  }

  void joinChat(String chatId) {
    if (_isConnected) socket.emit('join-chat', {'chatId': chatId});
  }

  void leaveChat(String chatId) {
    if (_isConnected) socket.emit('leave-chat', {'chatId': chatId});
  }

  void sendMessage(String chatId, String content) {
    if (_isConnected) socket.emit('send-message', {'chatId': chatId, 'content': content});
  }

  void startTyping(String chatId) {
    if (_isConnected) socket.emit('typing', {'chatId': chatId, 'isTyping': true});
  }

  void stopTyping(String chatId) {
    if (_isConnected) socket.emit('typing', {'chatId': chatId, 'isTyping': false});
  }

  void markMessageAsRead(String messageId) {
    if (_isConnected) {
      socket.emit('mark-message-read', {'messageId': messageId});
    }
  }

  void markChatAsRead(String chatId) {
    if (_isConnected) socket.emit('mark-chat-read', {'chatId': chatId});
  }

  void disconnect() {
    if (_isConnected) {
      socket.disconnect();
      socket.dispose();
      _isConnected = false; // Marcar como desconectado
    }
  }
}
