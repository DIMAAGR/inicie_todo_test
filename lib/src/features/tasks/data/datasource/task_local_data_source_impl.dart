import 'dart:convert';

import 'package:inicie_todo_test/src/core/storage/schema/storage_schema.dart';
import 'package:inicie_todo_test/src/core/storage/wrapper/shared_preferences_wrapper.dart';
import 'package:inicie_todo_test/src/features/tasks/data/models/task_model.dart';

import 'task_local_data_source.dart';

class TasksLocalDataSourceImpl implements TasksLocalDataSource {
  final KeyValueWrapper store;
  TasksLocalDataSourceImpl(this.store);

  @override
  Future<List<TaskModel>> getAllTasks() async {
    final raw = store.getString(StorageSchema.tasksKey);
    if (raw == null) return [];
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    return list.map(TaskModel.fromJson).toList();
  }

  @override
  Future<void> saveAllTasks(List<TaskModel> tasks) async {
    final encoded = jsonEncode(tasks.map((e) => e.toJson()).toList());
    await store.setString(StorageSchema.tasksKey, encoded);
  }

  @override
  Future<TaskModel?> getTaskById(String id) async {
    final tasks = store.getString(StorageSchema.tasksKey);
    if (tasks == null) return null;
    final list = (jsonDecode(tasks) as List).cast<Map<String, dynamic>>();
    final task = list
        .map(TaskModel.fromJson)
        .firstWhere((task) => task.id == id);
    return task;
  }
}
