// Widgets Material
import 'package:flutter/material.dart';

// Bloc / Cubit
import 'package:flutter_bloc/flutter_bloc.dart';

// Cubit et états d’authentification
import '../blocs/auth_cubit.dart';
import '../blocs/auth_state.dart';

// Widget personnalisé pour les champs
import '../widgets/auth_input.dart';

// Couleurs de l’application
import '../ui/app_colors.dart';

// Page d’inscription
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Clé du formulaire pour gérer la validation
  final _formKey = GlobalKey<FormState>();

  // Controllers pour récupérer les données saisies
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  // Libération de la mémoire
  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  // Validation de l’email
  String? _emailValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email requis';

    // Expression régulière pour vérifier le format email
    final re = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!re.hasMatch(v)) return 'Email invalide';

    return null;
  }

  // Validation du mot de passe
  String? _passValidator(String? v) {
    if (v == null || v.length < 6) {
      return 'Mot de passe min 6 caractères';
    }
    return null;
  }

  // Action lors du clic sur "S'inscrire"
  void _onRegister() {
    // Vérification du formulaire
    if (!_formKey.currentState!.validate()) return;

    // Appel du Cubit pour l’inscription
    context.read<AuthCubit>().register(
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
          // Inscription réussie → redirection vers Home
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacementNamed('/home');

            // Erreur → message SnackBar
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },

        // Interface utilisateur
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
                        'Créer un compte',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 8),

                      // Sous-titre
                      const Text(
                        'Rejoins TaskMe — organise tes tâches avec style',
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 20),

                      // Formulaire d’inscription
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
                                          onPressed: _onRegister,
                                          child: const Text('S\'inscrire'),
                                        ),
                                      );
                              },
                            ),

                            const SizedBox(height: 12),

                            // Lien vers la page de connexion
                            TextButton(
                              onPressed: () => Navigator.of(
                                context,
                              ).pushReplacementNamed('/login'),
                              child: const Text(
                                'Tu as déjà un compte ? Connexion',
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
