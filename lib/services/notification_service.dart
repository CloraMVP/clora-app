import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final _messaging = FirebaseMessaging.instance;

  static Future<void> initFCM() async {
    // Request permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ Notification permission granted');

      // Get FCM token
      final token = await _messaging.getToken();
      print("🔑 FCM Token: $token");

      // TODO: Save token to Firestore under user profile if needed

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("📬 Foreground message: ${message.notification?.title}");
        if (message.notification != null) {
          final title = message.notification!.title ?? "New Message";
          final body = message.notification!.body ?? "";
          _showDialog(title, body);
        }
      });
    } else {
      print('❌ Notification permission declined');
    }
  }

  static void _showDialog(String title, String body) {
    // Shows an alert — works only if context is active.
    // You can connect this to a navigator key for global use.
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.pop(navigatorKey.currentContext!),
          ),
        ],
      ),
    );
  }
}

// Global key for showing alert dialogs without BuildContext
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
