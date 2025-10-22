import 'user.dart';

enum MessageType {
  text,
  image,
  video,
  audio,
  file,
}

class Message {
  final String id;
  final String content;
  final User sender;
  final String chatId;
  final DateTime timestamp;
  final bool? isRead;

  // Nuevos campos para multimedia
  final MessageType? type;
  final String? fileUrl;
  final String? fileName;
  final int? fileSize;
  final String? thumbnailUrl; // Para previews de imágenes y videos

  Message({
    required this.id,
    required this.sender,
    required this.content,
    required this.timestamp,
    this.chatId = '',
    this.isRead = false,
    this.type = MessageType.text,
    this.fileUrl,
    this.fileName,
    this.fileSize,
    this.thumbnailUrl,
  });

  /// Convierte una fecha UTC a la zona horaria local
  static DateTime _toLocalTime(DateTime utcTime) {
    return utcTime.toLocal();
  }

  /// Formatea la hora en un formato legible
  static String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// Obtiene la fecha formateada (opcional)
  static String formatDate(DateTime time) {
    return '${time.day}/${time.month}/${time.year}';
  }

  /// Obtiene la fecha y hora en formato legible
  String get formattedTime => formatTime(_toLocalTime(timestamp));

  /// Obtiene la fecha completa formateada
  String get formattedDate => formatDate(_toLocalTime(timestamp));

  /// Verifica si el mensaje tiene archivos adjuntos
  bool get hasAttachment => type != MessageType.text && fileUrl != null;

  /// Obtiene la extensión del archivo
  String? get fileExtension {
    if (fileName == null) return null;
    return fileName!.split('.').last.toLowerCase();
  }

  /// Obtiene el tamaño del archivo formateado
  String? get formattedFileSize {
    if (fileSize == null) return null;
    if (fileSize! < 1024) return '$fileSize B';
    if (fileSize! < 1024 * 1024) return '${(fileSize! / 1024).toStringAsFixed(1)} KB';
    return '${(fileSize! / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'sender': sender.toJson(),
      'chatId': chatId,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'type': type?.name,
      'fileUrl': fileUrl,
      'fileName': fileName,
      'fileSize': fileSize,
      'thumbnailUrl': thumbnailUrl,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    // Manejar el timestamp
    DateTime timestamp;
    try {
      if (json['timestamp'] != null) {
        timestamp = DateTime.parse(json['timestamp'].toString()).toUtc().toLocal();
      } else if (json['createdAt'] != null) {
        timestamp = DateTime.parse(json['createdAt'].toString()).toUtc().toLocal();
      } else {
        print('⚠️ Advertencia: Mensaje sin timestamp del servidor. ID: ${json['id']}');
        timestamp = DateTime.now();
      }
    } catch (e) {
      print('⚠️ Error al analizar el timestamp: $e');
      timestamp = DateTime.now();
    }

    // Manejar el tipo de mensaje
    MessageType? messageType;
    try {
      if (json['type'] != null) {
        messageType = MessageType.values.firstWhere(
          (type) => type.name == json['type'].toString(),
          orElse: () => MessageType.text,
        );
      }
    } catch (e) {
      print('⚠️ Error al analizar el tipo de mensaje: $e');
      messageType = MessageType.text;
    }

    // Depuración
    print('Mensaje ID: ${json['id']}');
    print('- Hora UTC: ${timestamp.toUtc()}');
    print('- Hora local: $timestamp');
    print('- Contenido: ${json['content']}');
    print('- Tipo: ${messageType?.name ?? 'text'}');
    print('- Tiene archivo: ${json['fileUrl'] != null}');

    return Message(
      id: json['id']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      sender: User.fromJson(json['sender'] ?? {}),
      chatId: json['chatId']?.toString() ?? '',
      timestamp: timestamp,
      isRead: json['isRead'] as bool?,
      type: messageType,
      fileUrl: json['fileUrl']?.toString(),
      fileName: json['fileName']?.toString(),
      fileSize: json['fileSize'] as int?,
      thumbnailUrl: json['thumbnailUrl']?.toString(),
    );
  }
}
