import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/menu_screen.dart';

void main() {
  runApp(HappyHourApp());
}

class HappyHourApp extends StatelessWidget {
  const HappyHourApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Happy Hour',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        useMaterial3: false, // Ajoute cette ligne
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/menu': (context) => MenuScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
