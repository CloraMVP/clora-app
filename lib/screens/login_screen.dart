import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'profile_setup_screen.dart';
import 'home_screen.dart';
import '../widgets/google_signin_button.dart';
import 'phone_verification_screen.dart';
import '../services/firestore_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _signInWithGoogle() async {
    setState(() => _isLoading = true);

    final result = await _authService.signInWithGoogle();

    if (result != null) {
      final user = result.user;
      if (user == null) return;

      final data = await FirestoreService.getUserProfile(user.uid);
      final phone = data?['phone'] ?? '';

      if (phone.isEmpty || phone.length < 6) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PhoneVerificationScreen()),
        );
        return;
      }

      final isNewUser = result.additionalUserInfo?.isNewUser ?? false;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
          isNewUser ? const ProfileSetupScreen() : const HomeScreen(),
        ),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFCDF), Color(0xFFD8CFF7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Welcome to Clora',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ComicNeue',
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Get onboard to chat with Clo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ComicNeue',
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Your personal feminine assistant',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'ComicNeue',
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),
              Image.asset(
                'assets/images/profile_placeholder.png',
                height: 120,
              ),
              const SizedBox(height: 30),
              GoogleSignInButton(onPressed: _signInWithGoogle),
            ],
          ),
        ),
      ),
    );
  }
}
