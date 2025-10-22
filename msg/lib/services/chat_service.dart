import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat.dart';
import '../models/message.dart';
import '../models/user.dart';
import 'file_service.dart';

class ChatService {
  static const String baseUrl = 'http://localhost:3000'; // Base URL del backend

  // Obtener lista de chats del usuario
  Future<List<Chat>> getChats(String token) async {
    try {
      print('🔄 ChatService: Solicitando lista de chats...');
      final response = await http.get(
        Uri.parse('$baseUrl/chats'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print('📨 ChatService: Status ${response.statusCode}');

      if (response.statusCode == 200) {
        final rawData = response.body;
        print('📨 ChatService: Datos recibidos (${rawData.length} caracteres)');

        final List data = jsonDecode(rawData);
        print('📨 ChatService: ${data.length} chats encontrados');

        return data.map((c) => Chat.fromJson(c)).toList();
      } else {
        print('❌ ChatService: Error ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('❌ ChatService: Excepción: $e');
      return [];
    }
  }

  // Crear un chat directo
  Future<Chat?> createDirectChat(String token, String contact) async {
    print('Creando chat directo con contacto: $contact');
    final isEmail = contact.contains('@');
    final Map<String, dynamic> body = {};
    if (isEmail) {
      body['email'] = contact;
    } else {
      body['phone'] = contact;
    }
    print('Body enviado: ${jsonEncode(body)}');

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chats/direct'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode(body),
      );

      print('Respuesta de createDirectChat: Status ${response.statusCode}, Body: ${response.body}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('Chat creado exitosamente');
        return Chat.fromJson(data);
      } else {
        print('Error creando chat: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Excepción en createDirectChat: $e');
      return null;
    }
  }

  // Crear un chat grupal
  Future<Chat?> createGroupChat(String token, String name, List<String> userIds) async {
    final response = await http.post(
      Uri.parse('$baseUrl/chats/group'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode({'name': name, 'userIds': userIds}),
    );
    if (response.statusCode == 201) {
      return Chat.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  // Obtener mensajes de un chat
  Future<List<Message>> getMessages(String token, String chatId) async {
    try {
      print('Fetching messages for chat: $chatId');
      final response = await http.get(
        Uri.parse('$baseUrl/messages/$chatId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      
      print('Messages response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        print('Fetched ${data.length} messages');
        
        // Convertir a mensajes y ordenar por timestamp y luego por ID para consistencia
        final messages = data.map((m) => Message.fromJson(m)).toList();
        messages.sort((a, b) {
          // Primero por timestamp
          final timeCompare = a.timestamp.compareTo(b.timestamp);
          // Si los timestamps son iguales, ordenar por ID
          return timeCompare != 0 ? timeCompare : a.id.compareTo(b.id);
        });
        
        // Log para verificar el orden
        if (messages.isNotEmpty) {
          print('--- Mensajes ordenados ---');
          for (var i = 0; i < messages.length; i++) {
            print('${i + 1}. ${messages[i].timestamp} - "${messages[i].content}" (ID: ${messages[i].id})');
          }
        }
        
        return messages;
      } else {
        print('Error fetching messages: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('Exception in getMessages: $e');
      return [];
    }
  }

  // Marcar un mensaje como leído
  Future<bool> markMessageAsRead(String token, String messageId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/messages/$messageId/read'),
        headers: {'Authorization': 'Bearer $token'},
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error marking message as read: $e');
      return false;
    }
  }

  // Enviar un mensaje
  Future<Message?> sendMessage(String token, String chatId, String content) async {
    try {
      print('Enviando mensaje a chat $chatId: $content');
      final response = await http.post(
        Uri.parse('$baseUrl/messages'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({'chatId': chatId, 'content': content}),
      );

      print('Respuesta del servidor (${response.statusCode}): ${response.body}');

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print('Mensaje enviado exitosamente. Respuesta del servidor:');
        print('- ID: ${responseData['id']}');
        print('- Timestamp: ${responseData['timestamp']}');
        print('- Contenido: ${responseData['content']}');

        return Message.fromJson(responseData);
      } else {
        print('Error al enviar mensaje: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Excepción al enviar mensaje: $e');
      return null;
    }
  }

  // Enviar mensaje multimedia
  Future<Message?> sendMultimediaMessage({
    required String token,
    required String chatId,
    required File file,
    String? caption,
    required MessageType type,
  }) async {
    try {
      print('📤 Enviando archivo multimedia: ${file.path}');

      // Usar MediaService para subir el archivo
      final fileService = MediaService();

      // Comprimir imagen si es necesario
      File? processedFile = file;
      if (type == MessageType.image) {
        processedFile = await fileService.compressImage(file);
      }

      // Crear thumbnail si es necesario
      File? thumbnailFile;
      if (type == MessageType.image || type == MessageType.video) {
        thumbnailFile = await fileService.createThumbnail(processedFile!, type);
      }

      // Subir archivo
      final uploadResult = await fileService.uploadFile(
        processedFile!,
        token,
        chatId,
        caption: caption,
      );

      if (uploadResult == null) {
        print('❌ Error subiendo archivo');
        return null;
      }

      // Crear mensaje con datos del archivo
      final messageData = {
        'chatId': chatId,
        'content': caption ?? '',
        'type': type.name,
        'fileUrl': uploadResult['fileUrl'],
        'fileName': uploadResult['fileName'],
        'fileSize': uploadResult['fileSize'],
        'thumbnailUrl': uploadResult['thumbnailUrl'],
      };

      print('📝 Creando mensaje multimedia: $messageData');

      // Enviar mensaje al backend
      final response = await http.post(
        Uri.parse('$baseUrl/messages'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(messageData),
      );

      print('📨 Respuesta multimedia (${response.statusCode}): ${response.body}');

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print('✅ Mensaje multimedia enviado exitosamente');

        // Obtener información del usuario actual del token (simplificado)
        // TODO: Mejorar esto obteniendo la info real del usuario
        final currentUser = User(
          id: 'current_user', // Esto debería venir del AuthProvider
          email: '',
          name: 'You',
        );

        // Crear mensaje local con la respuesta del servidor
        final message = Message(
          id: responseData['id']?.toString() ?? '',
          content: responseData['content']?.toString() ?? '',
          sender: User.fromJson(responseData['sender'] ?? currentUser.toJson()),
          chatId: responseData['chatId']?.toString() ?? chatId,
          timestamp: DateTime.parse(responseData['timestamp']?.toString() ?? DateTime.now().toIso8601String()),
          isRead: false,
          type: type,
          fileUrl: responseData['fileUrl']?.toString(),
          fileName: responseData['fileName']?.toString(),
          fileSize: responseData['fileSize'] as int?,
          thumbnailUrl: responseData['thumbnailUrl']?.toString(),
        );

        return message;
      } else {
        print('❌ Error enviando mensaje multimedia: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Excepción enviando mensaje multimedia: $e');
      return null;
    }
  }
}
