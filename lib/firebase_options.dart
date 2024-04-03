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
    apiKey: 'AIzaSyBzQrKmuXJCz3CvJk9sYSmgd6PvuTVLRVw',
    appId: '1:958188179535:web:080db8ae08f56fea005a3a',
    messagingSenderId: '958188179535',
    projectId: 'cloudimagetracking',
    authDomain: 'cloudimagetracking.firebaseapp.com',
    storageBucket: 'cloudimagetracking.appspot.com',
    measurementId: 'G-PDV3H4HYBS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBSZmvL2DQT6BZQd5dg5RjkhngW9srDG9U',
    appId: '1:958188179535:android:5e3adfd47a1fa9b6005a3a',
    messagingSenderId: '958188179535',
    projectId: 'cloudimagetracking',
    storageBucket: 'cloudimagetracking.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDvBxxszUZ5qVdRFyNCEMmtyCfMyR9HgMQ',
    appId: '1:958188179535:ios:acf7e3bc3317bab8005a3a',
    messagingSenderId: '958188179535',
    projectId: 'cloudimagetracking',
    storageBucket: 'cloudimagetracking.appspot.com',
    iosBundleId: 'com.example.trackingImageLocation',
  );
}
