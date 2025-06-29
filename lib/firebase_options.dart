// File generated manually by Atharva for Android-only Firebase setup.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;

/// Default [FirebaseOptions] for use with your Firebase Android app.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web. '
            'Run the FlutterFire CLI again if needed.',
      );
    }
    return android;
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBV8hf5ewf4mecwyG-WjmSYtp9h4HQocMY',
    appId: '1:803193545766:android:295f7dbc8518e4d0e832e7',
    messagingSenderId: '803193545766',
    projectId: 'clora-ai',
    storageBucket: 'clora-ai.firebasestorage.app',
  );
}
