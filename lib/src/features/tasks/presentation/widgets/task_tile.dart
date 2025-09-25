import 'package:flutter/material.dart';
import 'package:inicie_todo_test/src/core/presentation/extensions/color_ext.dart';
import 'package:inicie_todo_test/src/core/presentation/extensions/date_ext.dart';
import 'package:inicie_todo_test/src/core/theme/app_text_styles.dart';

class TaskTile extends StatelessWidget {
  final String id;
  final String title;
  final DateTime? date;
  final bool isCompleted;
  final bool selected;
  final bool isSelectionEnabled;
  final ValueChanged<bool>? onChanged;

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onLongPress;
  final VoidCallback? onTap;

  const TaskTile({
    super.key,
    required this.id,
    required this.title,
    this.date,
    required this.isCompleted,
    required this.selected,
    required this.isSelectionEnabled,
    this.onChanged,
    this.onEdit,
    this.onDelete,
    this.onLongPress,
    this.onTap,
  });

  Color _dateColor(BuildContext context) {
    if (selected) return Theme.of(context).colors.textLight;
    if (isCompleted) return Theme.of(context).colors.success;
    if (date == null) return Theme.of(context).colors.textSecondary;
    if (date!.isOlderThanNow) return Theme.of(context).colors.error;
    if (date!.isToday) return Theme.of(context).colors.warning;
    return Theme.of(context).colors.textSecondary;
  }

  @override
  Widget build(BuildContext context) {
    final dateColor = _dateColor(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selected ? Colors.transparent : Theme.of(context).colors.textSecondary,
          width: 1,
        ),
      ),
      child: ListTile(
        selected: selected,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
        selectedTileColor: Theme.of(context).colors.selectionEffect,
        contentPadding: EdgeInsets.zero,
        horizontalTitleGap: 0,
        onTap: isSelectionEnabled ? onTap : () => onChanged?.call(!isCompleted),
        onLongPress: onLongPress,
        leading: SizedBox(
          width: 40,
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14.0),
              child: Checkbox(
                value: isCompleted,
                side: BorderSide(
                  color: selected
                      ? Theme.of(context).colors.textLight
                      : isCompleted
                      ? Theme.of(context).colors.success
                      : Theme.of(context).colors.textSecondary,
                ),
                activeColor: Theme.of(context).colors.success,
                onChanged: (v) => onChanged?.call(v ?? false),
              ),
            ),
          ),
        ),

        title: Text(
          title,
          style: AppTextStyles.body2Bold.copyWith(
            color: selected
                ? Theme.of(context).colors.textLight
                : isCompleted
                ? Theme.of(context).colors.textSecondary
                : Theme.of(context).colors.textPrimary,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
          overflow: TextOverflow.clip,
        ),

        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.calendar_today_outlined, size: 12, color: dateColor),
            const SizedBox(width: 4),
            Text(
              date != null ? date!.formatRelative() : 'no_due_date',
              style: AppTextStyles.caption.copyWith(color: dateColor),
            ),
          ],
        ),

        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              onEdit?.call();
            } else if (value == 'delete') {
              onDelete?.call();
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(children: [Icon(Icons.edit, size: 18), SizedBox(width: 8), Text('edit')]),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 18, color: Theme.of(context).colors.error),
                  SizedBox(width: 8),
                  Text(
                    'delete',
                    style: AppTextStyles.body2Regular.copyWith(
                      color: Theme.of(context).colors.error,
                    ),
                  ),
                ],
              ),
            ),
          ],
          icon: Icon(
            Icons.more_vert,
            color: selected ? Theme.of(context).colors.textLight : Colors.grey[600],
          ),
        ),
      ),
    );
  }
}
