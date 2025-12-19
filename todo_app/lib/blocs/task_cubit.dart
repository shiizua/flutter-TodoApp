// Import de flutter_bloc pour utiliser Cubit (gestion d’état)
import 'package:flutter_bloc/flutter_bloc.dart';

// Import du repository qui gère la persistance des tâches
import '../repositories/task_repository.dart';

// Import du modèle Task
import '../models/task_model.dart';

// Import des états liés aux tâches
import 'task_state.dart';

// TaskCubit gère tous les états liés aux tâches (CRUD)
class TaskCubit extends Cubit<TaskState> {
  // Repository des tâches (source de données)
  final TaskRepository _repo;

  // Constructeur : état initial = TaskInitial
  TaskCubit(this._repo) : super(TaskInitial());

  // Initialisation du repository + chargement des tâches
  Future<void> init() async {
    // Initialisation de la source de données (ex: fichier local, base JSON, etc.)
    await _repo.init();

    // Chargement initial des tâches
    await loadTasks();
  }

  // Chargement de toutes les tâches
  Future<void> loadTasks() async {
    // État de chargement (utile pour afficher un loader)
    emit(TaskLoading());

    // Récupération des tâches depuis le repository
    // List.from permet d’éviter les effets de bord (copie propre)
    emit(TaskLoaded(List.from(_repo.getAll()))); // refresh propre
  }

  /// Ajout d’une tâche avec mise à jour immédiate de l’interface
  Future<void> addTask(String title, String? description) async {
    // Création de la tâche via le repository
    final newTask = await _repo.addTask(title: title, description: description);

    // Si les tâches sont déjà chargées
    if (state is TaskLoaded) {
      // On copie la liste actuelle des tâches
      final current = List<TaskModel>.from((state as TaskLoaded).tasks);

      // On ajoute la nouvelle tâche à la liste
      current.add(newTask);

      // On émet le nouvel état avec la liste mise à jour
      emit(TaskLoaded(current));
    } else {
      // Sinon, on recharge toutes les tâches
      await loadTasks();
    }
  }

  // Mise à jour d’une tâche à un index donné
  Future<void> updateTaskAt(int index, TaskModel updated) async {
    // Mise à jour dans la source de données
    await _repo.updateTask(index, updated);

    // Rechargement de la liste après modification
    await loadTasks();
  }

  // Marquer / démarquer une tâche comme terminée
  Future<void> toggleTask(TaskModel task, int index) async {
    // Création d’une nouvelle tâche avec l’état inversé (done / not done)
    await _repo.updateTask(
      index,
      TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        createdAt: task.createdAt,
        isDone: !task.isDone,
      ),
    );

    // Rafraîchissement de la liste
    await loadTasks();
  }

  // Suppression d’une tâche
  Future<void> deleteTask(int index) async {
    // Suppression via le repository
    await _repo.deleteTask(index);

    // Rechargement des tâches après suppression
    await loadTasks();
  }
}
