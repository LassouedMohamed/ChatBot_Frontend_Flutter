import 'package:chat_app/conversation.dart';
import 'package:chat_app/login.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/providers/conversation_provider.dart';
import 'package:chat_app/providers/locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  setupLocator();
  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => locator<ConversationProvider>()),
        ChangeNotifierProvider(create: (_) => locator<AuthProvider>()),
      ],
      child: const MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/": (context) => Login(),
        "/conversation" : (context) => Conversation(),
      },
      title: 'Flutter Demo',
    );
  }
}

