import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/database_helper.dart';
import '../../data/repositories/habit_repository_impl.dart';
import '../../data/repositories/note_repository_impl.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/repositories/habit_repository.dart';
import '../../domain/repositories/note_repository.dart';
import '../../domain/repositories/task_repository.dart';

// --- Database Provider ---
final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper();
});

// --- Repository Providers ---
final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  final dbHelper = ref.watch(databaseHelperProvider);
  return NoteRepositoryImpl(dbHelper);
});

final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  final dbHelper = ref.watch(databaseHelperProvider);
  return HabitRepositoryImpl(dbHelper);
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final dbHelper = ref.watch(databaseHelperProvider);
  return TaskRepositoryImpl(dbHelper);
});
