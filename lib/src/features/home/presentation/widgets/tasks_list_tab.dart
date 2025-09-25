import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inicie_todo_test/src/core/presentation/commands/pending_undo_command_controller.dart';
import 'package:inicie_todo_test/src/core/presentation/extensions/color_ext.dart';
import 'package:inicie_todo_test/src/core/presentation/extensions/l10n_ext.dart';
import 'package:inicie_todo_test/src/core/routes/app_routes.dart';
import 'package:inicie_todo_test/src/core/state/view_model_state.dart';
import 'package:inicie_todo_test/src/features/home/presentation/view_model/home_view_model.dart';
import 'package:inicie_todo_test/src/features/home/presentation/view_model/home_view_model_state.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/entities/task_entity.dart';
import 'package:inicie_todo_test/src/features/tasks/presentation/commands/delete_commands.dart';
import 'package:inicie_todo_test/src/features/tasks/presentation/widgets/tasks_list_view.dart';

class TasksListTab extends ConsumerStatefulWidget {
  final HomeViewModel notifier;
  final List<TaskEntity> list;
  final HomeViewModelState vm;
  final String title;

  const TasksListTab({
    super.key,
    required this.notifier,
    required this.vm,
    required this.title,
    required this.list,
  });

  @override
  ConsumerState<TasksListTab> createState() => _TasksListTabState();
}

class _TasksListTabState extends ConsumerState<TasksListTab> {
  @override
  Widget build(BuildContext context) {
    if (widget.vm.tasksState is LoadingState) {
      return Center(
        child: SizedBox(
          width: 64,
          height: 64,
          child: CircularProgressIndicator(color: Theme.of(context).colors.textPrimary),
        ),
      );
    }
    return TasksListView(
      tasks: widget.list,
      selectedTasksIDs: widget.vm.selectedTasksIDs.toList(),
      isSelectionMode: widget.vm.isSelectionMode,
      toggleSelection: widget.notifier.toggleSelection,
      startSelection: widget.notifier.startSelection,
      setDone: widget.notifier.setDone,
      onEdit: (task) async {
        final changed = await context.pushNamed<bool>(
          AppRoutes.editTask,
          pathParameters: {'id': task.id},
        );
        if (changed == true) {
          ref.read(homeViewModelProvider.notifier).loadAllData();
        }
      },
      onDelete: (id) async {
        final pendingController = PendingCommandController();
        final cmd = DeleteOneCommand(
          removeByIdOptimistic: widget.notifier.removeByIdOptimistic,
          restoreTasks: widget.notifier.restoreTasks,
          commitDeleteOne: widget.notifier.commitDeleteOne,
          id: id,
        );

        await pendingController.start(
          context: context,
          command: cmd,
          message: context.l10n.msg_tasks_deleted(1),
        );
      },
    );
  }
}
