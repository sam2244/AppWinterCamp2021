import 'package:flutter/material.dart';
import 'login.dart';
import 'chat.dart';
import 'home.dart';
import 'mypage.dart';
import 'makeroom.dart';

class ShrineApp extends StatelessWidget {
  const ShrineApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Winter App',
      home: const LoginPage(),
      theme: ThemeData(
          primaryColor: const Color(0xFF03A9F4),
          primaryColorDark: const Color(0xFF2A9D8F),
          primaryColorLight: const Color(0xFFFFFFFF),
          accentColor: const Color(0xFFFFFFFF),
          backgroundColor: const Color(0xFFFFFFFF)
      ),
      initialRoute: '/',
      routes: {
        '/login': (context) => const LoginPage (),
        '/chat' : (context) => const ChatPage (),
        '/home' : (context) => const HomePage (),
        '/mypage' : (context) => MyPage (),
        '/makeroom' : (context) => MakeroomPage (),
      },
      onGenerateRoute: _getRoute,
    );
  }

  Route<dynamic>? _getRoute(RouteSettings settings) {
    if (settings.name != '/login') {
      return null;
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => const LoginPage(),
      fullscreenDialog: true,
    );
  }
}