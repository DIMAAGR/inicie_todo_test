import 'package:dartz/dartz.dart';
import 'package:inicie_todo_test/src/core/failures/failures.dart';
import 'package:inicie_todo_test/src/features/tasks/data/datasource/task_local_data_source.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/entities/task_entity.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/mappers/task_mapper.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TasksLocalDataSource local;

  TaskRepositoryImpl(this.local);

  @override
  Future<Either<Failure, List<TaskEntity>>> getAllTasks() async {
    try {
      final models = await local.getAllTasks();
      return Right(models.map((m) => TaskMapper.toEntity(m)).toList());
    } catch (e, s) {
      return Left(
        StorageFailure('Failed to load tasks', cause: e, stackTrace: s),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteFromId(String id) async {
    try {
      final list = await local.getAllTasks();
      final filtered = list.where((t) => t.id != id).toList();
      await local.saveAllTasks(filtered);
      return Right(null);
    } catch (e, s) {
      return Left(
        StorageFailure('Failed to delete task', cause: e, stackTrace: s),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteFromIdRange(Iterable<String> ids) async {
    try {
      final set = ids.toSet();
      final list = await local.getAllTasks();
      final filtered = list.where((t) => !set.contains(t.id)).toList();
      await local.saveAllTasks(filtered);
      return Right(null);
    } catch (e, s) {
      return Left(
        StorageFailure('Failed to delete tasks', cause: e, stackTrace: s),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateFromId(id, TaskEntity task) async {
    try {
      final list = await local.getAllTasks();
      final idx = list.indexWhere((t) => t.id == id);
      if (idx == -1) return Left(NotFoundFailure('Task not found'));
      list[idx] = TaskMapper.toModel(task);
      await local.saveAllTasks(list);
      return Right(null);
    } catch (e, s) {
      return Left(
        StorageFailure('Failed to edit task', cause: e, stackTrace: s),
      );
    }
  }

  @override
  Future<Either<Failure, void>> createTask(TaskEntity task) async {
    try {
      final list = await local.getAllTasks();
      final exists = list.any((t) => t.id == task.id);
      if (exists) return Left(ValidationFailure('Task id already exists'));
      final next = [...list, TaskMapper.toModel(task)];
      await local.saveAllTasks(next);
      return Right(null);
    } catch (e, s) {
      return Left(
        StorageFailure('Failed to create task', cause: e, stackTrace: s),
      );
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> getTaskById(String id) async {
    try {
      final model = await local.getTaskById(id);
      if (model == null) return Left(NotFoundFailure('Task not found'));
      final entity = TaskMapper.toEntity(model);
      return Right(entity);
    } catch (e, s) {
      return Left(
        StorageFailure('Failed to load task', cause: e, stackTrace: s),
      );
    }
  }
}
