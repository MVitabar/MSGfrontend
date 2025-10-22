import 'user.dart';
import 'message.dart';

class Chat {
  final String id;
  final String? name; // Hacer opcional ya que backend puede devolver null
  final List<User> users;
  final bool? isGroup; // Hacer opcional para manejar null
  final String? customName; // Nombre personalizado opcional

  // Nuevos campos para el último mensaje
  final Message? lastMessage; // Último mensaje del chat
  final bool? hasUnreadMessages; // Si el usuario actual tiene mensajes no leídos

  Chat({
    required this.id,
    this.name,
    required this.users,
    this.isGroup,
    this.customName,
    this.lastMessage,
    this.hasUnreadMessages = false,
  });

  String displayName(String currentUserId) {
    if (customName != null && customName!.isNotEmpty) return customName!;
    if (name != null && name!.isNotEmpty) return name!;
    
    // Si es chat directo, usar el nombre del otro usuario
    if (users.length == 2) {
      try {
        // Convertir el ID del usuario actual a String si es necesario
        final currentUserIdStr = currentUserId.toString();
        
        // Buscar el otro usuario que no sea el actual
        final otherUser = users.firstWhere(
          (user) => user.id.toString() != currentUserIdStr,
          orElse: () => users.first,
        );
        
        return otherUser.name;
      } catch (e) {
        return users.first.name; // Fallback al primer usuario
      }
    }
    
    // Si no es un chat directo y no hay nombre personalizado, devolver 'Unknown'
    return 'Group Chat';
  }

  factory Chat.fromJson(Map<String, dynamic> json) {
    // Procesar usuarios
    List<User> users = [];
    if (json['users'] != null && json['users'] is List) {
      users = (json['users'] as List).map((userData) {
        try {
          final userJson = userData is Map<String, dynamic> ?
              (userData['user'] ?? userData) :
              (userData is Map ? Map<String, dynamic>.from(userData) : null);

          if (userJson != null) {
            return User.fromJson(userJson);
          }
        } catch (e) {
          print('Error processing user data: $e');
        }
        return User(id: '', email: '', name: 'Unknown');
      }).toList();
    }

    // Determinar si es grupo
    final isGroup = json['type'] == 'group' || (json['isGroup'] ?? false);

    // Procesar último mensaje si existe (probar diferentes nombres de campo)
    Message? lastMessage;
    Map<String, dynamic>? lastMessageData;

    // Probar diferentes nombres de campo comunes
    if (json.containsKey('lastMessage') && json['lastMessage'] is Map<String, dynamic>) {
      lastMessageData = json['lastMessage'];
    } else if (json.containsKey('last_message') && json['last_message'] is Map<String, dynamic>) {
      lastMessageData = json['last_message'];
    } else if (json.containsKey('latestMessage') && json['latestMessage'] is Map<String, dynamic>) {
      lastMessageData = json['latestMessage'];
    } else if (json.containsKey('recentMessage') && json['recentMessage'] is Map<String, dynamic>) {
      lastMessageData = json['recentMessage'];
    } else if (json.containsKey('messages') && json['messages'] is List && json['messages'].isNotEmpty) {
      final messagesArray = json['messages'] as List;
      lastMessageData = messagesArray.last;
    }

    if (lastMessageData != null) {
      try {
        lastMessage = Message.fromJson(lastMessageData);
      } catch (e) {
        print('❌ Error procesando lastMessage: $e');
      }
    }

    // Verificar si hay mensajes no leídos (probar diferentes nombres de campo)
    bool hasUnreadMessages = false;

    if (json.containsKey('hasUnreadMessages')) {
      hasUnreadMessages = json['hasUnreadMessages'] as bool? ?? false;
    } else if (json.containsKey('has_unread_messages')) {
      hasUnreadMessages = json['has_unread_messages'] as bool? ?? false;
    } else if (json.containsKey('unreadCount') && json['unreadCount'] > 0) {
      hasUnreadMessages = (json['unreadCount'] as int?)! > 0;
    }

    return Chat(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString(),
      users: users,
      isGroup: isGroup,
      customName: json['customName']?.toString(),
      lastMessage: lastMessage,
      hasUnreadMessages: hasUnreadMessages,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'users': users.map((u) => {'user': u.toJson()}).toList(),
      'isGroup': isGroup ?? false,
      'customName': customName,
      'lastMessage': lastMessage?.toJson(),
      'hasUnreadMessages': hasUnreadMessages ?? false,
    };
  }
}
