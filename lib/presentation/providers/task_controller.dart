import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/task.dart';
import 'providers.dart';

class TaskController extends AsyncNotifier<List<AppTask>> {
  @override
  Future<List<AppTask>> build() async {
    final repository = ref.watch(taskRepositoryProvider);
    return await repository.getTasks();
  }

  Future<void> addTask(String title) async {
    state = const AsyncValue.loading();
    final repository = ref.read(taskRepositoryProvider);
    final newTask = AppTask(
      id: const Uuid().v4(),
      title: title,
      isCompleted: false,
      dueDate: DateTime.now(), // Default to today/now for simplicity
    );
    state = await AsyncValue.guard(() async {
      await repository.addTask(newTask);
      return await repository.getTasks();
    });
  }

  Future<void> toggleTaskCompletion(String id) async {
    // Optimistic toggle logic can be applied, but simpler reload for now
    final repository = ref.read(taskRepositoryProvider);
    await repository.toggleTaskCompletion(id);

    state = await AsyncValue.guard(() async {
      return await repository.getTasks();
    });
  }

  Future<void> deleteTask(String id) async {
    state = const AsyncValue.loading();
    final repository = ref.read(taskRepositoryProvider);
    state = await AsyncValue.guard(() async {
      await repository.deleteTask(id);
      return await repository.getTasks();
    });
  }
}

final taskControllerProvider =
    AsyncNotifierProvider<TaskController, List<AppTask>>(() {
      return TaskController();
    });
