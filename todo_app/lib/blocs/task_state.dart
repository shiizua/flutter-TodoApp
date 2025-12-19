// Import d’Equatable pour comparer les états efficacement
import 'package:equatable/equatable.dart';

// Import du modèle Task
import '../models/task_model.dart';

// Classe abstraite représentant l’état des tâches
// Tous les états vont hériter de cette classe
abstract class TaskState extends Equatable {
  // props permet à Bloc de savoir si l’état a changé
  // Par défaut, aucun champ n’est comparé
  @override
  List<Object?> get props => [];
}

// État initial au lancement de l’application
class TaskInitial extends TaskState {}

// État de chargement (récupération des tâches)
class TaskLoading extends TaskState {}

// État quand les tâches sont chargées avec succès
class TaskLoaded extends TaskState {
  // Liste des tâches à afficher
  final List<TaskModel> tasks;

  // Constructeur
  TaskLoaded(this.tasks);

  // Deux états TaskLoaded sont considérés identiques
  // si la liste des tâches est la même
  @override
  List<Object?> get props => [tasks];
}

// État en cas d’erreur (lecture, écriture, suppression, etc.)
class TaskFailure extends TaskState {
  // Message d’erreur à afficher à l’utilisateur
  final String message;

  // Constructeur
  TaskFailure(this.message);

  // Deux états TaskFailure sont identiques si le message est le même
  @override
  List<Object?> get props => [message];
}
