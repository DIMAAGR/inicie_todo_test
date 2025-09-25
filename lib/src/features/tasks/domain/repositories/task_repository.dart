import 'package:dartz/dartz.dart';
import 'package:inicie_todo_test/src/core/failures/failures.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/entities/task_entity.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<TaskEntity>>> getAllTasks();
  Future<Either<Failure, TaskEntity>> getTaskById(String id);
  Future<Either<Failure, void>> deleteFromId(String id);
  Future<Either<Failure, void>> deleteFromIdRange(Iterable<String> ids);
  Future<Either<Failure, void>> updateFromId(String id, TaskEntity task);
  Future<Either<Failure, void>> createTask(TaskEntity task);
}
