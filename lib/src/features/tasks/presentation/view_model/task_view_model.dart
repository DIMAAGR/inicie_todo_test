import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inicie_todo_test/src/core/di/use_cases_injection.dart';
import 'package:inicie_todo_test/src/core/failures/failures.dart';
import 'package:inicie_todo_test/src/core/presentation/extensions/date_ext.dart';
import 'package:inicie_todo_test/src/core/state/view_model_state.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/entities/task_entity.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/use_cases/create_task_use_case.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/use_cases/get_task_by_id_use_case.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/use_cases/update_task_from_id_use_case.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/value_objects/due_date.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/value_objects/task_title.dart';
import 'package:inicie_todo_test/src/features/tasks/presentation/view_model/task_view_model_state.dart';
import 'package:uuid/uuid.dart';

final taskViewModelProvider = NotifierProvider<TaskViewModel, TaskViewModelState>(
  () => TaskViewModel(),
);

class TaskViewModel extends Notifier<TaskViewModelState> {
  late final CreateTaskUseCase _createTaskUseCase;
  late final UpdateTaskFromIdUseCase _updateTaskUseCase;
  late final GetTaskByIdUseCase _getTaskByIdUseCase;
  @override
  TaskViewModelState build() {
    _createTaskUseCase = ref.read(createTaskUseCaseProvider);
    _updateTaskUseCase = ref.read(updateTaskFromIdUseCaseProvider);
    _getTaskByIdUseCase = ref.read(getTaskByIdUseCaseProvider);
    return TaskViewModelState();
  }

  void setTitle(String v) => state = state.copyWith(titleRaw: v);
  void setDate(String v) => state = state.copyWith(dateRaw: v);
  void setTime(String v) => state = state.copyWith(timeRaw: v);

  Future<void> createTask() async {
    state = state.copyWith(createTaskState: LoadingState());

    final titleResult = TaskTitle.create(state.titleRaw);
    final dueResult = DueDate.fromUser(date: state.dateRaw, time: state.timeRaw);

    if (titleResult.isLeft()) {
      state = state.copyWith(createTaskState: ErrorState(ValidationFailure('Título inválido')));
      return;
    }

    final entity = TaskEntity(
      id: Uuid().v4(),
      title: titleResult.getOrElse(() => throw Exception()),
      createdAt: DateTime.now(),
      dueDate: dueResult.fold((_) => null, (v) => v),
    );

    final result = await _createTaskUseCase(entity);

    state = result.fold(
      (l) => state.copyWith(createTaskState: ErrorState(l)),
      (r) => state.copyWith(createTaskState: SuccessState(null)),
    );
  }

  Future<void> editTask() async {
    state = state.copyWith(updateTaskState: LoadingState());

    final titleResult = TaskTitle.create(state.titleRaw);
    final dueResult = DueDate.fromUser(date: state.dateRaw, time: state.timeRaw);

    final entity = TaskEntity(
      id: state.originalTask!.id,
      title: titleResult.getOrElse(() => throw Exception()),
      createdAt: state.originalTask!.createdAt,
      done: state.originalTask!.done,
      dueDate: dueResult.fold((_) => null, (v) => v),
    );
    final result = await _updateTaskUseCase(state.originalTask!.id, entity);
    state = result.fold(
      (l) => state.copyWith(updateTaskState: ErrorState(l)),
      (r) => state.copyWith(updateTaskState: SuccessState(null)),
    );
  }

  Future<void> getTask(String id) async {
    state = state.copyWith(getTaskState: LoadingState());

    final result = await _getTaskByIdUseCase(id);

    state = result.fold((l) => state.copyWith(getTaskState: ErrorState(l)), (r) {
      return state.copyWith(
        getTaskState: SuccessState(null),
        originalTask: r,
        titleRaw: r.title.value,
        dateRaw: r.dueDate?.value?.toDDMMYYYY(),
        timeRaw: r.dueDate?.value?.toHHMM(),
      );
    });
  }

  void clearErrors() {
    state = state.copyWith(
      createTaskState: InitialState(),
      updateTaskState: InitialState(),
      getTaskState: InitialState(),
    );
  }
}
