import 'package:flutter/material.dart';
import '../models/message.dart';

class MessageFileWidget extends StatelessWidget {
  final Message message;
  final bool isOwnMessage;

  const MessageFileWidget({
    super.key,
    required this.message,
    required this.isOwnMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.6,
      ),
      child: GestureDetector(
        onTap: () => _openFile(context),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isOwnMessage ? Colors.blue[100] : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isOwnMessage ? Colors.blue[200]! : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // File type icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getFileColor(),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getFileIcon(),
                  color: Colors.white,
                  size: 24,
                ),
              ),

              const SizedBox(width: 12),

              // File info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // File name
                    Text(
                      message.fileName ?? 'Unknown File',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // File size
                    if (message.formattedFileSize != null)
                      Text(
                        message.formattedFileSize!,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),

              // Download button
              IconButton(
                icon: const Icon(Icons.download, size: 20),
                onPressed: () => _downloadFile(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getFileIcon() {
    final extension = message.fileExtension?.toLowerCase();

    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'txt':
        return Icons.text_snippet;
      case 'zip':
      case 'rar':
        return Icons.archive;
      case 'mp3':
      case 'm4a':
      case 'wav':
        return Icons.music_note;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getFileColor() {
    final extension = message.fileExtension?.toLowerCase();

    switch (extension) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'txt':
        return Colors.green;
      case 'zip':
      case 'rar':
        return Colors.orange;
      case 'mp3':
      case 'm4a':
      case 'wav':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void _openFile(BuildContext context) {
    final extension = message.fileExtension?.toLowerCase();

    if (extension == 'pdf') {
      // TODO: Abrir PDF viewer
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF viewer coming soon')),
      );
    } else {
      // Descargar archivo
      _downloadFile(context);
    }
  }

  void _downloadFile(BuildContext context) {
    // TODO: Implementar descarga de archivo
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Download functionality coming soon')),
    );
  }
}
