import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inicie_todo_test/src/core/app/main_app.dart';
import 'package:inicie_todo_test/src/core/di/infra_injection.dart';
import 'package:inicie_todo_test/src/features/tasks/data/datasource/task_local_data_source_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
        tasksLocalDataSourceProvider.overrideWith((ref) {
          final kv = ref.read(keyValueWrapperProvider);
          return TasksLocalDataSourceImpl(kv);
        }),
      ],
      child: MainApp(),
    ),
  );
}
