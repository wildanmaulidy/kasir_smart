import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyDUMMY_API_KEY_FOR_WEB',
    appId: '1:123456789012:web:abcdef1234567890abcdef',
    messagingSenderId: '123456789012',
    projectId: 'kasir-smart',
    authDomain: 'kasir-smart.firebaseapp.com',
    storageBucket: 'kasir-smart.appspot.com',
    measurementId: 'G-XXXXXXXXXX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDUMMY_API_KEY_FOR_ANDROID',
    appId: '1:123456789012:android:abcdef1234567890abcdef',
    messagingSenderId: '123456789012',
    projectId: 'kasir-smart',
    storageBucket: 'kasir-smart.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDUMMY_API_KEY_FOR_IOS',
    appId: '1:123456789012:ios:abcdef1234567890abcdef',
    messagingSenderId: '123456789012',
    projectId: 'kasir-smart',
    storageBucket: 'kasir-smart.appspot.com',
    iosBundleId: 'com.example.kasirSmart',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDUMMY_API_KEY_FOR_MACOS',
    appId: '1:123456789012:ios:abcdef1234567890abcdef',
    messagingSenderId: '123456789012',
    projectId: 'kasir-smart',
    storageBucket: 'kasir-smart.appspot.com',
    iosBundleId: 'com.example.kasirSmart',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDUMMY_API_KEY_FOR_WINDOWS',
    appId: '1:123456789012:web:abcdef1234567890abcdef',
    messagingSenderId: '123456789012',
    projectId: 'kasir-smart',
    authDomain: 'kasir-smart.firebaseapp.com',
    storageBucket: 'kasir-smart.appspot.com',
    measurementId: 'G-XXXXXXXXXX',
  );
}