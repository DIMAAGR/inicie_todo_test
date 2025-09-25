import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inicie_todo_test/src/core/failures/failures.dart';
import 'package:inicie_todo_test/src/core/storage/wrapper/shared_preferences_wrapper.dart';
import 'package:inicie_todo_test/src/features/tasks/data/datasource/task_local_data_source.dart';
import 'package:inicie_todo_test/src/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/repositories/task_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw StorageFailure('SharedPreferences not initialized');
});

final keyValueWrapperProvider = Provider<KeyValueWrapper>((ref) {
  return SharedPreferencesWrapper(ref.read(sharedPrefsProvider));
});

final tasksLocalDataSourceProvider = Provider<TasksLocalDataSource>((ref) {
  throw NotFoundFailure('TasksLocalDataSource not found');
});

final tasksRepositoryProvider = Provider<TaskRepository>((ref) {
  final ds = ref.watch(tasksLocalDataSourceProvider);
  return TaskRepositoryImpl(ds);
});
