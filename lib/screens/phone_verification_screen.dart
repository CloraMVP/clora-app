import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import '../services/firestore_service.dart'; // ✅ To update phone in Firestore if needed

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({super.key});

  @override
  State<PhoneVerificationScreen> createState() => _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  String? _verificationId;
  bool _otpSent = false;
  bool _isLoading = false;
  String _countryCode = '+91';

  void _sendOtp() async {
    final phone = '$_countryCode${_phoneController.text.trim()}';
    if (_phoneController.text.trim().length < 6) {
      _showError("Please enter a valid phone number");
      return;
    }

    setState(() => _isLoading = true);

    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _linkWithCredential(credential, phone);
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() => _isLoading = false);
        _showError("Verification failed: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _otpSent = true;
          _isLoading = false;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  void _verifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      _showError("Enter a valid 6-digit OTP");
      return;
    }

    if (_verificationId == null) return;

    setState(() => _isLoading = true);

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );
      final phone = '$_countryCode${_phoneController.text.trim()}';
      await _linkWithCredential(credential, phone);
    } catch (e) {
      setState(() => _isLoading = false);
      _showError("Invalid OTP: $e");
    }
  }

  Future<void> _linkWithCredential(PhoneAuthCredential credential, String phone) async {
    try {
      final user = _auth.currentUser;

      if (user == null) throw Exception("No user signed in");

      final linkedProviders = user.providerData.map((p) => p.providerId).toList();

      if (linkedProviders.contains('phone')) {
        // Already linked → this shouldn't happen in flow
        _showError("Phone number already verified.");
        return;
      }

      await user.linkWithCredential(credential);
      print("✅ Phone number linked successfully");

      // Optionally: update Firestore user profile with phone
      await FirestoreService.updateUserField(user.uid, "phone", phone);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'provider-already-linked') {
        // Already linked, safe to proceed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else if (e.code == 'credential-already-in-use') {
        _showError("This phone number is already linked to another account.");
      } else {
        _showError("Error: ${e.message}");
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Phone Verification"),
        backgroundColor: Colors.purple.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              enabled: !_otpSent,
              decoration: InputDecoration(
                labelText: "Phone Number",
                prefixText: '$_countryCode ',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            if (_otpSent)
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: "Enter OTP",
                  border: OutlineInputBorder(),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : _otpSent
                  ? _verifyOtp
                  : _sendOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade600,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(_otpSent ? "Verify OTP" : "Send OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
