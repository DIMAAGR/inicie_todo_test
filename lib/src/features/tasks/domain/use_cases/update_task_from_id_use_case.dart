import 'package:dartz/dartz.dart';
import 'package:inicie_todo_test/src/core/failures/failures.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/repositories/task_repository.dart';
import '../entities/task_entity.dart';

abstract class UpdateTaskFromIdUseCase {
  Future<Either<Failure, void>> call(String id, TaskEntity data);
}

class UpdateTaskFromIdUseCaseImpl implements UpdateTaskFromIdUseCase {
  final TaskRepository repository;

  UpdateTaskFromIdUseCaseImpl(this.repository);

  @override
  Future<Either<Failure, void>> call(String id, TaskEntity data) async {
    return repository.updateFromId(id, data);
  }
}
