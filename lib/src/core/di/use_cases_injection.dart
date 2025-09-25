import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inicie_todo_test/src/core/di/infra_injection.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/use_cases/create_task_use_case.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/use_cases/delete_from_id_range_use_case.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/use_cases/delete_from_id_use_case.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/use_cases/get_all_tasks_use_case.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/use_cases/get_task_by_id_use_case.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/use_cases/update_task_from_id_use_case.dart';

final getAllTasksUseCaseProvider = Provider<GetAllTasksUseCase>((ref) {
  final repo = ref.watch(tasksRepositoryProvider);
  return GetAllTasksUseCaseImpl(repo);
});
final deleteOneTaskUseCaseProvider = Provider<DeleteFromIdUseCase>((ref) {
  final repo = ref.watch(tasksRepositoryProvider);
  return DeleteFromIdUseCaseImpl(repo);
});
final deleteRangeTasksUseCaseProvider = Provider<DeleteFromIdRangeUseCase>((
  ref,
) {
  final repo = ref.watch(tasksRepositoryProvider);
  return DeleteFromIdRangeUseCaseImpl(repo);
});
final createTaskUseCaseProvider = Provider<CreateTaskUseCase>((ref) {
  final repo = ref.watch(tasksRepositoryProvider);
  return CreateTaskUseCaseImpl(repo);
});

final updateTaskFromIdUseCaseProvider = Provider<UpdateTaskFromIdUseCase>((
  ref,
) {
  final repo = ref.watch(tasksRepositoryProvider);
  return UpdateTaskFromIdUseCaseImpl(repo);
});

final getTaskByIdUseCaseProvider = Provider<GetTaskByIdUseCase>((ref) {
  final repo = ref.watch(tasksRepositoryProvider);
  return GetTaskByIdUseCaseImpl(repo);
});
