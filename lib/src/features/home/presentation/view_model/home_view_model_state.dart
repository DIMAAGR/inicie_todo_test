import 'package:equatable/equatable.dart';
import 'package:inicie_todo_test/src/core/failures/failures.dart';
import 'package:inicie_todo_test/src/core/state/view_model_state.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/entities/task_entity.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/strategies/task_filter.dart';

enum HomeTab { all, pending, completed }

class HomeViewModelState extends Equatable {
  final ViewModelState<Failure, void> deleteRangeState;
  final ViewModelState<Failure, void> deleteOneState;
  final ViewModelState<Failure, void> updateTaskState;

  final ViewModelState<Failure, List<TaskEntity>> tasksState;

  final List<TaskEntity> tasks;
  final HomeTab currentTab;
  final Set<String> selectedTasksIDs;
  final TaskFilterStrategy filter;
  final bool isSelectionMode;

  HomeViewModelState({
    bool? isSelectionMode,
    ViewModelState<Failure, void>? deleteRangeState,
    ViewModelState<Failure, void>? deleteOneState,
    ViewModelState<Failure, void>? updateTaskState,
    ViewModelState<Failure, List<TaskEntity>>? tasksState,
    List<TaskEntity>? tasks,
    Set<String>? selectedTasksIDs,
    TaskFilterStrategy? filter,
    this.currentTab = HomeTab.all,
  }) : filter = filter ?? AllTasksFilter(),
       deleteRangeState = deleteRangeState ?? InitialState(),
       deleteOneState = deleteOneState ?? InitialState(),
       updateTaskState = updateTaskState ?? InitialState(),
       tasksState = tasksState ?? InitialState(),
       selectedTasksIDs = selectedTasksIDs ?? {},
       isSelectionMode = isSelectionMode ?? false,
       tasks = tasks ?? [];

  HomeViewModelState copyWith({
    ViewModelState<Failure, void>? deleteRangeState,
    ViewModelState<Failure, void>? deleteOneState,
    ViewModelState<Failure, void>? updateTaskState,
    ViewModelState<Failure, List<TaskEntity>>? tasksState,
    List<TaskEntity>? tasks,
    HomeTab? currentTab,
    Set<String>? selectedTasksIDs,
    bool? isSelectionMode,
    TaskFilterStrategy? filter,
  }) {
    return HomeViewModelState(
      deleteRangeState: deleteRangeState ?? this.deleteRangeState,
      deleteOneState: deleteOneState ?? this.deleteOneState,
      updateTaskState: updateTaskState ?? this.updateTaskState,
      tasksState: tasksState ?? this.tasksState,
      tasks: tasks ?? this.tasks,
      currentTab: currentTab ?? this.currentTab,
      filter: filter ?? this.filter,
      selectedTasksIDs: selectedTasksIDs ?? this.selectedTasksIDs,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
    );
  }

  List<TaskEntity> get allTasks => tasks;
  List<TaskEntity> get pendingTasks => PendingTasksFilter().apply(tasks);
  List<TaskEntity> get completedTasks => CompletedTasksFilter().apply(tasks);

  @override
  List<Object?> get props => [
    deleteRangeState,
    deleteOneState,
    updateTaskState,
    tasksState,
    tasks,
    currentTab,
    filter.runtimeType,
    selectedTasksIDs,
    isSelectionMode,
  ];
}
