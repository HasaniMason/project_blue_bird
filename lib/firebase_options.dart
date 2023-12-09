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
    apiKey: 'AIzaSyAzA4GGkM4zW_qOavDrLvwaOU6qyR97cw0',
    appId: '1:206059526991:web:32ab1ed725362b2fed033a',
    messagingSenderId: '206059526991',
    projectId: 'project-blue-bird',
    authDomain: 'project-blue-bird.firebaseapp.com',
    storageBucket: 'project-blue-bird.appspot.com',
    measurementId: 'G-RQHDZX4DF3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDHIi2Zm8dagfxLEa20Ia5eoLpT5GaxdBM',
    appId: '1:206059526991:android:4d98f276bb61b5e9ed033a',
    messagingSenderId: '206059526991',
    projectId: 'project-blue-bird',
    storageBucket: 'project-blue-bird.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCs2qPC3Kou2osAOCOpWEWRXTcUw_pw6wg',
    appId: '1:206059526991:ios:e9cc35134fa27abeed033a',
    messagingSenderId: '206059526991',
    projectId: 'project-blue-bird',
    storageBucket: 'project-blue-bird.appspot.com',
    iosBundleId: 'com.example.projectBlueBird',
  );
}
