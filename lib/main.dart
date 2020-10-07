import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:music_chat/services/auth_service.dart';
import 'package:music_chat/services/chat_service.dart';
import 'package:music_chat/services/socket_service.dart';

import 'package:music_chat/routes/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SocketServices()),
        ChangeNotifierProvider(create: (_) => ChatService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        theme: ThemeData(brightness: Brightness.dark, accentColor: Colors.blue),
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}
