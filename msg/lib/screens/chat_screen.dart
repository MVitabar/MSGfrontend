import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';
import '../widgets/message_status_indicator.dart';
import '../widgets/message_media_widget.dart';
import '../widgets/attachment_button.dart';

class ChatScreen extends StatefulWidget {
  final Chat chat;
  final String currentUserId;

  ChatScreen({required this.chat, required this.currentUserId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Widget para mostrar las iniciales del usuario
  Widget _buildInitialsAvatar(String? name) {
    final String initials = name?.trim().isNotEmpty == true 
        ? name!.split(' ').where((s) => s.isNotEmpty).take(2).map((s) => s[0]).join().toUpperCase()
        : '?';
    
    return Text(
      initials.length > 2 ? initials.substring(0, 2) : initials,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: initials.length > 1 ? 12 : 14,
      ),
    );
  }

  // Get current user from AuthProvider
  User? get currentUser {
    try {
      return Provider.of<AuthProvider>(context, listen: false).user;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }
  List<Message> messages = [];
  final _messageController = TextEditingController();
  bool _isLoading = true;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _setupSocket();
  }

  Future<void> _loadMessages() async {
    setState(() => _isLoading = true);
    try {
      final authProvider = context.read<AuthProvider>();
      final token = authProvider.token;
      if (token != null) {
        messages = await authProvider.chatService.getMessages(token, widget.chat.id);
        _updateMessageReadStatus();
      }
    } catch (e) {
      print('❌ Error loading messages: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _updateMessageReadStatus() {
    setState(() {
      for (int i = 0; i < messages.length; i++) {
        final message = messages[i];

        if (message.sender.id != widget.currentUserId) {
          // Es un mensaje de otro usuario
          if (message.isRead != true) {
            // Marcar mensaje como leído inmediatamente
            final authProvider = context.read<AuthProvider>();
            authProvider.socketService.markMessageAsRead(message.id);

            // Actualizar el estado local para reflejar la UI inmediatamente
            final updatedMessage = Message(
              id: message.id,
              content: message.content,
              sender: message.sender,
              chatId: message.chatId,
              timestamp: message.timestamp,
              isRead: true,
            );
            messages[i] = updatedMessage;
          }
        }
      }
    });
  }

  void _setupSocket() {
    final authProvider = context.read<AuthProvider>();

    authProvider.socketService.onMessageReceived = (message) {
      if (message.chatId == widget.chat.id) {
        setState(() {
          // Insertar mensaje en la posición correcta
          int insertIndex = messages.indexWhere((m) =>
            m.timestamp.compareTo(message.timestamp) > 0 ||
            (m.timestamp == message.timestamp && m.id.compareTo(message.id) > 0)
          );

          if (insertIndex == -1) {
            messages.add(message);
          } else {
            messages.insert(insertIndex, message);
          }
        });

        // Marcar como leído si es de otro usuario
        if (message.sender.id != widget.currentUserId) {
          authProvider.socketService.markMessageAsRead(message.id);
        }
      }
    };

    // Configurar callback para actualizaciones de estado de lectura
    authProvider.socketService.onMessageRead = (messageId) {
      setState(() {
        // Encontrar y actualizar el mensaje con el ID correspondiente
        final messageIndex = messages.indexWhere((msg) => msg.id == messageId);
        if (messageIndex != -1) {
          final updatedMessage = Message(
            id: messages[messageIndex].id,
            content: messages[messageIndex].content,
            sender: messages[messageIndex].sender,
            chatId: messages[messageIndex].chatId,
            timestamp: messages[messageIndex].timestamp,
            isRead: true,
          );
          messages[messageIndex] = updatedMessage;
        }
      });
    };

    authProvider.socketService.joinChat(widget.chat.id);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final currentUserId = widget.currentUserId;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                widget.chat.displayName(currentUserId)[0].toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: 10),
            Text(widget.chat.displayName(currentUserId)),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary))
                : messages.isEmpty
                    ? Center(
                        child: Text(
                          'No messages yet. Start the conversation!',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        reverse: true, // Mostrar mensajes más recientes abajo
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          // Invertir el índice para mostrar los mensajes más recientes abajo
                          final message = messages[messages.length - 1 - index];
                          final isMe = message.sender.id == widget.currentUserId;
                          final isGroup = widget.chat.isGroup ?? false;

                          // Determinar si mostrar el avatar y el nombre
                          bool showAvatar = false;
                          bool showName = false;
                          
                          // Verificar si es el último mensaje de un grupo
                          if (index < messages.length - 1) {
                            final nextMessage = messages[messages.length - 2 - index];
                            final isNextMessageFromSameUser = nextMessage.sender.id == message.sender.id && 
                                                           (nextMessage.sender.id == widget.currentUserId) == isMe;
                            
                            // Mostrar avatar solo si es el último mensaje de un grupo
                            showAvatar = !isNextMessageFromSameUser;
                            
                            // En grupos, mostrar el nombre si es el primer mensaje del remitente
                            showName = isGroup && !isNextMessageFromSameUser && !isMe;
                          } else {
                            // Es el mensaje más antiguo (último en la lista)
                            showAvatar = true;
                            showName = isGroup && !isMe;
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // Contenedor del mensaje (a la izquierda para otros usuarios)
                                if (!isMe) ...[
                                  // Avatar para otros usuarios
                                  if (showAvatar) ...[
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Theme.of(context).colorScheme.primary,
                                      child: _buildInitialsAvatar(message.sender.name),
                                    ),
                                    SizedBox(width: 8),
                                  ] else ...[
                                    SizedBox(width: 40), // Espacio para alinear con avatares
                                  ]
                                ],

                                // Contenido del mensaje
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                    children: [
                                      // Mostrar nombre solo en grupales, si no es propio y es el primer mensaje del remitente
                                      if (showName)
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 4.0, left: 8.0),
                                          child: Text(
                                            message.sender.name,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          top: 8,
                                          bottom: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isMe 
                                              ? Theme.of(context).colorScheme.primary 
                                              : Colors.grey[200],
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                            bottomLeft: Radius.circular(isMe ? 20 : (index > 0 && messages[messages.length - index].sender.id == message.sender.id) ? 4 : 20),
                                            bottomRight: Radius.circular(isMe ? ((index > 0 && messages[messages.length - index].sender.id == message.sender.id) ? 4 : 20) : 20),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                          children: [
                                            // Mostrar archivo multimedia si existe
                                            if (message.hasAttachment) ...[
                                              MessageMediaWidget(
                                                message: message,
                                                isOwnMessage: isMe,
                                                currentUserId: widget.currentUserId,
                                              ),
                                              if (message.content.isNotEmpty) SizedBox(height: 8),
                                            ],

                                            // Mostrar texto del mensaje
                                            if (message.content.isNotEmpty) ...[
                                              Text(
                                                message.content,
                                                style: TextStyle(
                                                  color: isMe ? Colors.white : Colors.black87,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                            ],

                                            // Estado del mensaje o hora
                                            isMe
                                              ? MessageStatusIndicator(
                                                  isRead: message.isRead,
                                                  isMe: isMe,
                                                  timestamp: message.timestamp,
                                                )
                                              : Text(
                                                  message.formattedTime,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: isMe ? Colors.white70 : Colors.grey[600],
                                                  ),
                                                ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Avatar del usuario actual (a la derecha)
                                if (isMe) ...[
                                  SizedBox(width: 8),
                                  if (showAvatar) 
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Theme.of(context).colorScheme.secondary,
                                      child: _buildInitialsAvatar(currentUser?.name ?? ''),
                                    )
                                  else
                                    SizedBox(width: 40), // Mismo ancho que el avatar para mantener la alineación
                                ],
                              ],
                            ),
                          );
                        },
                      ),
          ),
          if (_isTyping) Text('Someone is typing...', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Botón de adjuntar archivos
                AttachmentButton(
                  token: context.read<AuthProvider>().token ?? '',
                  chatId: widget.chat.id,
                  onFileSelected: () {
                    // Recargar mensajes después de enviar archivo
                    _loadMessages();
                  },
                ),
                SizedBox(width: 8),

                // Campo de texto
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    onChanged: (text) {
                      if (text.isNotEmpty && !_isTyping) {
                        context.read<AuthProvider>().socketService.startTyping(widget.chat.id);
                        setState(() => _isTyping = true);
                      } else if (text.isEmpty && _isTyping) {
                        context.read<AuthProvider>().socketService.stopTyping(widget.chat.id);
                        setState(() => _isTyping = false);
                      }
                    },
                  ),
                ),
                SizedBox(width: 8),

                // Botón de enviar
                IconButton(
                  icon: Icon(Icons.send, color: Theme.of(context).colorScheme.primary),
                  onPressed: () async {
                    if (_messageController.text.isNotEmpty) {
                      final authProvider = context.read<AuthProvider>();
                      final message = await authProvider.chatService.sendMessage(
                        authProvider.token!,
                        widget.chat.id,
                        _messageController.text,
                      );
                      if (message != null) {
                        // Agregar mensaje localmente para simular recepción inmediata
                        setState(() => messages.add(message));
                      }
                      _messageController.clear();
                      authProvider.socketService.stopTyping(widget.chat.id);
                      setState(() => _isTyping = false);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
