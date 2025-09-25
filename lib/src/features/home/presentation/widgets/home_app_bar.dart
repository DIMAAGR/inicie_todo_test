import 'package:flutter/material.dart';
import 'package:inicie_todo_test/src/core/presentation/commands/pending_undo_command_controller.dart';
import 'package:inicie_todo_test/src/core/presentation/extensions/color_ext.dart';
import 'package:inicie_todo_test/src/core/presentation/extensions/l10n_ext.dart';
import 'package:inicie_todo_test/src/core/theme/app_text_styles.dart';
import 'package:inicie_todo_test/src/features/home/presentation/view_model/home_view_model.dart';
import 'package:inicie_todo_test/src/features/home/presentation/view_model/home_view_model_state.dart';
import 'package:inicie_todo_test/src/features/tasks/presentation/commands/delete_commands.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final HomeViewModelState viewModel;
  final HomeViewModel notifier;
  const HomeAppBar({super.key, required this.viewModel, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      key: const ValueKey('selection-appbar'),
      leading: viewModel.isSelectionMode
          ? IconButton(
              icon: Icon(Icons.close, color: Theme.of(context).colors.textPrimary),
              onPressed: notifier.clearSelection,
              tooltip: context.l10n.home_cancel_selection,
            )
          : null,
      title: viewModel.isSelectionMode
          ? Text(
              context.l10n.home_selected_count(viewModel.selectedTasksIDs.length),
              style: AppTextStyles.body1Regular.copyWith(
                color: Theme.of(context).colors.textPrimary,
              ),
            )
          : null,
      actions: viewModel.isSelectionMode
          ? [
              IconButton(
                tooltip: 'delete_selecteds',
                icon: Icon(Icons.delete, color: Theme.of(context).colors.error),
                onPressed: viewModel.selectedTasksIDs.isEmpty
                    ? null
                    : () async {
                        final pendingController = PendingCommandController();
                        final ids = viewModel.selectedTasksIDs.toList();
                        final cmd = DeleteRangeCommand(
                          ids: ids,
                          removeByIdsOptimistic: notifier.removeByIdsOptimistic,
                          restoreTasks: notifier.restoreTasks,
                          commitDeleteRange: notifier.commitDeleteRange,
                        );

                        await pendingController.start(
                          context: context,
                          command: cmd,
                          message: context.l10n.msg_tasks_deleted(ids.length),
                        );
                      },
              ),
            ]
          : [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
