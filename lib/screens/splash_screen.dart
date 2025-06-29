import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCD0), // Match app background
      body: Center(
        child: Image.asset(
          'assets/logo/clora_logo.png', // ✅ Your uploaded logo path
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
