import '../../domain/entities/habit.dart';
import '../../domain/repositories/habit_repository.dart';
import '../datasources/database_helper.dart';
import '../models/habit_model.dart';
import 'package:sqflite/sqflite.dart';

class HabitRepositoryImpl implements HabitRepository {
  final DatabaseHelper _databaseHelper;

  HabitRepositoryImpl(this._databaseHelper);

  @override
  Future<List<Habit>> getHabits() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('habits');
    return List.generate(maps.length, (i) {
      return HabitModel.fromMap(maps[i]);
    });
  }

  @override
  Future<Habit?> getHabitById(String id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return HabitModel.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<void> addHabit(Habit habit) async {
    final db = await _databaseHelper.database;
    await db.insert(
      'habits',
      HabitModel.fromEntity(habit).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateHabit(Habit habit) async {
    final db = await _databaseHelper.database;
    await db.update(
      'habits',
      HabitModel.fromEntity(habit).toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  @override
  Future<void> deleteHabit(String id) async {
    final db = await _databaseHelper.database;
    await db.delete('habits', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> logHabitProgress(String id, int progress) async {
    // In a real app we might want to log history, but for now we just update 'current'
    final db = await _databaseHelper.database;
    await db.rawUpdate(
      '''
        UPDATE habits 
        SET current = ?, last_updated = ? 
        WHERE id = ?
      ''',
      [progress, DateTime.now().toIso8601String(), id],
    );
  }
}
