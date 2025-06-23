import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Bienvenue chez HAPPY HOUR',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: () => Navigator.pushNamed(context, '/menu'),
              child: const Text('Continuer',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 40),
            Image.asset('assets/logo.jpg', width: 150),
          ],
        ),
      ),
    );
  }
}
