// Import des widgets Material
import 'package:flutter/material.dart';

// Import de flutter_bloc pour accéder au Cubit
import 'package:flutter_bloc/flutter_bloc.dart';

// Import du TaskCubit
import '../blocs/task_cubit.dart';

// Import du modèle Task
import '../models/task_model.dart';

// Page utilisée pour ajouter ou modifier une tâche
class AddEditTaskPage extends StatefulWidget {
  const AddEditTaskPage({super.key});

  @override
  State<AddEditTaskPage> createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  // Clé du formulaire pour la validation
  final _formKey = GlobalKey<FormState>();

  // Controllers pour récupérer les valeurs saisies
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  // Indique si on est en mode modification
  bool _isEdit = false;

  // Index de la tâche à modifier
  int? _editIndex;

  // Tâche en cours de modification
  TaskModel? _editingTask;

  // Récupère les paramètres passés lors de la navigation
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Récupération des arguments de la route
    final args = ModalRoute.of(context)?.settings.arguments;

    // Si des données sont fournies et qu’on n’a pas encore initialisé l’édition
    if (args is Map && !_isEdit && args['task'] is TaskModel) {
      // Initialisation du mode édition
      _editingTask = args['task'];
      _editIndex = args['index'];

      // Pré-remplissage des champs du formulaire
      _titleCtrl.text = _editingTask!.title;
      _descCtrl.text = _editingTask!.description ?? "";

      // Activation du mode modification
      _isEdit = true;
    }
  }

  // Méthode pour enregistrer (ajout ou modification)
  Future<void> _save() async {
    // Validation du formulaire
    if (!_formKey.currentState!.validate()) return;

    // Récupération du TaskCubit
    final taskCubit = context.read<TaskCubit>();

    try {
      // Si on est en mode modification
      if (_isEdit) {
        await taskCubit.updateTaskAt(
          _editIndex!,
          TaskModel(
            id: _editingTask!.id,
            title: _titleCtrl.text.trim(),
            description: _descCtrl.text.trim(),
            createdAt: _editingTask!.createdAt,
            isDone: _editingTask!.isDone,
          ),
        );
      } else {
        // Sinon, ajout d’une nouvelle tâche
        await taskCubit.addTask(_titleCtrl.text.trim(), _descCtrl.text.trim());
      }

      // Retour à l’écran précédent après succès
      if (mounted) Navigator.pop(context);
    } catch (e) {
      // Affichage d’un message d’erreur en cas de problème
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Erreur lors de l'ajout: $e")));
      }
    }
  }

  // Libération des ressources mémoire
  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  // Construction de l’interface utilisateur
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? "Modifier" : "Nouvelle tâche")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Champ titre (obligatoire)
              TextFormField(
                controller: _titleCtrl,
                validator: (v) => v!.isEmpty ? 'Titre requis' : null,
                decoration: const InputDecoration(labelText: "Titre"),
              ),

              const SizedBox(height: 12),

              // Champ description (optionnel)
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: "Description"),
              ),

              const SizedBox(height: 20),

              // Bouton d’action (Ajouter / Modifier)
              ElevatedButton(
                onPressed: () async {
                  await _save();
                },
                child: Text(_isEdit ? "Modifier" : "Ajouter"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
