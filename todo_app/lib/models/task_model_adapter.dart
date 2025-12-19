// Import de Hive pour la persistance locale
import 'package:hive/hive.dart';

// Import du modèle Task
import 'task_model.dart';

// Adapter Hive permettant de sérialiser / désérialiser TaskModel
class TaskModelAdapter extends TypeAdapter<TaskModel> {
  // Identifiant unique du type dans Hive
  // Il doit être unique dans toute l’application
  @override
  final int typeId = 1;

  // Méthode appelée par Hive pour lire (désérialiser) un objet depuis le stockage
  @override
  TaskModel read(BinaryReader reader) {
    // Nombre de champs enregistrés
    final numOfFields = reader.readByte();

    // Lecture de chaque champ sous forme clé / valeur
    final fields = {
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    // Reconstruction de l’objet TaskModel à partir des champs lus
    return TaskModel(
      id: fields[0],
      title: fields[1],
      description: fields[2],
      createdAt: fields[3],
      isDone: fields[4],
    );
  }

  // Méthode appelée par Hive pour écrire (sérialiser) l’objet dans le stockage
  @override
  void write(BinaryWriter writer, TaskModel obj) {
    // Nombre total de champs enregistrés
    writer
      ..writeByte(5)
      // Champ 0 : id
      ..writeByte(0)
      ..write(obj.id)
      // Champ 1 : title
      ..writeByte(1)
      ..write(obj.title)
      // Champ 2 : description
      ..writeByte(2)
      ..write(obj.description)
      // Champ 3 : date de création
      ..writeByte(3)
      ..write(obj.createdAt)
      // Champ 4 : état de la tâche (faite ou non)
      ..writeByte(4)
      ..write(obj.isDone);
  }
}
