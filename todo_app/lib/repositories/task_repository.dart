// Hive pour la persistance locale
import 'package:hive/hive.dart';

// UUID pour générer des identifiants uniques
import 'package:uuid/uuid.dart';

// Modèle de tâche
import '../models/task_model.dart';

// Service API pour la synchronisation
import '../services/api_service.dart';

/// Repository pour gérer les tâches
/// Sépare la logique métier (CRUD) de l’UI
class TaskRepository {
  // Boîte Hive pour stocker les tâches localement
  late Box<TaskModel> _box;

  // ID de l’utilisateur pour créer une box spécifique
  final String userId;

  // Service API pour synchronisation distante
  final ApiService api;

  // Constructeur : création du service API
  TaskRepository(this.userId, {required String apiBaseUrl})
    : api = ApiService(baseUrl: apiBaseUrl);

  /// Initialisation de la boîte Hive
  Future<void> init() async {
    _box = await Hive.openBox<TaskModel>('tasks_$userId');
  }

  /// Récupère toutes les tâches
  List<TaskModel> getAll() => _box.values.toList();

  /// ================= AJOUT =================
  /// Ajoute une tâche et retourne immédiatement l'objet pour le Cubit
  Future<TaskModel> addTask({
    required String title,
    String? description,
  }) async {
    // Création de la tâche avec un ID unique
    final task = TaskModel(
      id: const Uuid().v4(),
      title: title,
      description: description,
    );

    // 1️⃣ Ajout immédiat dans Hive → interface réactive
    await _box.add(task);

    // 2️⃣ Ajout dans l’API en arrière-plan (async non bloquant)
    api
        .addTask(task)
        .then((_) {
          print("Tâche ajoutée dans db.json");
        })
        .catchError((e) {
          print("Erreur ajout db.json: $e");
        });

    return task;
  }

  /// ================= MISE À JOUR =================
  /// Met à jour la tâche à l’index donné
  Future<void> updateTask(int index, TaskModel updated) async {
    await _box.putAt(index, updated);
  }

  /// ================= SUPPRESSION =================
  /// Supprime la tâche à l’index donné
  Future<void> deleteTask(int index) async {
    await _box.deleteAt(index);
  }
}
