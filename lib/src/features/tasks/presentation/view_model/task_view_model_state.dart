import 'package:equatable/equatable.dart';
import 'package:inicie_todo_test/src/core/failures/failures.dart';
import 'package:inicie_todo_test/src/core/state/view_model_state.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/entities/task_entity.dart';

class TaskViewModelState extends Equatable {
  final ViewModelState<Failure, void> createTaskState;
  final ViewModelState<Failure, void> updateTaskState;
  final ViewModelState<Failure, void> getTaskState;

  final String titleRaw;
  final String dateRaw;
  final String timeRaw;

  final TaskEntity? originalTask;

  TaskViewModelState({
    ViewModelState<Failure, void>? createTaskState,
    ViewModelState<Failure, void>? updateTaskState,
    ViewModelState<Failure, void>? getTaskState,
    this.originalTask,
    this.titleRaw = '',
    this.dateRaw = '',
    this.timeRaw = '',
  }) : createTaskState = createTaskState ?? InitialState(),
       updateTaskState = updateTaskState ?? InitialState(),
       getTaskState = getTaskState ?? InitialState();

  TaskViewModelState copyWith({
    ViewModelState<Failure, void>? createTaskState,
    ViewModelState<Failure, void>? updateTaskState,
    ViewModelState<Failure, void>? getTaskState,
    TaskEntity? originalTask,
    String? titleRaw,
    String? dateRaw,
    String? timeRaw,
  }) {
    return TaskViewModelState(
      createTaskState: createTaskState ?? this.createTaskState,
      updateTaskState: updateTaskState ?? this.updateTaskState,
      originalTask: originalTask ?? this.originalTask,
      getTaskState: getTaskState ?? this.getTaskState,
      titleRaw: titleRaw ?? this.titleRaw,
      dateRaw: dateRaw ?? this.dateRaw,
      timeRaw: timeRaw ?? this.timeRaw,
    );
  }

  @override
  List<Object?> get props => [
    createTaskState,
    updateTaskState,
    titleRaw,
    dateRaw,
    timeRaw,
    originalTask,
    getTaskState,
  ];
}
