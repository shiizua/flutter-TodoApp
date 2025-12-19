// Import du package Bloc pour utiliser Cubit (gestion d’état)
import 'package:bloc/bloc.dart';

// Import de Firebase Auth pour gérer l’authentification
import 'package:firebase_auth/firebase_auth.dart';

// Import du repository qui contient la logique Firebase
import '../repositories/auth_repository.dart';

// Import des différents états d’authentification
import 'auth_state.dart';

// AuthCubit gère tous les états liés à l’authentification
class AuthCubit extends Cubit<AuthState> {
  // Repository d’authentification (abstraction de Firebase)
  final AuthRepository _repo;

  // Constructeur du Cubit
  // AuthInitial est l’état par défaut au démarrage
  AuthCubit(this._repo) : super(AuthInitial()) {
    // Récupération de l’utilisateur actuellement connecté (s’il existe)
    final user = _repo.currentUser;

    // Si un utilisateur est déjà connecté
    if (user != null) {
      // On émet l’état AuthAuthenticated avec les infos de l’utilisateur
      emit(AuthAuthenticated(user));
    } else {
      // Sinon, l’utilisateur n’est pas authentifié
      emit(AuthUnauthenticated());
    }
  }

  // Méthode d’inscription (register)
  Future<void> register(String email, String password) async {
    // État de chargement pendant l’opération
    emit(AuthLoading());

    try {
      // Appel du repository pour créer un compte avec email et mot de passe
      final cred = await _repo.registerWithEmail(email, password);

      // Si l’inscription réussit, on passe à l’état authentifié
      emit(AuthAuthenticated(cred.user!));
    } on FirebaseAuthException catch (e) {
      // Gestion des erreurs spécifiques à Firebase
      emit(AuthFailure(e.message ?? 'Erreur inconnue'));

      // Après une erreur, on revient à l’état non authentifié
      emit(AuthUnauthenticated());
    } catch (e) {
      // Gestion des autres erreurs possibles
      emit(AuthFailure(e.toString()));

      // Retour à l’état non authentifié
      emit(AuthUnauthenticated());
    }
  }

  // Méthode de connexion (login)
  Future<void> login(String email, String password) async {
    // État de chargement
    emit(AuthLoading());

    try {
      // Appel du repository pour se connecter
      final cred = await _repo.signInWithEmail(email, password);

      // Connexion réussie → utilisateur authentifié
      emit(AuthAuthenticated(cred.user!));
    } on FirebaseAuthException catch (e) {
      // Erreurs Firebase (mauvais mot de passe, email inexistant, etc.)
      emit(AuthFailure(e.message ?? 'Erreur inconnue'));
      emit(AuthUnauthenticated());
    } catch (e) {
      // Autres erreurs
      emit(AuthFailure(e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  // Méthode de déconnexion (logout)
  Future<void> logout() async {
    // Appel du repository pour déconnecter l’utilisateur
    await _repo.signOut();

    // Après la déconnexion, l’état devient non authentifié
    emit(AuthUnauthenticated());
  }
}
