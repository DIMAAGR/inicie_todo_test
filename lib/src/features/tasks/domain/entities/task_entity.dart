import 'package:inicie_todo_test/src/features/tasks/domain/value_objects/due_date.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/value_objects/task_title.dart';

class TaskEntity {
  final String id;
  final TaskTitle title;
  final bool done;
  final DateTime createdAt;
  final DueDate? dueDate;

  const TaskEntity({
    required this.id,
    required this.title,
    this.done = false,
    required this.createdAt,
    this.dueDate,
  });

  TaskEntity copyWith({TaskTitle? title, bool? done, DueDate? dueDate}) {
    return TaskEntity(
      id: id,
      title: title ?? this.title,
      done: done ?? this.done,
      createdAt: createdAt,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}