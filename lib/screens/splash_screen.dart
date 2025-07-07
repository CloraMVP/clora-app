import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ Pure white background
      body: Center(
        child: Image.asset(
          'assets/logo/clora_logo.png',
          width: 300, // ✅ Doubled width
          height: 300, // ✅ Doubled height
        ),
      ),
    );
  }
}
