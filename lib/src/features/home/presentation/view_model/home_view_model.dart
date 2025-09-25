import 'package:inicie_todo_test/src/core/di/use_cases_injection.dart';
import 'package:inicie_todo_test/src/core/state/view_model_state.dart';
import 'package:inicie_todo_test/src/features/home/presentation/view_model/home_view_model_state.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/entities/task_entity.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/strategies/task_filter.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/use_cases/delete_from_id_range_use_case.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/use_cases/delete_from_id_use_case.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/use_cases/get_all_tasks_use_case.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/use_cases/update_task_from_id_use_case.dart';
import 'package:riverpod/riverpod.dart';

final homeViewModelProvider = NotifierProvider<HomeViewModel, HomeViewModelState>(
  () => HomeViewModel(),
);

class HomeViewModel extends Notifier<HomeViewModelState> {
  late final DeleteFromIdRangeUseCase _deleteFromIdRangeUseCase;
  late final DeleteFromIdUseCase _deleteFromIdUseCase;
  late final UpdateTaskFromIdUseCase _updateTaskFromIdUseCase;
  late final GetAllTasksUseCase _allTasksUseCase;

  @override
  HomeViewModelState build() {
    _deleteFromIdRangeUseCase = ref.read(deleteRangeTasksUseCaseProvider);
    _deleteFromIdUseCase = ref.read(deleteOneTaskUseCaseProvider);
    _updateTaskFromIdUseCase = ref.read(updateTaskFromIdUseCaseProvider);
    _allTasksUseCase = ref.read(getAllTasksUseCaseProvider);

    return HomeViewModelState();
  }

  // --------------------------------------------------
  // TABS
  // --------------------------------------------------

  void setTab(HomeTab tab) {
    final strategy = switch (tab) {
      HomeTab.all => AllTasksFilter(),
      HomeTab.pending => PendingTasksFilter(),
      HomeTab.completed => CompletedTasksFilter(),
    };
    state = state.copyWith(currentTab: tab, filter: strategy);
  }

  void setFilter(TaskFilterStrategy filter) {
    state = state.copyWith(filter: filter);
  }

  void setTasks(List<TaskEntity> all) {
    state = state.copyWith(tasks: all);
  }

  // --------------------------------------------------
  // MULTI SELECTION
  // --------------------------------------------------

  bool isSelected(String id) => state.selectedTasksIDs.contains(id);

  void startSelection(String id) {
    if (!state.isSelectionMode) {
      state = state.copyWith(isSelectionMode: true);
    }
    final next = {...state.selectedTasksIDs, id};
    state = state.copyWith(selectedTasksIDs: next);
  }

  void toggleSelection(String id) {
    if (!state.isSelectionMode) return;
    final next = {...state.selectedTasksIDs};
    if (!next.remove(id)) next.add(id);
    state = state.copyWith(selectedTasksIDs: next, isSelectionMode: next.isNotEmpty);
  }

  void clearSelection() {
    state = state.copyWith(selectedTasksIDs: <String>{}, isSelectionMode: false);
  }

  // --------------------------------------------------
  // DELETE
  // --------------------------------------------------

  List<TaskEntity> removeByIdsOptimistic(Iterable<String> ids) {
    final idSet = ids.toSet();
    final removed = state.tasks.where((t) => idSet.contains(t.id)).toList(growable: false);
    final nextTasks = state.tasks.where((t) => !idSet.contains(t.id)).toList(growable: false);

    state = state.copyWith(tasks: nextTasks, selectedTasksIDs: <String>{}, isSelectionMode: false);
    return removed;
  }

  TaskEntity? removeByIdOptimistic(String id) {
    final idx = state.tasks.indexWhere((t) => t.id == id);
    if (idx == -1) return null;

    final removed = state.tasks[idx];
    final nextTasks = [...state.tasks]..removeAt(idx);
    final nextSel = {...state.selectedTasksIDs}..remove(id);

    state = state.copyWith(
      tasks: nextTasks,
      selectedTasksIDs: nextSel,
      isSelectionMode: nextSel.isNotEmpty,
    );
    return removed;
  }

  void restoreTasks(List<TaskEntity> items) {
    final next = [...state.tasks, ...items]..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    state = state.copyWith(tasks: next);
  }

  Future<void> commitDeleteRange(Iterable<String> ids) async {
    state = state.copyWith(deleteRangeState: LoadingState());
    final res = await _deleteFromIdRangeUseCase(ids);
    state = state.copyWith(
      deleteRangeState: res.fold((f) => ErrorState(f), (_) => SuccessState(null)),
    );
  }

  Future<void> commitDeleteOne(String id) async {
    state = state.copyWith(deleteOneState: LoadingState());
    final res = await _deleteFromIdUseCase(id);
    state = state.copyWith(
      deleteOneState: res.fold((f) => ErrorState(f), (_) => SuccessState(null)),
    );
  }

  // --------------------------------------------------
  // TOOGLE DONE
  // --------------------------------------------------
  Future<void> setDone(String id, bool done) async {
    state = state.copyWith(updateTaskState: LoadingState());
    final idx = state.tasks.indexWhere((t) => t.id == id);
    if (idx == -1) return;
    state.tasks[idx] = state.tasks[idx].copyWith(done: done);
    final result = await _updateTaskFromIdUseCase(id, state.tasks[idx]);

    state = state.copyWith(
      updateTaskState: result.fold((l) => ErrorState(l), (r) => SuccessState(null)),
    );
  }

  // --------------------------------------------------
  // LOAD ALL DATA
  // --------------------------------------------------

  Future<void> loadAllData() async {
    state.copyWith(tasksState: LoadingState());

    final result = await _allTasksUseCase();

    result.fold((l) => state = state.copyWith(tasksState: ErrorState(l)), (r) {
      state = state.copyWith(
        tasks: r..sort((a, b) => a.createdAt.compareTo(b.createdAt)),
        tasksState: SuccessState(r),
      );
    });
  }

  // --------------------------------------------------
  // ERRORS
  // --------------------------------------------------

  void clearErrors() {
    state = state.copyWith(
      tasksState: InitialState(),
      updateTaskState: InitialState(),
      deleteOneState: InitialState(),
      deleteRangeState: InitialState(),
    );
  }
}
