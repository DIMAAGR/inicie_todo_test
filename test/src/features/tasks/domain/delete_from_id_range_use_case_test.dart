import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/use_cases/delete_from_id_range_use_case.dart';
import 'package:mockito/mockito.dart';

import 'package:inicie_todo_test/src/core/failures/failures.dart';

import '../../../../mocks/mocks.mocks.mocks.dart';

void main() {
  late MockTaskRepository repo;
  late DeleteFromIdRangeUseCase usecase;

  setUp(() {
    repo = MockTaskRepository();
    usecase = DeleteFromIdRangeUseCaseImpl(repo);
  });

  test('deve retornar Right(null) quando exclusão for bem sucedida', () async {
    when(
      repo.deleteFromIdRange(['a', 'b']),
    ).thenAnswer((_) async => const Right(null));

    final result = await usecase(['a', 'b']);

    expect(result.isRight(), true);
    verify(repo.deleteFromIdRange(['a', 'b'])).called(1);
    verifyNoMoreInteractions(repo);
  });

  test('deve retornar Failure quando repositório falha', () async {
    when(
      repo.deleteFromIdRange(any),
    ).thenAnswer((_) async => Left(StorageFailure('erro')));

    final result = await usecase(['x']);

    expect(result.isLeft(), true);
    result.fold(
      (f) => expect(f, isA<StorageFailure>()),
      (_) => fail('esperava Left'),
    );
  });
}
