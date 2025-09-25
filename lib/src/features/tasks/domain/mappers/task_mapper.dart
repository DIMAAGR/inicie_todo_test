import 'package:inicie_todo_test/src/features/tasks/data/models/task_model.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/entities/task_entity.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/value_objects/due_date.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/value_objects/task_title.dart';

class TaskMapper {
  static TaskEntity toEntity(TaskModel model) => TaskEntity(
    id: model.id,
    title: TaskTitle.create(model.title).getOrElse(() => throw Exception()),
    createdAt: DateTime.fromMillisecondsSinceEpoch(model.createdAt),
    dueDate: model.dueDate != null ? DueDate.fromEpochMs(model.dueDate) : null,
    done: model.done,
  );

  static TaskModel toModel(TaskEntity entity) => TaskModel(
    id: entity.id,
    title: entity.title.value,
    createdAt: entity.createdAt.millisecondsSinceEpoch,
    dueDate: entity.dueDate?.value?.millisecondsSinceEpoch,
    done: entity.done,
  );
}
