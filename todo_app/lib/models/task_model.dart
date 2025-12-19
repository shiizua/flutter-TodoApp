// Import de Hive pour la persistance locale
import 'package:hive/hive.dart';

// Annotation Hive indiquant que cette classe sera stockée localement
// typeId doit être unique dans toute l’application
@HiveType(typeId: 1)
class TaskModel {
  // Champ 0 : identifiant unique de la tâche
  @HiveField(0)
  final String id;

  // Champ 1 : titre de la tâche
  @HiveField(1)
  final String title;

  // Champ 2 : description (optionnelle)
  @HiveField(2)
  final String? description;

  // Champ 3 : date de création de la tâche
  @HiveField(3)
  final DateTime createdAt;

  // Champ 4 : état de la tâche (faite ou non)
  @HiveField(4)
  bool isDone;

  // Constructeur du modèle Task
  TaskModel({
    required this.id,
    required this.title,
    this.description,
    DateTime? createdAt,
    this.isDone = false,
  })
    // Si aucune date n’est fournie, on utilise la date actuelle
    : createdAt = createdAt ?? DateTime.now();
}
