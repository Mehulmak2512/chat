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
        return macos;
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
    apiKey: 'AIzaSyCFRXlR0iEGBVD1zKP8CgccpuhdNSd7XzU',
    appId: '1:60188505320:web:9caa979f53a034f66ac55d',
    messagingSenderId: '60188505320',
    projectId: 'chatapp-c526f',
    authDomain: 'chatapp-c526f.firebaseapp.com',
    storageBucket: 'chatapp-c526f.appspot.com',
    measurementId: 'G-QMHETSS409',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDVzzieWOtqfVfp7eTYDrgpOFEkcOjCIRY',
    appId: '1:60188505320:android:1e201ea23d6719fa6ac55d',
    messagingSenderId: '60188505320',
    projectId: 'chatapp-c526f',
    storageBucket: 'chatapp-c526f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAh6_R93kp4dPbL6wzUR0pOJr67uGJTCJg',
    appId: '1:60188505320:ios:b0bcb56b02c968476ac55d',
    messagingSenderId: '60188505320',
    projectId: 'chatapp-c526f',
    storageBucket: 'chatapp-c526f.appspot.com',
    iosBundleId: 'com.example.chatapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAh6_R93kp4dPbL6wzUR0pOJr67uGJTCJg',
    appId: '1:60188505320:ios:765cb01769d0e5cc6ac55d',
    messagingSenderId: '60188505320',
    projectId: 'chatapp-c526f',
    storageBucket: 'chatapp-c526f.appspot.com',
    iosBundleId: 'com.example.chatapp.RunnerTests',
  );
}
