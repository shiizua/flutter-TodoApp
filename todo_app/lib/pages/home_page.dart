// Widgets Material
import 'package:flutter/material.dart';

// Bloc / Cubit
import 'package:flutter_bloc/flutter_bloc.dart';

// Cubit et états d’authentification
import '../blocs/auth_cubit.dart';
import '../blocs/auth_state.dart';

// Cubit et états des tâches
import '../blocs/task_cubit.dart';
import '../blocs/task_state.dart';

// Modèle Task
import '../models/task_model.dart';

// Couleurs personnalisées
import '../ui/app_colors.dart';

// Page principale de l’application
class HomePage extends StatelessWidget {
  // Callback pour changer le thème (clair / sombre)
  final VoidCallback toggleTheme;

  const HomePage({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    // Récupération de l’état d’authentification
    final authState = context.select((AuthCubit c) => c.state);

    // Email de l’utilisateur connecté
    String email = '';
    if (authState is AuthAuthenticated) {
      email = authState.user.email ?? '';
    }

    return Scaffold(
      extendBodyBehindAppBar: true,

      /// ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('TaskMe'),
        actions: [
          // Bouton de déconnexion
          IconButton(
            onPressed: () async {
              await context.read<AuthCubit>().logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Se déconnecter',
          ),

          // Bouton changement de thème
          IconButton(
            icon: const Icon(Icons.dark_mode),
            tooltip: "Changer thème",
            onPressed: toggleTheme,
          ),
        ],
      ),

      /// ================= BOUTON AJOUT =================
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/add'),
        label: const Text('Ajouter'),
        icon: const Icon(Icons.add),
      ),

      body: SafeArea(
        child: Column(
          children: [
            /// ================= HEADER =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4E7D96), Color(0xFFC9E7EE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),

              child: Row(
                children: [
                  // Icône principale
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.pale,
                    child: Icon(Icons.task, color: AppColors.primary),
                  ),

                  const SizedBox(width: 12),

                  /// -------- EMAIL UTILISATEUR --------
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bonjour',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          email,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// -------- PROGRESSION DES TÂCHES --------
                  BlocBuilder<TaskCubit, TaskState>(
                    builder: (context, state) {
                      int total = 0;
                      int done = 0;

                      // Calcul des tâches terminées
                      if (state is TaskLoaded) {
                        total = state.tasks.length;
                        done = state.tasks.where((t) => t.isDone).length;
                      }

                      // Pourcentage de progression
                      final percent = total == 0 ? 0.0 : done / total;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "$done / $total",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Barre de progression
                          SizedBox(
                            width: 90,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: LinearProgressIndicator(
                                value: percent,
                                minHeight: 8,
                                backgroundColor: Colors.white24,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            /// ================= LISTE DES TÂCHES =================
            Expanded(
              child: BlocBuilder<TaskCubit, TaskState>(
                builder: (context, state) {
                  // Chargement
                  if (state is TaskLoading || state is TaskInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Erreur
                  if (state is TaskFailure) {
                    return Center(child: Text("Erreur : ${state.message}"));
                  }

                  // Tâches chargées
                  if (state is TaskLoaded) {
                    final tasks = state.tasks;

                    // Aucune tâche
                    if (tasks.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.inbox,
                              size: 80,
                              color: AppColors.primary.withOpacity(0.16),
                            ),
                            const SizedBox(height: 12),
                            const Text("Aucune tâche. Ajoute la première !"),
                          ],
                        ),
                      );
                    }

                    // Liste des tâches
                    return ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: tasks.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final task = tasks[index];

                        return Dismissible(
                          key: Key(task.id),

                          // Fond gauche (swipe)
                          background: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            color: AppColors.accent,
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),

                          // Fond droit (swipe)
                          secondaryBackground: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            color: AppColors.accent,
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),

                          // Confirmation avant suppression
                          confirmDismiss: (_) async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text("Supprimer ?"),
                                content: const Text(
                                  "Cette action est irréversible.",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text("Annuler"),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text("Supprimer"),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              context.read<TaskCubit>().deleteTask(index);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Tâche supprimée"),
                                ),
                              );
                              return true;
                            }
                            return false;
                          },

                          /// -------- CARTE TÂCHE --------
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),

                              // Checkbox tâche terminée
                              leading: Checkbox(
                                value: task.isDone,
                                onChanged: (_) => context
                                    .read<TaskCubit>()
                                    .toggleTask(task, index),
                              ),

                              // Titre
                              title: Text(
                                task.title,
                                style: TextStyle(
                                  decoration: task.isDone
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              // Description (optionnelle)
                              subtitle: (task.description?.isEmpty ?? true)
                                  ? null
                                  : Text(
                                      task.description!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                              // Bouton modifier
                              trailing: IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  '/edit',
                                  arguments: {"index": index, "task": task},
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
