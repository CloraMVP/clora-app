import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../services/firestore_service.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream to listen to auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // ✅ Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final exists = await FirestoreService.getUserProfile(user.uid);
        if (exists == null) {
          final newUser = AppUser(
            name: user.displayName ?? '',
            email: user.email ?? '',
            dob: '',
            phone: user.phoneNumber ?? '',
            city: '',
            lastPeriodDate: '01-06-2024',
            medicalHistory: '',
            cycleLength: 28,
          );
          await FirestoreService.saveUserProfile(user.uid, newUser.toMap());
        }
      }

      return userCredential;
    } catch (e) {
      print("❌ Google Sign-In Error: $e");
      return null;
    }
  }

  // ✅ Sign out
  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
      await _auth.signOut();
    } catch (e) {
      print("❌ Sign out error: $e");
    }
  }

  // ✅ Delete account
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) await user.delete();
    } catch (e) {
      print("❌ Delete account error: $e");
    }
  }
}
