# flutter-TaskMe
# 📱 TaskMe - Application de Gestion des Tâches

Application mobile de gestion des tâches développée avec Flutter, offrant une expérience utilisateur moderne avec authentification, persistance locale et synchronisation cloud.

## 📋 Description

TaskMe est une application mobile complète permettant aux utilisateurs authentifiés de gérer efficacement leurs tâches quotidiennes. L'application combine une persistance locale robuste avec une synchronisation vers une API REST, garantissant l'accès aux données même hors ligne.

## ✨ Fonctionnalités

### Authentification
- 🔐 Inscription avec email et mot de passe
- 🔑 Connexion sécurisée via Firebase Authentication
- 🚪 Déconnexion
- ⚠️ Gestion complète des erreurs d'authentification

### Gestion des Tâches
- ➕ Ajouter de nouvelles tâches
- ✏️ Modifier les tâches existantes
- ✅ Marquer les tâches comme terminées
- 🗑️ Supprimer les tâches avec confirmation
- 📊 Visualisation de la progression

### Interface Utilisateur
- 🌓 Mode sombre / mode clair
- 👆 Swipe pour supprimer
- 📱 Design responsive adapté aux mobiles
- 💫 Navigation fluide et intuitive
- 🎨 Interface Material Design moderne

### Persistance et Synchronisation
- 💾 Sauvegarde locale avec Hive
- ☁️ Synchronisation avec API REST
- 🔄 Accès aux données hors ligne

## 🛠️ Technologies Utilisées

| Technologie | Description |
|------------|-------------|
| **Flutter** | Framework open source de Google pour le développement multiplateforme |
| **Dart** | Langage de programmation optimisé pour les applications multiplateformes |
| **Firebase Authentication** | Service d'authentification sécurisée |
| **Hive** | Base de données NoSQL locale légère et rapide |
| **BLoC / Cubit** | Architecture de gestion d'état |
| **HTTP** | Communication avec l'API REST |
| **JSON Server** | API REST pour la synchronisation des données |

## 🏗️ Architecture

Le projet suit une architecture claire et modulaire :

```
lib/
├── models/          # Modèles de données (TaskModel)
├── repositories/    # Gestion de l'accès aux données (Hive + API)
├── blocs/          # Logique métier et gestion des états
│   ├── AuthCubit
│   └── TaskCubit
├── pages/          # Écrans de l'application
│   ├── Login
│   ├── Register
│   ├── Home
│   └── Add/Edit Task
├── services/       # Communication avec l'API REST
├── ui/             # Thèmes, couleurs et styles globaux
└── widgets/        # Composants réutilisables
```

### Gestion d'État (AuthCubit)
- `AuthInitial` - État initial
- `AuthLoading` - Chargement en cours
- `AuthAuthenticated` - Utilisateur connecté
- `AuthUnauthenticated` - Utilisateur non connecté
- `AuthFailure` - Erreur d'authentification

## 📦 Installation

### Prérequis
- Flutter SDK (>=3.0.0)
- Dart (>=3.0.0)
- Un éditeur de code (VS Code, Android Studio, etc.)
- Un compte Firebase

### Étapes d'installation

1. **Cloner le repository**
```bash
git clone https://github.com/shiizua/flutter-TodoApp.git
cd flutter-TodoApp
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Configuration Firebase**
- Créer un projet Firebase
- Ajouter votre application Android/iOS
- Télécharger et placer les fichiers de configuration :
  - `google-services.json` dans `android/app/`
  - `GoogleService-Info.plist` dans `ios/Runner/`

4. **Lancer l'application**
```bash
flutter run
```

## 🔧 Configuration de l'API

L'application utilise JSON Server pour la synchronisation. Pour démarrer le serveur local :

```bash
npm install -g json-server
json-server --watch db.json --port 3000
```

## 🎯 Modèle de Données

### TaskModel
```dart
{
  id: String,           // Identifiant unique
  title: String,        // Titre de la tâche
  description: String,  // Description détaillée
  createdAt: DateTime,  // Date de création
  isCompleted: bool     // État de complétion
}
```

## 🔄 Flux de Synchronisation

1. **Ajout d'une tâche** :
   - Sauvegarde locale immédiate (Hive)
   - Envoi vers l'API REST (HTTP POST)
   - Mise à jour de l'interface

2. **Modification** :
   - Mise à jour locale
   - Synchronisation avec l'API (HTTP PUT)

3. **Suppression** :
   - Confirmation utilisateur
   - Suppression locale
   - Suppression distante (HTTP DELETE)

## 📚 Ressources

- [Flutter Documentation](https://docs.flutter.dev)
- [Dart Language](https://dart.dev)
- [Firebase Authentication](https://firebase.google.com/docs/auth)
- [Hive Database](https://docs.hivedb.dev)
- [BLoC Library](https://bloclibrary.dev)
- [JSON Server](https://github.com/typicode/json-server)
- [Material Design](https://m3.material.io)

## 📄 Licence

Ce projet est réalisé dans le cadre d'un projet académique.
---
