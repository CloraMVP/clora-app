import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_screen.dart';
import 'clo_chat_screen.dart';
import 'profile_screen.dart';
import 'phone_verification_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  bool _checkingPhone = true;
  bool _phoneVerified = false;

  final List<Widget> _screens = const [
    HomeScreen(),
    CloChatScreen(),
    DisabledStoreScreen(),
  ];

  final List<String> _titles = const [
    'Clora Tracker',
    'Chat with Clo',
    'Product Store',
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkPhoneVerification();
  }

  Future<void> _checkPhoneVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.phoneNumber != null && user.phoneNumber!.isNotEmpty) {
      setState(() {
        _phoneVerified = true;
        _checkingPhone = false;
      });
    } else {
      setState(() => _checkingPhone = false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PhoneVerificationScreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingPhone) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_phoneVerified) {
      return const SizedBox(); // Will redirect to phone screen
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(fontFamily: 'ComicNeue'),
        ),
        backgroundColor: Colors.purple.shade400,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFFFFFCD0),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Tracker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Clo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Store',
          ),
        ],
      ),
    );
  }
}

class DisabledStoreScreen extends StatelessWidget {
  const DisabledStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "🛒 Store coming soon...",
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'ComicNeue',
          ),
        ),
      ),
    );
  }
}
