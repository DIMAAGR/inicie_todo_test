import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inicie_todo_test/src/core/failures/failures.dart';
import 'package:inicie_todo_test/src/core/presentation/extensions/color_ext.dart';
import 'package:inicie_todo_test/src/core/presentation/widgets/fade_in.dart';
import 'package:inicie_todo_test/src/core/routes/app_routes.dart';
import 'package:inicie_todo_test/src/core/state/view_model_state.dart';
import 'package:inicie_todo_test/src/core/theme/app_text_styles.dart';
import 'package:inicie_todo_test/src/features/home/presentation/view_model/home_view_model.dart';
import 'package:inicie_todo_test/src/features/home/presentation/view_model/home_view_model_state.dart';
import 'package:inicie_todo_test/src/features/home/presentation/widgets/home_app_bar.dart';
import 'package:inicie_todo_test/src/features/home/presentation/widgets/tab_title.dart';
import 'package:inicie_todo_test/src/features/home/presentation/widgets/tasks_list_tab.dart';
import 'package:inicie_todo_test/src/features/tasks/presentation/widgets/custom_snackbars.dart';

final homeErrorProvider = Provider<Failure?>((ref) {
  final s = ref.watch(homeViewModelProvider);
  Failure? pick(ViewModelState<Failure, dynamic> st) =>
      st is ErrorState<Failure, dynamic> ? st.error : null;

  return pick(s.tasksState) ??
      pick(s.updateTaskState) ??
      pick(s.deleteOneState) ??
      pick(s.deleteRangeState);
});

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
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeViewModelProvider.notifier).loadAllData();
    });
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

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(homeViewModelProvider);
    final notifier = ref.read(homeViewModelProvider.notifier);

    ref.listen<Failure?>(homeErrorProvider, (prev, next) {
      if (next != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(CustomSnackbars.error(context, next.message));
          final n = ref.read(homeViewModelProvider.notifier);
          n.clearErrors();
        });
      }
    });

    return Scaffold(
      appBar: HomeAppBar(viewModel: vm, notifier: notifier),
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
                  'wellcome_to_task_to_do',
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
                  TasksListTab(
                    notifier: notifier,
                    vm: vm,
                    list: vm.allTasks,
                    title: 'all_tasks',
                    key: const PageStorageKey('tab_all'),
                  ),
                  TasksListTab(
                    notifier: notifier,
                    vm: vm,
                    list: vm.pendingTasks,
                    title: 'pending',
                    key: const PageStorageKey('tab_pending'),
                  ),
                  TasksListTab(
                    notifier: notifier,
                    vm: vm,
                    list: vm.completedTasks,
                    title: 'completed',
                    key: const PageStorageKey('tab_completed'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final changed = await context.pushNamed<bool>(AppRoutes.newTask);
          if (changed == true) {
            ref.read(homeViewModelProvider.notifier).loadAllData();
          }
        },
        elevation: 0,
        backgroundColor: Theme.of(context).colors.primary,
        shape: CircleBorder(),
        child: Icon(Icons.add, size: 32, color: Theme.of(context).colors.textLight),
      ),
    );
  }
}
