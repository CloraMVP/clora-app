import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import '../services/firestore_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppUser? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userMap = await FirestoreService.getUserProfile(currentUser.uid);
      if (userMap != null) {
        setState(() {
          _user = AppUser.fromMap(userMap);
          _isLoading = false;
        });
      }
    }
  }

  int getCycleDay(DateTime lastPeriod) {
    final today = DateTime.now();
    return today.difference(lastPeriod).inDays + 1;
  }

  DateTime getNextPeriodDate(DateTime lastPeriod, int cycleLength) {
    return lastPeriod.add(Duration(days: cycleLength));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Clora Tracker',
          style: TextStyle(fontFamily: 'ComicNeue'),
        ),
        backgroundColor: Colors.purple.shade400,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFCDF), Color(0xFFD8CFF7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _user == null
            ? const Center(child: Text("User data not found"))
            : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    final lastPeriodDate = DateFormat('dd-MM-yyyy').parse(_user!.lastPeriodDate);
    final cycleDay = getCycleDay(lastPeriodDate);
    final nextPeriod = getNextPeriodDate(lastPeriodDate, _user!.cycleLength);

    return Column(
      children: [
        const SizedBox(height: 20),
        Center(
          child: Lottie.asset(
            'assets/animations/tracker_anim.json',
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Cycle Day: $cycleDay",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'ComicNeue',
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Next Period: ${DateFormat('dd MMM').format(nextPeriod)}",
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'ComicNeue',
          ),
        ),
        const SizedBox(height: 40),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "🧘‍♀️ Today's Tip:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'ComicNeue',
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Stay hydrated and rest well. A short walk can help ease cramps.",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'ComicNeue',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
