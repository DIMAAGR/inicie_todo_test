import 'package:inicie_todo_test/src/features/tasks/domain/entities/task_entity.dart';

abstract class TaskFilterStrategy {
  List<TaskEntity> apply(List<TaskEntity> all);
}

class AllTasksFilter implements TaskFilterStrategy {
  @override
  List<TaskEntity> apply(List<TaskEntity> all) => all;
}

class PendingTasksFilter implements TaskFilterStrategy {
  @override
  List<TaskEntity> apply(List<TaskEntity> all) =>
      all.where((t) => !t.done).toList();
}

class CompletedTasksFilter implements TaskFilterStrategy {
  @override
  List<TaskEntity> apply(List<TaskEntity> all) =>
      all.where((t) => t.done).toList();
}
