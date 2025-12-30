import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/note.dart';
import 'providers.dart';

class NoteController extends AsyncNotifier<List<Note>> {
  @override
  Future<List<Note>> build() async {
    final repository = ref.watch(noteRepositoryProvider);
    return await repository.getNotes();
  }

  Future<void> addNote({
    required String title,
    required String content,
    required int colorValue,
  }) async {
    state = const AsyncValue.loading();
    final repository = ref.read(noteRepositoryProvider);
    final newNote = Note(
      id: const Uuid().v4(),
      title: title,
      content: content,
      colorValue: colorValue,
      createdAt: DateTime.now(),
    );
    state = await AsyncValue.guard(() async {
      await repository.addNote(newNote);
      return await repository.getNotes();
    });
  }

  Future<void> updateNote({
    required String id,
    required String title,
    required String content,
    required int colorValue,
    required DateTime createdAt,
  }) async {
    state = const AsyncValue.loading();
    final repository = ref.read(noteRepositoryProvider);
    final updatedNote = Note(
      id: id,
      title: title,
      content: content,
      colorValue: colorValue,
      createdAt: createdAt,
    );
    state = await AsyncValue.guard(() async {
      await repository.updateNote(updatedNote);
      return await repository.getNotes();
    });
  }

  Future<void> deleteNote(String id) async {
    state = const AsyncValue.loading();
    final repository = ref.read(noteRepositoryProvider);
    state = await AsyncValue.guard(() async {
      await repository.deleteNote(id);
      return await repository.getNotes();
    });
  }
}

final noteControllerProvider =
    AsyncNotifierProvider<NoteController, List<Note>>(() {
      return NoteController();
    });
