import '../../domain/entities/task.dart';

class TaskModel extends AppTask {
  const TaskModel({
    required super.id,
    required super.title,
    super.dueDate,
    super.isCompleted,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as String,
      title: map['title'] as String,
      dueDate: map['due_date'] != null
          ? DateTime.parse(map['due_date'] as String)
          : null,
      isCompleted: (map['is_completed'] as int) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'due_date': dueDate?.toIso8601String(),
      'is_completed': isCompleted ? 1 : 0,
    };
  }

  factory TaskModel.fromEntity(AppTask task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      dueDate: task.dueDate,
      isCompleted: task.isCompleted,
    );
  }
}
