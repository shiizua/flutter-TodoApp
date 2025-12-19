// Widgets Material
import 'package:flutter/material.dart';

// Bloc / Cubit
import 'package:flutter_bloc/flutter_bloc.dart';

// Cubit et états d’authentification
import '../blocs/auth_cubit.dart';
import '../blocs/auth_state.dart';

// Widget personnalisé pour les champs d’authentification
import '../widgets/auth_input.dart';

// Couleurs personnalisées
import '../ui/app_colors.dart';

// Page de connexion
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Clé du formulaire pour la validation
  final _formKey = GlobalKey<FormState>();

  // Controllers pour récupérer email et mot de passe
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  // Libération des ressources mémoire
  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  // Validation de l’email
  String? _emailValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email requis';
    return null;
  }

  // Validation du mot de passe
  String? _passValidator(String? v) {
    if (v == null || v.isEmpty) return 'Mot de passe requis';
    return null;
  }

  // Action lors du clic sur "Se connecter"
  void _onLogin() {
    // Validation du formulaire
    if (!_formKey.currentState!.validate()) return;

    // Appel du Cubit pour la connexion
    context.read<AuthCubit>().login(
      _emailCtrl.text.trim(),
      _passCtrl.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Écoute des changements d’état d’authentification
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          // Si connexion réussie → redirection vers Home
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacementNamed('/home');

            // Si erreur → affichage d’un message
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },

        // Contenu principal
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4E7D96), Color(0xFFFF844B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 14,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Titre
                      Text(
                        'Bienvenue',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 8),

                      // Sous-titre
                      const Text(
                        'Connecte-toi pour accéder à tes tâches',
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 20),

                      // Formulaire de connexion
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Champ email
                            AuthInput(
                              hint: 'Email',
                              controller: _emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              validator: _emailValidator,
                            ),

                            const SizedBox(height: 12),

                            // Champ mot de passe
                            AuthInput(
                              hint: 'Mot de passe',
                              controller: _passCtrl,
                              obscure: true,
                              validator: _passValidator,
                            ),

                            const SizedBox(height: 20),

                            // Bouton ou loader selon l’état
                            BlocBuilder<AuthCubit, AuthState>(
                              builder: (context, state) {
                                return state is AuthLoading
                                    ? const CircularProgressIndicator()
                                    : SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: _onLogin,
                                          child: const Text('Se connecter'),
                                        ),
                                      );
                              },
                            ),

                            const SizedBox(height: 12),

                            // Lien vers l’inscription
                            TextButton(
                              onPressed: () => Navigator.of(
                                context,
                              ).pushReplacementNamed('/register'),
                              child: const Text(
                                'Pas encore de compte ? S\'inscrire',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
