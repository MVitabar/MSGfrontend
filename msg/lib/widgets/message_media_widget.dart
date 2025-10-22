import 'package:flutter/material.dart';
import '../models/message.dart';
import 'message_image_widget.dart';
import 'message_video_widget.dart';
import 'message_audio_widget.dart';
import 'message_file_widget.dart';

class MessageMediaWidget extends StatelessWidget {
  final Message message;
  final bool isOwnMessage;
  final String currentUserId;

  const MessageMediaWidget({
    super.key,
    required this.message,
    required this.isOwnMessage,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    // Si no tiene archivos adjuntos, no mostrar nada
    if (!message.hasAttachment) {
      return const SizedBox.shrink();
    }

    switch (message.type) {
      case MessageType.image:
        return MessageImageWidget(
          message: message,
          isOwnMessage: isOwnMessage,
        );

      case MessageType.video:
        return MessageVideoWidget(
          message: message,
          isOwnMessage: isOwnMessage,
        );

      case MessageType.audio:
        return MessageAudioWidget(
          message: message,
          isOwnMessage: isOwnMessage,
        );

      case MessageType.file:
        return MessageFileWidget(
          message: message,
          isOwnMessage: isOwnMessage,
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
