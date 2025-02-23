// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyCC4tSFZv6rTWKIocjVq7PwRmHAv7-qhns',
    appId: '1:760340654864:web:f53ce59ac41f9c5f03d395',
    messagingSenderId: '760340654864',
    projectId: 'chassis-sheet-app',
    authDomain: 'chassis-sheet-app.firebaseapp.com',
    databaseURL: 'https://chassis-sheet-app-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'chassis-sheet-app.firebasestorage.app',
    measurementId: 'G-PJ8XSXGVPE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCiA-peNc5-4KyhduM9bNL8u_8tG_pJbXU',
    appId: '1:760340654864:android:988794bd0504bcbe03d395',
    messagingSenderId: '760340654864',
    projectId: 'chassis-sheet-app',
    databaseURL: 'https://chassis-sheet-app-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'chassis-sheet-app.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCC4tSFZv6rTWKIocjVq7PwRmHAv7-qhns',
    appId: '1:760340654864:web:622da2a55d6e8ce903d395',
    messagingSenderId: '760340654864',
    projectId: 'chassis-sheet-app',
    authDomain: 'chassis-sheet-app.firebaseapp.com',
    databaseURL: 'https://chassis-sheet-app-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'chassis-sheet-app.firebasestorage.app',
    measurementId: 'G-WMFD6QRSPH',
  );
}
