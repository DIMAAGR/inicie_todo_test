import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/use_cases/update_task_from_id_use_case.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/value_objects/task_title.dart';
import 'package:mockito/mockito.dart';

import 'package:inicie_todo_test/src/core/failures/failures.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/entities/task_entity.dart';

import '../../../../mocks/mocks.mocks.mocks.dart';

void main() {
  late MockTaskRepository repo;
  late UpdateTaskFromIdUseCase usecase;

  final task = TaskEntity(
    id: '1',
    title: TaskTitle.create('Atualizada').getOrElse(() => throw Exception()),
    createdAt: DateTime.now(),
  );

  setUp(() {
    repo = MockTaskRepository();
    usecase = UpdateTaskFromIdUseCaseImpl(repo);
  });

  test('deve retornar Right(void) quando update for bem sucedido', () async {
    when(
      repo.updateFromId('123', task),
    ).thenAnswer((_) async => const Right(null));

    final result = await usecase('123', task);

    expect(result.isRight(), true);
    verify(repo.updateFromId('123', task)).called(1);
    verifyNoMoreInteractions(repo);
  });

  test('deve retornar NotFoundFailure quando task não existir', () async {
    when(
      repo.updateFromId('999', task),
    ).thenAnswer((_) async => Left(NotFoundFailure('Task not found')));

    final result = await usecase('999', task);

    expect(result.isLeft(), true);
    result.fold(
      (f) => expect(f, isA<NotFoundFailure>()),
      (_) => fail('esperava Left'),
    );
  });

  test('deve retornar StorageFailure em erro inesperado', () async {
    when(
      repo.updateFromId(any, any),
    ).thenAnswer((_) async => Left(StorageFailure('boom')));

    final result = await usecase('123', task);

    expect(result.isLeft(), true);
    result.fold(
      (f) => expect(f, isA<StorageFailure>()),
      (_) => fail('esperava Left'),
    );
  });
}
