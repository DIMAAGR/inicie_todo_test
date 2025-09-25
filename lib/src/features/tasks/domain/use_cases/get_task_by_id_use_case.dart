import 'package:dartz/dartz.dart';
import 'package:inicie_todo_test/src/core/failures/failures.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/entities/task_entity.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/repositories/task_repository.dart';

abstract class GetTaskByIdUseCase {
  Future<Either<Failure, TaskEntity>> call(String id);
}

class GetTaskByIdUseCaseImpl implements GetTaskByIdUseCase {
  final TaskRepository repository;

  GetTaskByIdUseCaseImpl(this.repository);

  @override
  Future<Either<Failure, TaskEntity>> call(String id) {
    return repository.getTaskById(id);
  }
}
