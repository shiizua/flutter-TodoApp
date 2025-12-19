// Flutter et UI
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';

// =================== Auth ===================
import 'repositories/auth_repository.dart';
import 'blocs/auth_cubit.dart';
import 'blocs/auth_state.dart';

// =================== Tasks ==================
import 'repositories/task_repository.dart';
import 'blocs/task_cubit.dart';

// =================== Models =================
import 'models/task_model.dart';
import 'models/task_model_adapter.dart';

// =================== Pages ==================
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'pages/add_edit_task_page.dart';

// =================== UI =====================
import 'ui/app_theme.dart';

/// Fonction principale
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Obligatoire pour async avant runApp

  // Initialisation Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialisation Hive (stockage local)
  await Hive.initFlutter();

  // Enregistrement de l'adapter pour TaskModel
  Hive.registerAdapter(TaskModelAdapter());

  // Lancement de l'application
  runApp(const MyApp());
}

/// Widget racine de l’application
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Gestion du thème clair/sombre
  final ValueNotifier<bool> isDark = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final authRepo = AuthRepository(); // Repository pour l’authentification

    return RepositoryProvider.value(
      value: authRepo, // Fournit AuthRepository à toute l’app
      child: BlocProvider(
        create: (_) => AuthCubit(authRepo), // Bloc pour l’authentification
        child: ValueListenableBuilder<bool>(
          valueListenable: isDark,
          builder: (_, dark, __) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                TaskCubit? taskCubit;

                // Si l’utilisateur est connecté, créer le TaskCubit
                if (state is AuthAuthenticated) {
                  taskCubit = TaskCubit(
                    TaskRepository(
                      state.user.uid,
                      apiBaseUrl:
                          'http://10.0.2.2:3000', // Important pour émulateur Android
                    ),
                  )..init(); // Chargement initial des tâches
                }

                return MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: context.read<AuthCubit>()),
                    if (taskCubit != null) BlocProvider.value(value: taskCubit),
                  ],
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'TaskMe',

                    // Thèmes clair et sombre
                    theme: appTheme,
                    darkTheme: ThemeData.dark(),
                    themeMode: dark ? ThemeMode.dark : ThemeMode.light,

                    // Page de départ selon l’état d’authentification
                    initialRoute: state is AuthAuthenticated
                        ? '/home'
                        : '/login',

                    // Routes nommées de l’application
                    routes: {
                      '/login': (_) => const LoginPage(),
                      '/register': (_) => const RegisterPage(),
                      '/home': (_) => HomePage(
                        toggleTheme: () {
                          isDark.value = !isDark.value; // Changement thème
                        },
                      ),
                      '/add': (_) => const AddEditTaskPage(),
                      '/edit': (_) => const AddEditTaskPage(),
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
