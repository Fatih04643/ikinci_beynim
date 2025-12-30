import '../entities/task.dart';

abstract class TaskRepository {
  Future<List<AppTask>> getTasks();
  Future<AppTask?> getTaskById(String id);
  Future<void> addTask(AppTask task);
  Future<void> updateTask(AppTask task);
  Future<void> deleteTask(String id);
  Future<void> toggleTaskCompletion(String id);
}
