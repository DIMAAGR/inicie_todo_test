import 'package:dartz/dartz.dart';
import 'package:inicie_todo_test/src/core/failures/failures.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/entities/task_entity.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/repositories/task_repository.dart';

abstract class GetAllTasksUseCase {
  Future<Either<Failure, List<TaskEntity>>> call();
}

class GetAllTasksUseCaseImpl implements GetAllTasksUseCase {
  final TaskRepository repository;

  GetAllTasksUseCaseImpl(this.repository);

  @override
  Future<Either<Failure, List<TaskEntity>>> call() {
    return repository.getAllTasks();
  }
}
