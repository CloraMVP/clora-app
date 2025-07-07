import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase/firebase_options.dart';
import 'screens/main_navigation.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_form_screen.dart'; // ✅ NEW import
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // ✅ Firebase initialization (with duplicate check)
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print("✅ Firebase initialized");
    } else {
      print("⚠️ Firebase already initialized");
    }

    // ✅ FCM initialization
    await NotificationService.initFCM();
    print("✅ FCM initialized successfully");

  } catch (e) {
    print("❌ Initialization Error: $e");
  }

  runApp(const CloraApp());
}

class CloraApp extends StatelessWidget {
  const CloraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clora',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'ComicNeue',
        scaffoldBackgroundColor: const Color(0xFFFFFCD0),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashToAuth(),
      routes: {
        '/profile': (context) => const ProfileScreen(),
        '/main': (context) => const MainNavigation(),
        '/onboarding': (context) => const OnboardingFormScreen(), // ✅ NEW route
      },
    );
  }
}

class SplashToAuth extends StatefulWidget {
  const SplashToAuth({super.key});

  @override
  State<SplashToAuth> createState() => _SplashToAuthState();
}

class _SplashToAuthState extends State<SplashToAuth> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    print("🌀 Showing splash...");
    Future.delayed(const Duration(seconds: 2), () {
      print("✅ Splash done → moving to auth check...");
      setState(() => _showSplash = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showSplash ? const SplashScreen() : const AuthWrapper();
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasData) {
          final user = snapshot.data!;
          return FutureBuilder(
            future: FirestoreService.getUserProfile(user.uid),
            builder: (context, userSnap) {
              if (userSnap.connectionState != ConnectionState.done) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }

              final userData = userSnap.data as Map<String, dynamic>?;

              final needsOnboarding = userData == null ||
                  (userData['dob'] ?? '').isEmpty ||
                  (userData['city'] ?? '').isEmpty;

              if (needsOnboarding) {
                return const OnboardingFormScreen(); // 👈 send to form
              } else {
                return const MainNavigation();
              }
            },
          );
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
