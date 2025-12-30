import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return const FirebaseOptions(
        apiKey: "AIzaSyBBQCJ8YtV82eukupkl0T0D2wZda7hZ6Wk",
        authDomain: "alleytranscriber.firebaseapp.com",
        projectId: "alleytranscriber",
        storageBucket: "alleytranscriber.firebasestorage.appspot.com",
        messagingSenderId: "483613424128",
        appId: "1:483613424128:web:fbc2d6cdd7e78c135876e5"
      );
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }
}