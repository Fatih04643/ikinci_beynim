import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/database_helper.dart';
import '../models/task_model.dart';
import 'package:sqflite/sqflite.dart';

class TaskRepositoryImpl implements TaskRepository {
  final DatabaseHelper _databaseHelper;

  TaskRepositoryImpl(this._databaseHelper);

  @override
  Future<List<AppTask>> getTasks() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      orderBy: 'due_date ASC',
    );
    return List.generate(maps.length, (i) {
      return TaskModel.fromMap(maps[i]);
    });
  }

  @override
  Future<AppTask?> getTaskById(String id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return TaskModel.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<void> addTask(AppTask task) async {
    final db = await _databaseHelper.database;
    await db.insert(
      'tasks',
      TaskModel.fromEntity(task).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateTask(AppTask task) async {
    final db = await _databaseHelper.database;
    await db.update(
      'tasks',
      TaskModel.fromEntity(task).toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  @override
  Future<void> deleteTask(String id) async {
    final db = await _databaseHelper.database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> toggleTaskCompletion(String id) async {
    final db = await _databaseHelper.database;

    // First get the task to flip its boolean
    final task = await getTaskById(id);
    if (task != null) {
      final newStatus = !task.isCompleted;
      await db.rawUpdate(
        '''
        UPDATE tasks
        SET is_completed = ?
        WHERE id = ?
      ''',
        [newStatus ? 1 : 0, id],
      );
    }
  }
}
