import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/note.dart';
import '../providers/note_controller.dart';

class AddEditNoteScreen extends ConsumerStatefulWidget {
  final Note? note;
  const AddEditNoteScreen({super.key, this.note});

  @override
  ConsumerState<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends ConsumerState<AddEditNoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late int _selectedColorValue;

  final List<Color> _colors = [
    Colors.deepPurple,
    Colors.redAccent,
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.orangeAccent,
    Colors.tealAccent,
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(
      text: widget.note?.content ?? '',
    );
    _selectedColorValue = widget.note?.colorValue ?? _colors.first.toARGB32();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (_titleController.text.isEmpty) return;

    if (widget.note == null) {
      await ref
          .read(noteControllerProvider.notifier)
          .addNote(
            title: _titleController.text,
            content: _contentController.text,
            colorValue: _selectedColorValue,
          );
    } else {
      await ref
          .read(noteControllerProvider.notifier)
          .updateNote(
            id: widget.note!.id,
            title: _titleController.text,
            content: _contentController.text,
            colorValue: _selectedColorValue,
            createdAt: widget.note!.createdAt,
          );
    }

    if (mounted) Navigator.pop(context);
  }

  Future<void> _deleteNote() async {
    if (widget.note != null) {
      await ref
          .read(noteControllerProvider.notifier)
          .deleteNote(widget.note!.id);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Yeni Not' : 'Notu Düzenle'),
        actions: [
          if (widget.note != null)
            IconButton(icon: const Icon(Icons.delete), onPressed: _deleteNote),
          IconButton(icon: const Icon(Icons.check), onPressed: _saveNote),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _colors.length,
                itemBuilder: (context, index) {
                  final color = _colors[index];
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedColorValue = color.toARGB32()),
                    child: Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: _selectedColorValue == color.toARGB32()
                            ? Border.all(
                                color: Theme.of(context).colorScheme.onSurface,
                                width: 2,
                              )
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _titleController,
              style: Theme.of(context).textTheme.headlineSmall,
              decoration: const InputDecoration(
                hintText: 'Başlık',
                border: InputBorder.none,
                filled: false,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              maxLines: null,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: const InputDecoration(
                hintText: 'Yazmaya başlayın...',
                border: InputBorder.none,
                filled: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
