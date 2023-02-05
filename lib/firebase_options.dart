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
    apiKey: 'AIzaSyBiVdkXFvNZDuAjC4fWeuuk8LL0MkzEJyU',
    appId: '1:449557740695:web:6dea479399bb514e1fbdd2',
    messagingSenderId: '449557740695',
    projectId: 'ladytabtab-f376c',
    authDomain: 'ladytabtab-f376c.firebaseapp.com',
    databaseURL: 'https://ladytabtab-f376c-default-rtdb.firebaseio.com',
    storageBucket: 'ladytabtab-f376c.appspot.com',
    measurementId: 'G-38HL15XN9L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCip2iu9I3ByUgsR80a6EmNapc97dtY4B0',
    appId: '1:449557740695:android:c3d547e91a74826c1fbdd2',
    messagingSenderId: '449557740695',
    projectId: 'ladytabtab-f376c',
    databaseURL: 'https://ladytabtab-f376c-default-rtdb.firebaseio.com',
    storageBucket: 'ladytabtab-f376c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDEzRjBTzYiLKkRECxtUgqrMn2LNcZ5mkM',
    appId: '1:449557740695:ios:a7260a360fb6d95c1fbdd2',
    messagingSenderId: '449557740695',
    projectId: 'ladytabtab-f376c',
    databaseURL: 'https://ladytabtab-f376c-default-rtdb.firebaseio.com',
    storageBucket: 'ladytabtab-f376c.appspot.com',
    androidClientId:
        '449557740695-kmhl175fc27li19ot82qq4ofbovj26fj.apps.googleusercontent.com',
    iosClientId:
        '449557740695-9avtn3t217l0o74v6vqui1ds6ptr3l2l.apps.googleusercontent.com',
    iosBundleId: 'io.ladytabtab.app',
  );
}
