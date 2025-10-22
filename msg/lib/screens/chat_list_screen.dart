import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/chat.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<Chat> chats = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    print('🔄 ChatListScreen: Iniciando carga de chats');
    setState(() => _isLoading = true);

    final authProvider = context.read<AuthProvider>();
    final token = authProvider.token;

    if (token != null) {
      chats = await authProvider.chatService.getChats(token);
      print('✅ ChatListScreen: Cargados ${chats.length} chats');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final currentUserId = authProvider.user?.id ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('MSG'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {}, // Placeholder for search
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary))
          : chats.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat, size: 80, color: Colors.grey),
                      SizedBox(height: 20),
                      Text(
                        'No chats yet',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      Text(
                        'Tap + to start a conversation',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    final displayName = chat.displayName(currentUserId);

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        displayName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Último mensaje
                          Text(
                            chat.lastMessage?.content ?? 'No messages yet',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2),
                          // Estado y hora
                          Row(
                            children: [
                              // Indicador de estado de lectura
                              if (chat.lastMessage != null && chat.lastMessage!.sender.id != currentUserId)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: chat.lastMessage!.isRead == true
                                        ? Colors.grey[400] // Mensaje leído
                                        : Theme.of(context).colorScheme.primary, // Mensaje no leído
                                  ),
                                ),
                              if (chat.lastMessage != null && chat.lastMessage!.sender.id != currentUserId)
                                SizedBox(width: 4),
                              // Hora
                              Text(
                                chat.lastMessage?.formattedTime ?? '',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      onTap: () {
                        print('Opening chat with: $displayName');
                        Navigator.pushNamed(
                          context, 
                          '/chat', 
                          arguments: {
                            'chat': chat, 
                            'currentUserId': currentUserId
                          }
                        );
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateChatDialog,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showCreateChatDialog() {
    final _contactController = TextEditingController();
    final _nameController = TextEditingController();
    String _contactType = 'phone'; // 'phone' o 'email'

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Start New Chat'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _contactController,
              decoration: InputDecoration(
                labelText: 'Phone or Email of Contact',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Custom Name (optional)',
                border: OutlineInputBorder(),
                hintText: 'Leave blank to use registered name',
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text('Type: '),
                Radio<String>(
                  value: 'phone',
                  groupValue: _contactType,
                  onChanged: (value) => setState(() => _contactType = value!),
                ),
                Text('Phone'),
                Radio<String>(
                  value: 'email',
                  groupValue: _contactType,
                  onChanged: (value) => setState(() => _contactType = value!),
                ),
                Text('Email'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final contact = _contactController.text.trim();
              final customName = _nameController.text.trim();
              if (contact.isNotEmpty) {
                final authProvider = context.read<AuthProvider>();
                final token = authProvider.token;
                if (token != null) {
                  try {
                    final chat = await authProvider.chatService.createDirectChat(token, contact);
                    if (chat != null) {
                      // Crear una copia de chat con customName si se proporciona
                      final updatedChat = Chat(
                        id: chat.id,
                        name: chat.name,
                        users: chat.users,
                        isGroup: chat.isGroup,
                        customName: customName.isNotEmpty ? customName : null,
                        lastMessage: chat.lastMessage,
                        hasUnreadMessages: chat.hasUnreadMessages,
                      );
                      _loadChats(); // Recargar lista de chats
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/chat', arguments: updatedChat);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to create chat. Contact may not exist.')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error creating chat: $e')),
                    );
                  }
                }
              }
              Navigator.pop(context);
            },
            child: Text('Create'),
          ),
        ],
      ),
    );
  }
}
