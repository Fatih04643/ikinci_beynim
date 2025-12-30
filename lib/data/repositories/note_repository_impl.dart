import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';
import '../datasources/database_helper.dart';
import '../models/note_model.dart';

class NoteRepositoryImpl implements NoteRepository {
  final DatabaseHelper _databaseHelper;

  NoteRepositoryImpl(this._databaseHelper);

  @override
  Future<List<Note>> getNotes() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      orderBy: 'created_at DESC',
    );
    return List.generate(maps.length, (i) {
      return NoteModel.fromMap(maps[i]);
    });
  }

  @override
  Future<Note?> getNoteById(String id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return NoteModel.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<void> addNote(Note note) async {
    final db = await _databaseHelper.database;
    await db.insert('notes', NoteModel.fromEntity(note).toMap());
  }

  @override
  Future<void> updateNote(Note note) async {
    final db = await _databaseHelper.database;
    await db.update(
      'notes',
      NoteModel.fromEntity(note).toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  @override
  Future<void> deleteNote(String id) async {
    final db = await _databaseHelper.database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
