class Habit {
  final String id;
  final String title;
  final int target;
  final int current;
  final DateTime? lastUpdated;

  const Habit({
    required this.id,
    required this.title,
    required this.target,
    this.current = 0,
    this.lastUpdated,
  });

  bool get isCompleted => current >= target;

  double get progress => target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;
}
