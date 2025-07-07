import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AppUser? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userMap = await FirestoreService.getUserProfile(currentUser.uid);
      setState(() {
        _user = userMap != null ? AppUser.fromMap(userMap) : null;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: Colors.purple.shade400,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
          ? const Center(child: Text("Failed to load user data"))
          : Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFCDF), Color(0xFFD8CFF7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildItem("Name", _user!.name),
              _buildItem("Email", _user!.email),
              _buildItem("DOB", _user!.dob ?? "Not set"),
              _buildItem("Phone", _user!.phone ?? "Not set"),
              _buildItem("City / Zip", _user!.city ?? "Not set"),
              _buildItem("Last Period", _user!.lastPeriodDate),
              _buildItem("Medical History", _user!.medicalHistory.isEmpty ? "N/A" : _user!.medicalHistory),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'ComicNeue'),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontFamily: 'ComicNeue'),
            ),
          ),
        ],
      ),
    );
  }
}
