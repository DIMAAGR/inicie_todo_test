import 'package:dartz/dartz.dart';
import 'package:inicie_todo_test/src/core/failures/failures.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/repositories/task_repository.dart';

abstract class DeleteFromIdRangeUseCase {
  Future<Either<Failure, void>> call(Iterable<String> ids);
}

class DeleteFromIdRangeUseCaseImpl implements DeleteFromIdRangeUseCase {
  final TaskRepository repository;

  DeleteFromIdRangeUseCaseImpl(this.repository);

  @override
  Future<Either<Failure, void>> call(Iterable<String> ids) async {
    return repository.deleteFromIdRange(ids);
  }
}
