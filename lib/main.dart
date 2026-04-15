import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_utilities/features/converter/unit_converter_screen.dart';
import 'features/currency/currency_converter_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/note.dart';
import 'features/notes/notes_screen.dart';
import 'features/bmi/bmi_calculator_screen.dart';
import 'models/task.dart';
import 'features/tasks/tasks_screen.dart';

import 'core/theme.dart';
import 'features/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());          
  await Hive.openBox<Note>('notes');   
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasks');          

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Smart Utilities',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/converter', builder: (context, state) => const UnitConverterScreen()),
    GoRoute(path: '/currency', builder: (context, state) => const CurrencyConverterScreen()),
    GoRoute(path: '/notes', builder: (context, state) => const NotesScreen()),
    GoRoute(path: '/bmi', builder: (context, state) => const BmiCalculatorScreen()),
    GoRoute(path: '/tasks', builder: (context, state) => const TasksScreen()),
  ],
);