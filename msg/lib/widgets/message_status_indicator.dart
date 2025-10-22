import 'package:flutter/material.dart';

class MessageStatusIndicator extends StatelessWidget {
  final bool? isRead;
  final bool isMe;
  final DateTime timestamp;
  final double size;

  const MessageStatusIndicator({
    Key? key,
    this.isRead,
    required this.isMe,
    required this.timestamp,
    this.size = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Default to false if isRead is null (for backward compatibility)
    final readStatus = isRead ?? false;

    IconData icon;
    Color color;

    switch (readStatus) {
      case true:
        icon = Icons.done_all;
        color = Colors.blue[400]!; // Light blue for read messages
        break;
      case false:
        icon = Icons.check;
        color = Colors.grey[600]!;
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _getFormattedTime(),
          style: TextStyle(
            fontSize: 11,
            color: isMe ? Colors.white.withOpacity(0.9) : Colors.grey[600],
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(width: 6),
        Icon(
          icon,
          size: 14,
          color: color,
        ),
      ],
    );
  }

  String _getFormattedTime() {
    // Convertir a hora local y formatear
    final localTime = timestamp.toLocal();
    return '${localTime.hour.toString().padLeft(2, '0')}:${localTime.minute.toString().padLeft(2, '0')}';
  }
}
