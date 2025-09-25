import 'package:flutter/material.dart';
import 'package:inicie_todo_test/src/core/presentation/extensions/color_ext.dart';
import 'package:inicie_todo_test/src/core/presentation/widgets/fade_in.dart';
import 'package:inicie_todo_test/src/core/theme/app_text_styles.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/entities/task_entity.dart';
import 'package:inicie_todo_test/src/features/tasks/presentation/widgets/task_tile.dart';

class TasksListView extends StatefulWidget {
  final List<TaskEntity> tasks;
  final List<String> selectedTasksIDs;
  final bool isSelectionMode;
  final void Function(String id) toggleSelection;
  final void Function(String id) startSelection;
  final void Function(String id, bool done) setDone;
  final void Function(TaskEntity task) onEdit;
  final void Function(String id) onDelete;

  const TasksListView({
    super.key,
    required this.tasks,
    required this.selectedTasksIDs,
    required this.isSelectionMode,
    required this.toggleSelection,
    required this.startSelection,
    required this.setDone,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<TasksListView> createState() => _TasksListViewState();
}

class _TasksListViewState extends State<TasksListView> {
  final _animated = <String>{};

  @override
  Widget build(BuildContext context) {
    if (widget.tasks.isEmpty) {
      return FadeIn(
        delay: Duration(milliseconds: 500),
        child: Center(
          child: Text(
            'no_have_tasks',
            style: AppTextStyles.subtitle1Medium.copyWith(
              color: Theme.of(context).colors.textPrimary,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      cacheExtent: 0,
      padding: EdgeInsets.symmetric(horizontal: 16),
      addAutomaticKeepAlives: false,
      itemCount: widget.tasks.length,
      itemBuilder: (context, index) {
        final t = widget.tasks[index];
        final selected = widget.selectedTasksIDs.contains(t.id);

        final shouldAnimate = _animated.add(t.id);

        final tile = Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: TaskTile(
            key: ValueKey(t.id),
            id: t.id,
            title: t.title.value,
            date: t.dueDate?.value,
            isCompleted: t.done,
            selected: selected,
            isSelectionEnabled: widget.isSelectionMode,
            onTap: () => widget.toggleSelection(t.id),
            onLongPress: () => widget.startSelection(t.id),
            onChanged: (done) => widget.setDone(t.id, done),
            onEdit: () => widget.onEdit(t),
            onDelete: () => widget.onDelete(t.id),
          ),
        );

        return shouldAnimate
            ? FadeIn(
                delay: Duration(milliseconds: 400 + (index * 100)),
                child: tile,
              )
            : tile;
      },
    );
  }
}
