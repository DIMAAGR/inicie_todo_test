import 'package:inicie_todo_test/src/features/tasks/data/models/task_model.dart';

abstract class TasksLocalDataSource {
  Future<List<TaskModel>> getAllTasks();
  Future<void> saveAllTasks(List<TaskModel> tasks);
  Future<TaskModel?> getTaskById(String id);
}
