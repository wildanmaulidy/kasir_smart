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
    apiKey: 'AIzaSyChKPd7c-V9WYFXyD6SbXwhopEsWhlky9Q',
    appId: '1:766113468484:web:b9cdb10c51c35ec54eac11',
    messagingSenderId: '766113468484',
    projectId: 'kasir-smart-d11a8',
    authDomain: 'kasir-smart-d11a8.firebaseapp.com',
    storageBucket: 'kasir-smart-d11a8.firebasestorage.app',
    measurementId: 'G-XXXXXXXXXX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyChKPd7c-V9WYFXyD6SbXwhopEsWhlky9Q',
    appId: '1:766113468484:android:b9cdb10c51c35ec54eac11',
    messagingSenderId: '766113468484',
    projectId: 'kasir-smart-d11a8',
    authDomain: 'kasir-smart-d11a8.firebaseapp.com',
    storageBucket: 'kasir-smart-d11a8.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyChKPd7c-V9WYFXyD6SbXwhopEsWhlky9Q',
    appId: '1:766113468484:ios:b9cdb10c51c35ec54eac11',
    messagingSenderId: '766113468484',
    projectId: 'kasir-smart-d11a8',
    authDomain: 'kasir-smart-d11a8.firebaseapp.com',
    storageBucket: 'kasir-smart-d11a8.firebasestorage.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyChKPd7c-V9WYFXyD6SbXwhopEsWhlky9Q',
    appId: '1:766113468484:macos:b9cdb10c51c35ec54eac11',
    messagingSenderId: '766113468484',
    projectId: 'kasir-smart-d11a8',
    authDomain: 'kasir-smart-d11a8.firebaseapp.com',
    storageBucket: 'kasir-smart-d11a8.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyChKPd7c-V9WYFXyD6SbXwhopEsWhlky9Q',
    appId: '1:766113468484:windows:b9cdb10c51c35ec54eac11',
    messagingSenderId: '766113468484',
    projectId: 'kasir-smart-d11a8',
    authDomain: 'kasir-smart-d11a8.firebaseapp.com',
    storageBucket: 'kasir-smart-d11a8.firebasestorage.app',
  );
}