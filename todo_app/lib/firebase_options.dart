// Ce fichier est généré automatiquement par FlutterFire CLI
// ignore_for_file: type=lint

// Firebase core pour initialiser l'application Firebase
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

// Pour détecter la plateforme actuelle
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Classe qui fournit les options de configuration Firebase
/// adaptées à chaque plateforme.
class DefaultFirebaseOptions {
  /// Retourne les options Firebase selon la plateforme courante
  /// (Android, iOS, Web, etc.)
  static FirebaseOptions get currentPlatform {
    // Web n'est pas encore configuré ici
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }

    // Détecte la plateforme et renvoie les options correspondantes
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android; // options Android
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  /// ================= CONFIGURATION ANDROID =================
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBxs8cgpt82u_3ZUojVYA30ARAuWgu0ssA', // clé API
    appId:
        '1:47402205508:android:7b5c2b5875c11a0c399711', // ID de l'application
    messagingSenderId: '47402205508', // ID de l'expéditeur FCM
    projectId: 'todofirebaseapp-9d2b0', // ID du projet Firebase
    storageBucket:
        'todofirebaseapp-9d2b0.firebasestorage.app', // bucket de stockage
  );
}
