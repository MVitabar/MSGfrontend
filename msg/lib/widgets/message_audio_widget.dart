import 'package:flutter/material.dart';
import '../models/message.dart';

class MessageAudioWidget extends StatefulWidget {
  final Message message;
  final bool isOwnMessage;

  const MessageAudioWidget({
    super.key,
    required this.message,
    required this.isOwnMessage,
  });

  @override
  State<MessageAudioWidget> createState() => _MessageAudioWidgetState();
}

class _MessageAudioWidgetState extends State<MessageAudioWidget> {
  bool _isPlaying = false;
  double _progress = 0.0;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.6,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.isOwnMessage ? Colors.blue[100] : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Play/Pause button
          IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () => _togglePlayback(),
          ),

          // Audio waveform visualization
          Expanded(
            child: Container(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(20, (index) {
                  return Container(
                    width: 3,
                    height: 15 + (index % 3) * 10.0,
                    decoration: BoxDecoration(
                      color: _isPlaying
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[400],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
              ),
            ),
          ),

          // Duration
          Text(
            _formatDuration(_duration),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),

          // Download button
          IconButton(
            icon: const Icon(Icons.download, size: 16),
            onPressed: () => _downloadAudio(context),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration == Duration.zero) return '0:00';
    final minutes = duration.inMinutes.toString().padLeft(1, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _togglePlayback() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      // TODO: Implementar reproducción de audio
      print('🎵 Reproduciendo audio: ${widget.message.fileUrl}');
    } else {
      // TODO: Pausar reproducción
      print('⏸️ Pausando audio');
    }
  }

  void _downloadAudio(BuildContext context) {
    // TODO: Implementar descarga de audio
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Download functionality coming soon')),
    );
  }
}
