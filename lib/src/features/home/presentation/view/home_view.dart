import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inicie_todo_test/src/core/failures/failures.dart';
import 'package:inicie_todo_test/src/core/presentation/commands/pending_undo_command_controller.dart';
import 'package:inicie_todo_test/src/core/presentation/extensions/color_ext.dart';
import 'package:inicie_todo_test/src/core/presentation/widgets/fade_in.dart';
import 'package:inicie_todo_test/src/core/routes/app_routes.dart';
import 'package:inicie_todo_test/src/core/state/view_model_state.dart';
import 'package:inicie_todo_test/src/core/theme/app_text_styles.dart';
import 'package:inicie_todo_test/src/features/home/presentation/view_model/home_view_model.dart';
import 'package:inicie_todo_test/src/features/home/presentation/view_model/home_view_model_state.dart';
import 'package:inicie_todo_test/src/features/home/presentation/widgets/tab_title.dart';
import 'package:inicie_todo_test/src/features/tasks/presentation/commands/delete_commands.dart';
import 'package:inicie_todo_test/src/features/tasks/presentation/widgets/tasks_list_view.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> with SingleTickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);

    final tab = ref.read(homeViewModelProvider).currentTab;
    _controller.index = _tabToIndex(tab);

    _controller.addListener(() {
      if (_controller.indexIsChanging) return;
      ref.read(homeViewModelProvider.notifier).setTab(_indexToTab(_controller.index));
    });

    ref.read(homeViewModelProvider.notifier).loadAllData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _tabToIndex(HomeTab tab) => switch (tab) {
    HomeTab.all => 0,
    HomeTab.pending => 1,
    HomeTab.completed => 2,
  };

  HomeTab _indexToTab(int index) => switch (index) {
    0 => HomeTab.all,
    1 => HomeTab.pending,
    _ => HomeTab.completed,
  };

  Future<void> onDelete(HomeViewModel vm, String id) async {
    final pendingController = PendingCommandController();
    final cmd = DeleteOneCommand(
      removeByIdOptimistic: vm.removeByIdOptimistic,
      restoreTasks: vm.restoreTasks,
      commitDeleteOne: vm.commitDeleteOne,
      id: id,
    );

    await pendingController.start(context: context, command: cmd, message: 'success_delete_task');
  }

  void onEdit(String id) {
    context.goNamed(AppRoutes.editTask, pathParameters: {'id': id});
  }

  final homeErrorProvider = Provider<Failure?>((ref) {
    final s = ref.watch(homeViewModelProvider);
    Failure? pickError(ViewModelState<Failure, dynamic> st) =>
        st is ErrorState<Failure, dynamic> ? st.error : null;

    return pickError(s.tasksState) ??
        pickError(s.updateTaskState) ??
        pickError(s.deleteOneState) ??
        pickError(s.deleteRangeState);
  });

  Widget _buildList(Key key, HomeViewModel notifier, HomeViewModelState vm) {
    return TasksListView(
      key: key,
      tasks: vm.visibleTasks,
      selectedTasksIDs: vm.selectedTasksIDs.toList(),
      isSelectionMode: vm.isSelectionMode,
      toggleSelection: notifier.toggleSelection,
      startSelection: notifier.startSelection,
      setDone: notifier.setDone,
      onEdit: (task) => onEdit(task.id),
      onDelete: (id) async => await onDelete(notifier, id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(homeViewModelProvider);
    final notifier = ref.read(homeViewModelProvider.notifier);

    ref.listen<Failure?>(homeErrorProvider, (prev, next) {
      if (next != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error, color: Theme.of(context).colors.textLight),
                  SizedBox(width: 8),
                  Text(
                    next.message,
                    style: AppTextStyles.body1Regular.copyWith(
                      color: Theme.of(context).colors.textLight,
                    ),
                  ),
                ],
              ),
              backgroundColor: Theme.of(context).colors.error,
            ),
          );
          final n = ref.read(homeViewModelProvider.notifier);
          n.clearErrors();
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        key: const ValueKey('selection-appbar'),
        leading: vm.isSelectionMode
            ? IconButton(
                icon: Icon(Icons.close, color: Theme.of(context).colors.textPrimary),
                onPressed: notifier.clearSelection,
                tooltip: 'cancel_selection',
              )
            : null,
        title: vm.isSelectionMode
            ? Text(
                '${vm.selectedTasksIDs.length} selecteds',
                style: AppTextStyles.body1Regular.copyWith(
                  color: Theme.of(context).colors.textPrimary,
                ),
              )
            : null,
        actions: vm.isSelectionMode
            ? [
                IconButton(
                  tooltip: 'delete_selecteds',
                  icon: Icon(Icons.delete, color: Theme.of(context).colors.error),
                  onPressed: vm.selectedTasksIDs.isEmpty
                      ? null
                      : () async {
                          final pendingController = PendingCommandController();
                          final ids = vm.selectedTasksIDs.toList();
                          final cmd = DeleteRangeCommand(
                            ids: ids,
                            removeByIdsOptimistic: notifier.removeByIdsOptimistic,
                            restoreTasks: notifier.restoreTasks,
                            commitDeleteRange: notifier.commitDeleteRange,
                          );

                          await pendingController.start(
                            context: context,
                            command: cmd,
                            message: '${ids.length} tasks_deleted',
                          );
                        },
                ),
              ]
            : [],
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24),
            FadeIn(
              delay: Duration(milliseconds: 300),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  'Bem Vindo ao\nInicie To-do!',
                  style: AppTextStyles.h5.copyWith(color: Theme.of(context).colors.textPrimary),
                ),
              ),
            ),

            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: TabBar(
                controller: _controller,
                isScrollable: true,
                padding: EdgeInsets.zero,
                overlayColor: WidgetStatePropertyAll(Colors.transparent),
                labelPadding: const EdgeInsets.only(right: 32),
                tabAlignment: TabAlignment.start,
                dividerColor: Colors.transparent,
                indicatorColor: Colors.transparent,
                tabs: [
                  Tab(
                    child: FadeIn(
                      delay: Duration(milliseconds: 400),
                      child: AnimatedTabLabel(
                        controller: _controller,
                        index: 0,
                        title: 'all_tasks',
                      ),
                    ),
                  ),
                  Tab(
                    child: FadeIn(
                      delay: Duration(milliseconds: 600),
                      child: AnimatedTabLabel(controller: _controller, index: 1, title: 'pending'),
                    ),
                  ),
                  Tab(
                    child: FadeIn(
                      delay: Duration(milliseconds: 800),
                      child: AnimatedTabLabel(
                        controller: _controller,
                        index: 2,
                        title: 'completed',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: (MediaQuery.of(context).size.height / 2),
              child: TabBarView(
                controller: _controller,
                children: [
                  _buildList(const PageStorageKey('tab_all'), notifier, vm),
                  _buildList(const PageStorageKey('tab_completed'), notifier, vm),
                  _buildList(const PageStorageKey('tab_pending'), notifier, vm),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        elevation: 0,
        backgroundColor: Theme.of(context).colors.primary,
        shape: CircleBorder(),
        child: Icon(Icons.add, size: 32, color: Theme.of(context).colors.textLight),
      ),
    );
  }
}
