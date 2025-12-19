// Widgets Flutter
import 'package:flutter/material.dart';

// Couleurs personnalisées de l'application
import '../ui/app_colors.dart';

/// Widget réutilisable pour les champs de saisie d'authentification
/// Ex : email, mot de passe
class AuthInput extends StatelessWidget {
  // Texte indicatif (hint) à afficher
  final String hint;

  // Masquer le texte (utile pour le mot de passe)
  final bool obscure;

  // Contrôleur pour récupérer ou modifier la valeur
  final TextEditingController controller;

  // Type de clavier (email, texte, nombre...)
  final TextInputType keyboardType;

  // Fonction de validation (null si pas de validation)
  final String? Function(String?)? validator;

  // Constructeur avec paramètres obligatoires et optionnels
  const AuthInput({
    super.key,
    required this.hint,
    required this.controller,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // Type de clavier
      keyboardType: keyboardType,

      // Masquer le texte si c’est un mot de passe
      obscureText: obscure,

      // Lier le controller pour récupérer/mettre à jour la valeur
      controller: controller,

      // Validation du champ
      validator: validator,

      // Décoration du champ
      decoration: InputDecoration(
        hintText: hint,
        filled: true, // fond coloré
        fillColor: AppColors.pale == Colors.white ? Colors.white : Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none, // pas de bordure visible
        ),
      ),
    );
  }
}
