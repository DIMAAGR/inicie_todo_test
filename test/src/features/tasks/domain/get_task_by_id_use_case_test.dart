import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/use_cases/get_task_by_id_use_case.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/value_objects/task_title.dart';
import 'package:mockito/mockito.dart';

import 'package:inicie_todo_test/src/core/failures/failures.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/entities/task_entity.dart';

import '../../../../mocks/mocks.mocks.mocks.dart';

void main() {
  late MockTaskRepository repo;
  late GetTaskByIdUseCase usecase;

  final task = TaskEntity(
    id: '123',
    title: TaskTitle.create('Teste').getOrElse(() => throw Exception()),
    createdAt: DateTime.now(),
  );

  setUp(() {
    repo = MockTaskRepository();
    usecase = GetTaskByIdUseCaseImpl(repo);
  });

  test('deve retornar Right(TaskEntity) quando repositório encontra', () async {
    when(repo.getTaskById('123')).thenAnswer((_) async => Right(task));

    final result = await usecase('123');

    expect(result.isRight(), true);
    result.fold((_) => fail('esperava Right'), (ent) => expect(ent.id, '123'));

    verify(repo.getTaskById('123')).called(1);
    verifyNoMoreInteractions(repo);
  });

  test(
    'deve retornar NotFoundFailure quando repositório não encontra',
    () async {
      when(
        repo.getTaskById('x'),
      ).thenAnswer((_) async => Left(NotFoundFailure('Task not found')));

      final result = await usecase('x');

      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f, isA<NotFoundFailure>()),
        (_) => fail('esperava Left'),
      );
    },
  );

  test('deve retornar StorageFailure em erro inesperado', () async {
    when(
      repo.getTaskById(any),
    ).thenAnswer((_) async => Left(StorageFailure('boom')));

    final result = await usecase('y');

    expect(result.isLeft(), true);
    result.fold(
      (f) => expect(f, isA<StorageFailure>()),
      (_) => fail('esperava Left'),
    );
  });
}
