// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAAcLfXFqs5eFL3wZXCk8e5KYPWGQVQVa0',
    appId: '1:1060682944775:web:15aec4603d50ad9c8675a2',
    messagingSenderId: '1060682944775',
    projectId: 'news-list-d4659',
    authDomain: 'news-list-d4659.firebaseapp.com',
    storageBucket: 'news-list-d4659.appspot.com',
    measurementId: 'G-91RX8Q95BM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDLN9CAAZ7YcpLWoPzAtBpV-i81BXWHFNw',
    appId: '1:1060682944775:android:6c1f7d714a2164098675a2',
    messagingSenderId: '1060682944775',
    projectId: 'news-list-d4659',
    storageBucket: 'news-list-d4659.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDUJvtFPouPoglafDDiN4HQnjWMXVR9EpA',
    appId: '1:1060682944775:ios:43a7007cf2b6895b8675a2',
    messagingSenderId: '1060682944775',
    projectId: 'news-list-d4659',
    storageBucket: 'news-list-d4659.appspot.com',
    iosClientId: '1060682944775-kqlll6ele6kp2eplf0s8kmo0sam1i894.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApplication1',
  );
}
