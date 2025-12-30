import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/habit_controller.dart';

class AddHabitDialog extends ConsumerStatefulWidget {
  const AddHabitDialog({super.key});

  @override
  ConsumerState<AddHabitDialog> createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends ConsumerState<AddHabitDialog> {
  final _titleController = TextEditingController();
  final _targetController = TextEditingController(text: '1');

  @override
  void dispose() {
    _titleController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleController.text;
    final target = int.tryParse(_targetController.text) ?? 1;

    if (title.isNotEmpty && target > 0) {
      await ref
          .read(habitControllerProvider.notifier)
          .addHabit(title: title, target: target);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Yeni Alışkanlık'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Alışkanlık Adı (örn. Kitap Oku)',
            ),
            autofocus: true,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _targetController,
            decoration: const InputDecoration(labelText: 'Günlük Hedef (kez)'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        FilledButton(onPressed: _save, child: const Text('Oluştur')),
      ],
    );
  }
}
