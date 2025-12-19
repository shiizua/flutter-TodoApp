// Firebase Auth
import 'package:firebase_auth/firebase_auth.dart';

/// Repository pour gérer l'authentification avec Firebase
/// Sépare la logique métier (inscription, login, logout) de l'UI
class AuthRepository {
  // Instance de FirebaseAuth
  final FirebaseAuth _auth;

  // Constructeur : permet d'injecter une instance (utile pour les tests)
  AuthRepository({FirebaseAuth? firebaseAuth})
    : _auth = firebaseAuth ?? FirebaseAuth.instance;

  /// Récupère l'utilisateur actuellement connecté
  User? get currentUser => _auth.currentUser;

  /// ================= INSCRIPTION =================
  /// Crée un nouvel utilisateur avec email et mot de passe
  Future<UserCredential> registerWithEmail(
    String email,
    String password,
  ) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Gestion des erreurs Firebase avec message lisible
      throw FirebaseAuthException(
        code: e.code,
        message: e.message ?? "Erreur inconnue lors de l'inscription",
      );
    } catch (e) {
      // Toute autre erreur
      throw Exception("Erreur inconnue: $e");
    }
  }

  /// ================= CONNEXION =================
  /// Connecte un utilisateur existant avec email et mot de passe
  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Exemple de personnalisation d'un message d'erreur réseau
      if (e.code == 'network-request-failed') {
        throw FirebaseAuthException(
          code: e.code,
          message: "Erreur réseau : vérifie ta connexion Internet.",
        );
      }
      throw FirebaseAuthException(
        code: e.code,
        message: e.message ?? "Erreur inconnue lors de la connexion",
      );
    } catch (e) {
      throw Exception("Erreur inconnue: $e");
    }
  }

  /// ================= DECONNEXION =================
  /// Déconnecte l'utilisateur actuel
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
