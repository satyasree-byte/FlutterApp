// NOTE: This file is for Firebase WEB only.  
// Replace values with your Firebase project config.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError('This app is for web only.');
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyCDg0zuZk3kd4M-dBvZzYsWSGgUyBV2sng",
    authDomain: "eduviseai.firebaseapp.com",
    projectId: "eduviseai",
    storageBucket: "eduviseai.firebasestorage.app",
    messagingSenderId: "160299515196",
    appId: "1:160299515196:web:d144a2c1ff944b1f7ab239",
    measurementId: "G-23B2YYBTT6"
  );

}