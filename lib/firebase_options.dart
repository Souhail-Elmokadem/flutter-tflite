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
    apiKey: 'AIzaSyB3CTn2WiYs1Fmx1lTEJzhqyMu_lJN8eOc',
    appId: '1:838698177412:web:002d5daea4a129659803d1',
    messagingSenderId: '838698177412',
    projectId: 'g-tasks-8000c',
    authDomain: 'g-tasks-8000c.firebaseapp.com',
    storageBucket: 'g-tasks-8000c.firebasestorage.app',
    measurementId: 'G-JZG2SYESMS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAfnsbaZf5ETa5YnAKrGAy1Ma1YoHu-eO8',
    appId: '1:838698177412:android:727ca5d297d798ec9803d1',
    messagingSenderId: '838698177412',
    projectId: 'g-tasks-8000c',
    storageBucket: 'g-tasks-8000c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCijmWw9_M6V1QXtLPeFlgVuZmaguvGMVg',
    appId: '1:838698177412:ios:b8de2757942895a29803d1',
    messagingSenderId: '838698177412',
    projectId: 'g-tasks-8000c',
    storageBucket: 'g-tasks-8000c.firebasestorage.app',
    iosBundleId: 'com.example.testtp1android',
  );
}