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
    apiKey: 'AIzaSyB8cUBtV3MRE3OOa-nZbLIwa5ZXBrRJeYg',
    appId: '1:886544095346:web:3ed55ad0591231e63e0aeb',
    messagingSenderId: '886544095346',
    projectId: 'rastreiapet-11b60',
    authDomain: 'rastreiapet-11b60.firebaseapp.com',
    storageBucket: 'rastreiapet-11b60.appspot.com',
    measurementId: 'G-MD3L46HWMN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDuQa8oU2qnKACpQsadJ_-zLh1x5GJGQlM',
    appId: '1:886544095346:android:f953bb0ba9f00eaa3e0aeb',
    messagingSenderId: '886544095346',
    projectId: 'rastreiapet-11b60',
    storageBucket: 'rastreiapet-11b60.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDsRS8a-oq3EkFigQ2XmeTvFWfE4HLk3-I',
    appId: '1:886544095346:ios:b5cf184486c9d9d13e0aeb',
    messagingSenderId: '886544095346',
    projectId: 'rastreiapet-11b60',
    storageBucket: 'rastreiapet-11b60.appspot.com',
    iosBundleId: 'com.example.rastreiaPetApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDsRS8a-oq3EkFigQ2XmeTvFWfE4HLk3-I',
    appId: '1:886544095346:ios:b5cf184486c9d9d13e0aeb',
    messagingSenderId: '886544095346',
    projectId: 'rastreiapet-11b60',
    storageBucket: 'rastreiapet-11b60.appspot.com',
    iosBundleId: 'com.example.rastreiaPetApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB8cUBtV3MRE3OOa-nZbLIwa5ZXBrRJeYg',
    appId: '1:886544095346:web:38022046bf2c40db3e0aeb',
    messagingSenderId: '886544095346',
    projectId: 'rastreiapet-11b60',
    authDomain: 'rastreiapet-11b60.firebaseapp.com',
    storageBucket: 'rastreiapet-11b60.appspot.com',
    measurementId: 'G-Q651892LX3',
  );
}
