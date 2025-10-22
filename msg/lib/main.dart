import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/chat_list_screen.dart';
import 'screens/chat_screen.dart';
import 'models/chat.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider()..initialize(),
      child: MaterialApp(
        title: 'MSG',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light, // Tema claro
          ),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark, // Tema oscuro
          ),
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system, // Adaptar al sistema (claro/oscuro)
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/chats': (context) => ChatListScreen(),
          '/chat': (context) {
            final args = ModalRoute.of(context)!.settings.arguments;
            if (args is Map<String, dynamic>) {
              return ChatScreen(chat: args['chat'], currentUserId: args['currentUserId']);
            } else {
              // Fallback si argumentos no son correctos
              return Scaffold(body: Center(child: Text('Error: Invalid chat arguments')));
            }
          },
        },
      ),
    );
  }
}
