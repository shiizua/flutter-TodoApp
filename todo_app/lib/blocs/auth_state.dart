// Import d’Equatable pour comparer les états facilement
import 'package:equatable/equatable.dart';

// Import de Firebase Auth pour le type User
import 'package:firebase_auth/firebase_auth.dart';

// Classe abstraite représentant l’état d’authentification
// Tous les états vont hériter de cette classe
abstract class AuthState extends Equatable {
  // props permet à Bloc de savoir quand un état a réellement changé
  // Ici, par défaut, aucun champ n’est comparé
  @override
  List<Object?> get props => [];
}

// État initial au lancement de l’application
class AuthInitial extends AuthState {}

// État de chargement (login, register en cours)
class AuthLoading extends AuthState {}

// État quand l’utilisateur est authentifié
class AuthAuthenticated extends AuthState {
  // Utilisateur Firebase connecté
  final User user;

  // Constructeur
  AuthAuthenticated(this.user);

  // On compare les états AuthAuthenticated grâce à l’uid de l’utilisateur
  // Si l’uid est le même, l’état est considéré identique
  @override
  List<Object?> get props => [user.uid];
}

// État quand aucun utilisateur n’est connecté
class AuthUnauthenticated extends AuthState {}

// État en cas d’erreur (mauvais mot de passe, email invalide, etc.)
class AuthFailure extends AuthState {
  // Message d’erreur à afficher à l’utilisateur
  final String message;

  // Constructeur
  AuthFailure(this.message);

  // Deux états AuthFailure sont identiques si le message est le même
  @override
  List<Object?> get props => [message];
}
