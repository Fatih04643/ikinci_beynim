import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/habit.dart';
import 'providers.dart';

class HabitController extends AsyncNotifier<List<Habit>> {
  @override
  Future<List<Habit>> build() async {
    final repository = ref.watch(habitRepositoryProvider);
    return await repository.getHabits();
  }

  Future<void> addHabit({required String title, required int target}) async {
    state = const AsyncValue.loading();
    final repository = ref.read(habitRepositoryProvider);
    final newHabit = Habit(
      id: const Uuid().v4(),
      title: title,
      target: target,
      current: 0,
      lastUpdated: DateTime.now(),
    );
    state = await AsyncValue.guard(() async {
      await repository.addHabit(newHabit);
      return await repository.getHabits();
    });
  }

  Future<void> incrementHabit(String id, int current, int target) async {
    if (current >= target) return;

    // Optimistic update could be done here, but simple reload is safer for now
    final repository = ref.read(habitRepositoryProvider);
    await repository.logHabitProgress(id, current + 1);

    // Refresh list
    state = await AsyncValue.guard(() async {
      return await repository.getHabits();
    });
  }

  Future<void> deleteHabit(String id) async {
    state = const AsyncValue.loading();
    final repository = ref.read(habitRepositoryProvider);
    state = await AsyncValue.guard(() async {
      await repository.deleteHabit(id);
      return await repository.getHabits();
    });
  }
}

final habitControllerProvider =
    AsyncNotifierProvider<HabitController, List<Habit>>(() {
      return HabitController();
    });
