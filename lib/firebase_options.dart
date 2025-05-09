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
        return macos;
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
    apiKey: 'AIzaSyCjostBZ1FnVE0_B-s4zZpY7O2G1HQt1io',
    appId: '1:1005644982563:web:2c03657084420233930496',
    messagingSenderId: '1005644982563',
    projectId: 'test-f8ebd',
    authDomain: 'test-f8ebd.firebaseapp.com',
    storageBucket: 'test-f8ebd.firebasestorage.app',
    measurementId: 'G-625Y7HZ65E',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDWUJFCjxL4DiRU0UMw5oSZp3iaRJjUkac',
    appId: '1:1005644982563:android:eb63bf8ae6d683c2930496',
    messagingSenderId: '1005644982563',
    projectId: 'test-f8ebd',
    storageBucket: 'test-f8ebd.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAEd4W0b2C-NPT7877NjzxFi2henp2c1t4',
    appId: '1:1005644982563:ios:d1c2f929c40bffa0930496',
    messagingSenderId: '1005644982563',
    projectId: 'test-f8ebd',
    storageBucket: 'test-f8ebd.firebasestorage.app',
    iosBundleId: 'com.example.jomiyaProjet',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAEd4W0b2C-NPT7877NjzxFi2henp2c1t4',
    appId: '1:1005644982563:ios:d1c2f929c40bffa0930496',
    messagingSenderId: '1005644982563',
    projectId: 'test-f8ebd',
    storageBucket: 'test-f8ebd.firebasestorage.app',
    iosBundleId: 'com.example.jomiyaProjet',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCjostBZ1FnVE0_B-s4zZpY7O2G1HQt1io',
    appId: '1:1005644982563:web:62b4b05a180d9ead930496',
    messagingSenderId: '1005644982563',
    projectId: 'test-f8ebd',
    authDomain: 'test-f8ebd.firebaseapp.com',
    storageBucket: 'test-f8ebd.firebasestorage.app',
    measurementId: 'G-29Q6M906YQ',
  );
}
