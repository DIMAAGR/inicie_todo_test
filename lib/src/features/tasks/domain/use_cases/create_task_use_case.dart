import 'package:dartz/dartz.dart';
import 'package:inicie_todo_test/src/core/failures/failures.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/entities/task_entity.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/repositories/task_repository.dart';

abstract class CreateTaskUseCase {
  Future<Either<Failure, void>> call(TaskEntity task);
}

class CreateTaskUseCaseImpl implements CreateTaskUseCase {
  final TaskRepository repository;

  CreateTaskUseCaseImpl(this.repository);

  @override
  Future<Either<Failure, void>> call(TaskEntity task) async {
    return await repository.createTask(task);
  }
}
