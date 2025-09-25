import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/use_cases/get_all_tasks_use_case.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/value_objects/task_title.dart';
import 'package:mockito/mockito.dart';

import 'package:inicie_todo_test/src/core/failures/failures.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/entities/task_entity.dart';

import '../../../../mocks/mocks.mocks.mocks.dart';

void main() {
  late MockTaskRepository repo;
  late GetAllTasksUseCase usecase;

  final task = TaskEntity(
    id: '1',
    title: TaskTitle.create('Teste').getOrElse(() => throw Exception()),
    createdAt: DateTime.now(),
  );

  setUp(() {
    repo = MockTaskRepository();
    usecase = GetAllTasksUseCaseImpl(repo);
  });

  test(
    'deve retornar Right(List<TaskEntity>) quando repositório succeed',
    () async {
      when(repo.getAllTasks()).thenAnswer((_) async => Right([task]));

      final result = await usecase();

      expect(result.isRight(), true);
      result.fold((_) => fail('esperava Right'), (list) {
        expect(list, isA<List<TaskEntity>>());
        expect(list.first.id, '1');
      });
      verify(repo.getAllTasks()).called(1);
      verifyNoMoreInteractions(repo);
    },
  );

  test('deve retornar Failure quando repositório falha', () async {
    when(
      repo.getAllTasks(),
    ).thenAnswer((_) async => Left(StorageFailure('falha')));

    final result = await usecase();

    expect(result.isLeft(), true);
    result.fold(
      (f) => expect(f, isA<StorageFailure>()),
      (_) => fail('esperava Left'),
    );
  });
}
