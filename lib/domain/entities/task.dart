class AppTask {
  // Renamed to AppTask to avoid conflict with dart:async Task or similar generic names if needed,
  // though 'Task' is usually safe in domain. Using Task for simplicity unless conflicts arise.
  // Actually, let's stick to Task but be mindful of imports.
  // If user prefers Task, I will use Task.
  final String id;
  final String title;
  final DateTime? dueDate;
  final bool isCompleted;

  const AppTask({
    required this.id,
    required this.title,
    this.dueDate,
    this.isCompleted = false,
  });
}
