import 'package:inicie_todo_test/src/core/presentation/commands/undo_command.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/entities/task_entity.dart';

class DeleteOneCommand implements UndoCommand {
  final TaskEntity? Function(String id) removeByIdOptimistic;
  final void Function(List<TaskEntity> items) restoreTasks;
  final Future<void> Function(String id) commitDeleteOne;
  final String id;

  TaskEntity? _backup;
  bool _undone = false;
  bool _committed = false;

  DeleteOneCommand({
    required this.removeByIdOptimistic,
    required this.commitDeleteOne,
    required this.restoreTasks,
    required this.id,
  }) {
    _backup = removeByIdOptimistic(id);
  }

  @override
  bool get undone => _undone;

  @override
  bool get committed => _committed;

  @override
  void undo() {
    if (_undone || _committed) return;
    if (_backup != null) restoreTasks([_backup!]);
    _undone = true;
  }

  @override
  Future<void> commit() async {
    if (_undone || _committed) return;
    try {
      await commitDeleteOne(id);
      _committed = true;
    } catch (e) {
      if (_backup != null) restoreTasks([_backup!]);
      _undone = true;
      rethrow;
    }
  }
}

class DeleteRangeCommand implements UndoCommand {
  final Iterable<String> ids;
  final List<TaskEntity> Function(Iterable<String> ids) removeByIdsOptimistic;
  final void Function(List<TaskEntity> items) restoreTasks;
  final Future<void> Function(Iterable<String> ids) commitDeleteRange;

  late final List<TaskEntity> _backup;
  bool _undone = false;
  bool _committed = false;

  DeleteRangeCommand({
    required this.ids,
    required this.removeByIdsOptimistic,
    required this.restoreTasks,
    required this.commitDeleteRange,
  }) {
    _backup = removeByIdsOptimistic(ids);
  }

  @override
  bool get undone => _undone;

  @override
  bool get committed => _committed;

  @override
  void undo() {
    if (_undone || _committed) return;
    if (_backup.isNotEmpty) restoreTasks(_backup);
    _undone = true;
  }

  @override
  Future<void> commit() async {
    if (_undone || _committed) return;
    try {
      await commitDeleteRange(ids);
      _committed = true;
    } catch (e) {
      if (_backup.isNotEmpty) restoreTasks(_backup);
      _undone = true;
      rethrow;
    }
  }
}
