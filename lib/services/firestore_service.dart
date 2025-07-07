import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final _usersCollection = FirebaseFirestore.instance.collection('users');

  // Fetch user data from Firestore
  static Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final doc = await _usersCollection.doc(uid).get();
      if (doc.exists) {
        return doc.data();
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching user profile: $e");
      return null;
    }
  }

  // Save or update user profile
  static Future<void> saveUserProfile(String uid, Map<String, dynamic> userData) async {
    try {
      await _usersCollection.doc(uid).set(userData, SetOptions(merge: true));
    } catch (e) {
      print("Error saving user profile: $e");
    }
  }

  // ✅ Add this: Update a single field (e.g., phone number)
  static Future<void> updateUserField(String uid, String field, dynamic value) async {
    try {
      await _usersCollection.doc(uid).update({field: value});
      print("✅ Firestore: '$field' updated for user $uid");
    } catch (e) {
      print("❌ Firestore update error: $e");
    }
  }
}
