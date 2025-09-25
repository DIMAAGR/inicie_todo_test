import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:inicie_todo_test/src/core/failures/failures.dart';
import 'package:inicie_todo_test/src/features/tasks/data/models/task_model.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/entities/task_entity.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/mappers/task_mapper.dart';
import 'package:inicie_todo_test/src/features/tasks/data/repositories/task_repository_impl.dart';

import '../../../../../mocks/mocks.mocks.mocks.dart';

void main() {
  late MockTasksLocalDataSource ds;
  late TaskRepositoryImpl repo;

  TaskModel m({
    required String id,
    String title = 'T',
    DateTime? createdAt,
    DateTime? dueDate,
    bool done = false,
  }) {
    return TaskModel(
      id: id,
      title: title,
      createdAt: (createdAt ?? DateTime(2025, 1, 1)).millisecondsSinceEpoch,
      dueDate: dueDate?.millisecondsSinceEpoch,
      done: done,
    );
  }

  TaskEntity e({
    required String id,
    String title = 'T',
    DateTime? createdAt,
    DateTime? dueDate,
    bool done = false,
  }) {
    return TaskMapper.toEntity(
      m(
        id: id,
        title: title,
        createdAt: createdAt,
        dueDate: dueDate,
        done: done,
      ),
    );
  }

  setUp(() {
    ds = MockTasksLocalDataSource();
    repo = TaskRepositoryImpl(ds);
  });

  group('getAllTasks', () {
    test('retorna Right com lista mapeada', () async {
      when(
        ds.getAllTasks(),
      ).thenAnswer((_) async => [m(id: '1'), m(id: '2', title: 'B')]);

      final res = await repo.getAllTasks();

      expect(res.isRight(), true);
      res.fold((_) => fail('esperava Right'), (list) {
        expect(list.length, 2);
        expect(list[0].id, '1');
        expect(list[1].title.value, 'B');
      });

      verify(ds.getAllTasks()).called(1);
      verifyNoMoreInteractions(ds);
    });

    test('encapsula exceção em StorageFailure', () async {
      when(ds.getAllTasks()).thenThrow(Exception('boom'));

      final res = await repo.getAllTasks();

      expect(res.isLeft(), true);
      res.fold(
        (f) => expect(f, isA<StorageFailure>()),
        (_) => fail('esperava Left'),
      );
    });
  });

  group('deleteFromId', () {
    test('filtra id e salva lista', () async {
      when(ds.getAllTasks()).thenAnswer((_) async => [m(id: '1'), m(id: '2')]);
      when(ds.saveAllTasks(any)).thenAnswer((_) async => true);

      final res = await repo.deleteFromId('1');

      expect(res.isRight(), true);

      final captured =
          verify(ds.saveAllTasks(captureAny)).captured.single
              as List<TaskModel>;
      expect(captured.length, 1);
      expect(captured.first.id, '2');

      verify(ds.getAllTasks()).called(1);
      verifyNoMoreInteractions(ds);
    });

    test('erro no datasource vira StorageFailure', () async {
      when(ds.getAllTasks()).thenThrow(Exception('x'));

      final res = await repo.deleteFromId('1');

      expect(res.isLeft(), true);
      res.fold(
        (f) => expect(f, isA<StorageFailure>()),
        (_) => fail('esperava Left'),
      );
    });
  });

  group('deleteFromIdRange', () {
    test('remove todos ids e salva', () async {
      when(
        ds.getAllTasks(),
      ).thenAnswer((_) async => [m(id: '1'), m(id: '2'), m(id: '3')]);
      when(ds.saveAllTasks(any)).thenAnswer((_) async => true);

      final res = await repo.deleteFromIdRange(['1', '3']);

      expect(res.isRight(), true);

      final saved =
          verify(ds.saveAllTasks(captureAny)).captured.single
              as List<TaskModel>;
      expect(saved.map((mm) => mm.id), ['2']);

      verify(ds.getAllTasks()).called(1);
      verifyNoMoreInteractions(ds);
    });
  });

  group('updateFromId', () {
    test('atualiza quando id existe', () async {
      when(ds.getAllTasks()).thenAnswer((_) async => [m(id: '1'), m(id: '2')]);
      when(ds.saveAllTasks(any)).thenAnswer((_) async => true);

      final entity = e(id: '2', title: 'Novo');
      final res = await repo.updateFromId('2', entity);

      expect(res.isRight(), true);

      final saved =
          verify(ds.saveAllTasks(captureAny)).captured.single
              as List<TaskModel>;
      expect(saved[1].id, '2');
      expect(saved[1].title, 'Novo');

      verify(ds.getAllTasks()).called(1);
      verifyNoMoreInteractions(ds);
    });

    test('retorna NotFoundFailure quando id não existe', () async {
      when(ds.getAllTasks()).thenAnswer((_) async => [m(id: '1')]);

      final entity = e(id: '2', title: 'Novo');
      final res = await repo.updateFromId('2', entity);

      expect(res.isLeft(), true);
      res.fold(
        (f) => expect(f, isA<NotFoundFailure>()),
        (_) => fail('esperava Left'),
      );
    });

    test('erro genérico vira StorageFailure', () async {
      when(ds.getAllTasks()).thenThrow(Exception('x'));

      final res = await repo.updateFromId('2', e(id: '2'));

      expect(res.isLeft(), true);
      res.fold(
        (f) => expect(f, isA<StorageFailure>()),
        (_) => fail('esperava Left'),
      );
    });
  });

  group('createTask', () {
    test('retorna ValidationFailure se id já existe', () async {
      when(ds.getAllTasks()).thenAnswer((_) async => [m(id: 'a')]);

      final res = await repo.createTask(e(id: 'a'));

      expect(res.isLeft(), true);
      res.fold(
        (f) => expect(f, isA<ValidationFailure>()),
        (_) => fail('esperava Left'),
      );
    });

    test('adiciona e salva quando id é novo', () async {
      when(ds.getAllTasks()).thenAnswer((_) async => [m(id: 'a')]);
      when(ds.saveAllTasks(any)).thenAnswer((_) async => true);

      final res = await repo.createTask(e(id: 'b', title: 'B'));

      expect(res.isRight(), true);

      final saved =
          verify(ds.saveAllTasks(captureAny)).captured.single
              as List<TaskModel>;
      expect(saved.map((mm) => mm.id), ['a', 'b']);

      verify(ds.getAllTasks()).called(1);
      verifyNoMoreInteractions(ds);
    });

    test('erro no datasource vira StorageFailure', () async {
      when(ds.getAllTasks()).thenThrow(Exception('x'));

      final res = await repo.createTask(e(id: 'b'));

      expect(res.isLeft(), true);
      res.fold(
        (f) => expect(f, isA<StorageFailure>()),
        (_) => fail('esperava Left'),
      );
    });
  });

  group('getTaskById', () {
    test('retorna Right(entity) quando existe', () async {
      when(ds.getTaskById('1')).thenAnswer((_) async => m(id: '1'));

      final res = await repo.getTaskById('1');

      expect(res.isRight(), true);
      res.fold((_) => fail('esperava Right'), (ent) => expect(ent.id, '1'));

      verify(ds.getTaskById('1')).called(1);
      verifyNoMoreInteractions(ds);
    });

    test('retorna NotFoundFailure quando não existe', () async {
      when(ds.getTaskById('x')).thenAnswer((_) async => null);

      final res = await repo.getTaskById('x');

      expect(res.isLeft(), true);
      res.fold(
        (f) => expect(f, isA<NotFoundFailure>()),
        (_) => fail('esperava Left'),
      );
    });

    test('erro genérico vira StorageFailure', () async {
      when(ds.getTaskById(any)).thenThrow(Exception('boom'));

      final res = await repo.getTaskById('1');

      expect(res.isLeft(), true);
      res.fold(
        (f) => expect(f, isA<StorageFailure>()),
        (_) => fail('esperava Left'),
      );
    });
  });
}
