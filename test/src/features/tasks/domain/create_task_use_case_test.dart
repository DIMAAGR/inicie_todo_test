import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/use_cases/create_task_use_case.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/value_objects/task_title.dart';
import 'package:mockito/mockito.dart';

import 'package:inicie_todo_test/src/core/failures/failures.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/entities/task_entity.dart';

import '../../../../mocks/mocks.mocks.mocks.dart';

void main() {
  late MockTaskRepository repo;
  late CreateTaskUseCase usecase;

  final task = TaskEntity(
    id: '1',
    title: TaskTitle.create('Teste').getOrElse(() => throw Exception()),
    createdAt: DateTime.now(),
  );

  setUp(() {
    repo = MockTaskRepository();
    usecase = CreateTaskUseCaseImpl(repo);
  });

  test('deve retornar Right(null) ao criar task com sucesso', () async {
    when(repo.createTask(task)).thenAnswer((_) async => const Right(null));

    final result = await usecase(task);

    expect(result.isRight(), true);
    verify(repo.createTask(task)).called(1);
    verifyNoMoreInteractions(repo);
  });

  test('deve retornar Failure quando repositório falha', () async {
    when(
      repo.createTask(task),
    ).thenAnswer((_) async => Left(ValidationFailure('erro')));

    final result = await usecase(task);

    expect(result.isLeft(), true);
    result.fold(
      (f) => expect(f, isA<ValidationFailure>()),
      (_) => fail('esperava Left'),
    );
  });
}
