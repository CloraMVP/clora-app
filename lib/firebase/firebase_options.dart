// lib/firebase_options.dart

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBqxxxxxx-czY', // replaced part with xxxxx to hide full key
    appId: '1:10xxxxxxxx48:android:xxxxxxx6',
    messagingSenderId: '10xxxxxxxx8',
    projectId: 'clora-app-xxxx',
    storageBucket: 'clora-app-xxxx.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBqxxxxxx-czY',
    appId: '1:10xxxxxxxx48:ios:xxxxxxxxxx',
    messagingSenderId: '10xxxxxxxx8',
    projectId: 'clora-app-xxxx',
    storageBucket: 'clora-app-xxxx.appspot.com',
    iosBundleId: 'com.example.cloChatV3',
  );
}
