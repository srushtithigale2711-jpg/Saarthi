import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const SaarthiApp());
}

class SaarthiApp extends StatelessWidget {
  const SaarthiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Saarthi',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
        ),
        fontFamily: 'Roboto',
      ),
      home: const LoginPage(),
    );
  }
}