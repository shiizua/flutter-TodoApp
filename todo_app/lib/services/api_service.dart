// Encodage JSON
import 'dart:convert';

// HTTP pour requêtes réseau
import 'package:http/http.dart' as http;

// Modèle de tâche
import '../models/task_model.dart';

/// Service pour interagir avec l’API distante (db.json)
/// Sépare la logique réseau du Repository / Cubit
class ApiService {
  // URL de base de l’API (ex: http://localhost:3000)
  final String baseUrl;

  // Constructeur obligatoire
  ApiService({required this.baseUrl});

  /// ================= AJOUT D'UNE TÂCHE =================
  /// POST → ajoute une tâche dans db.json
  Future<void> addTask(TaskModel task) async {
    // Création de l’URL complète
    final url = Uri.parse("$baseUrl/tasks");

    print("➡️ Envoi POST vers $url ...");

    try {
      // Requête POST
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": task.id,
          "title": task.title,
          "description": task.description ?? "",
          "createdAt": task.createdAt.toIso8601String(),
          "isDone": task.isDone,
        }),
      );

      // ✅ Vérification du succès
      if (response.statusCode == 201 || response.statusCode == 200) {
        print("✅ Tâche ajoutée dans db.json");

        // ❌ Gestion d’erreur si code différent
      } else {
        print("❌ Erreur API: ${response.statusCode} - ${response.body}");
        throw Exception(
          "Erreur lors de l'ajout de la tâche (status ${response.statusCode})",
        );
      }
    } catch (e) {
      // ⚠️ Gestion des exceptions réseau
      print("⚠️ Exception API → $e");
      throw Exception("Impossible de connecter à l'API: $e");
    }
  }
}
