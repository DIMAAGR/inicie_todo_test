import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:inicie_todo_test/src/core/storage/schema/storage_schema.dart';
import 'package:inicie_todo_test/src/core/storage/wrapper/shared_preferences_wrapper.dart';
import 'package:inicie_todo_test/src/features/tasks/data/models/task_model.dart';

import 'task_local_data_source.dart';

List<Map<String, dynamic>> _decodeTasksJson(String raw) {
  final list = jsonDecode(raw) as List<dynamic>;
  return list.cast<Map<String, dynamic>>();
}

String _encodeTasksJson(List<TaskModel> tasks) {
  return jsonEncode(tasks.map((t) => t.toJson()).toList());
}

class TasksLocalDataSourceImpl implements TasksLocalDataSource {
  final KeyValueWrapper store;
  TasksLocalDataSourceImpl(this.store);

  @override
  Future<List<TaskModel>> getAllTasks() async {
    final raw = store.getString(StorageSchema.tasksKey);
    if (raw == null) return [];
    final list = await compute(_decodeTasksJson, raw);
    return list.map(TaskModel.fromJson).toList(growable: false);
  }

  @override
  Future<void> saveAllTasks(List<TaskModel> tasks) async {
    final encoded = await compute(_encodeTasksJson, tasks);
    await store.setString(StorageSchema.tasksKey, encoded);
  }

  @override
  Future<TaskModel?> getTaskById(String id) async {
    final raw = store.getString(StorageSchema.tasksKey);
    if (raw == null) return null;

    final list = await compute(_decodeTasksJson, raw);
    final model = list.map(TaskModel.fromJson).where((m) => m.id == id).toList();
    return model.isNotEmpty ? model.first : null;
  }
}
