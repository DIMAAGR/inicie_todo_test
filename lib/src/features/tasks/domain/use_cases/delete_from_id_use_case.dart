import 'package:dartz/dartz.dart';
import 'package:inicie_todo_test/src/core/failures/failures.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/repositories/task_repository.dart';

abstract class DeleteFromIdUseCase {
  Future<Either<Failure, void>> call(String id);
}

class DeleteFromIdUseCaseImpl implements DeleteFromIdUseCase {
  final TaskRepository repository;

  DeleteFromIdUseCaseImpl(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    return repository.deleteFromId(id);
  }
}
