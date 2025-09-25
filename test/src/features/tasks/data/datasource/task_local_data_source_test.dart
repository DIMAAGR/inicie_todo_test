import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:inicie_todo_test/src/features/tasks/data/datasource/task_local_data_source.dart';
import 'package:inicie_todo_test/src/features/tasks/data/datasource/task_local_data_source_impl.dart';
import 'package:mockito/mockito.dart';

import 'package:inicie_todo_test/src/core/storage/schema/storage_schema.dart';
import 'package:inicie_todo_test/src/features/tasks/data/models/task_model.dart';

import '../../../../../mocks/mocks.mocks.mocks.dart';

void main() {
  late MockKeyValueWrapper store;
  late TasksLocalDataSource ds;

  const key = StorageSchema.tasksKey;

  TaskModel sample({
    String id = '1',
    String title = 'Task',
    int? createdAt,
    int? dueDate,
    bool done = false,
    String? categoryId,
  }) {
    return TaskModel(
      id: id,
      title: title,
      createdAt: createdAt ?? DateTime(2025, 1, 1).millisecondsSinceEpoch,
      dueDate: dueDate,
      done: done,
    );
  }

  setUp(() {
    store = MockKeyValueWrapper();
    ds = TasksLocalDataSourceImpl(store);
  });

  group('getAllTasks', () {
    test('retorna lista vazia quando storage está vazio', () async {
      when(store.getString(key)).thenReturn(null);

      final result = await ds.getAllTasks();

      expect(result, isEmpty);
      verify(store.getString(key)).called(1);
      verifyNoMoreInteractions(store);
    });

    test('parseia JSON válido para lista de TaskModel', () async {
      final list = [
        sample(id: '1').toJson(),
        sample(id: '2', title: 'Outra').toJson(),
      ];
      when(store.getString(key)).thenReturn(jsonEncode(list));

      final result = await ds.getAllTasks();

      expect(result.map((e) => e.id), ['1', '2']);
      expect(result.first.title, 'Task');
      expect(result[1].title, 'Outra');
      verify(store.getString(key)).called(1);
      verifyNoMoreInteractions(store);
    });
  });

  group('saveAllTasks', () {
    test('serializa e salva no store', () async {
      final models = [sample(id: 'a'), sample(id: 'b', title: 'B')];

      when(store.setString(any, any)).thenAnswer((_) async => true);

      await ds.saveAllTasks(models);

      final captured =
          verify(store.setString(key, captureAny)).captured.single as String;
      final decoded = jsonDecode(captured) as List<dynamic>;
      expect(decoded, isA<List>());
      expect(decoded.length, 2);
      expect(decoded[0]['id'], 'a');
      expect(decoded[1]['title'], 'B');

      verifyNoMoreInteractions(store);
    });
  });

  group('getTaskById', () {
    test('retorna nulo quando storage não tem nada', () async {
      when(store.getString(key)).thenReturn(null);

      final r = await ds.getTaskById('x');

      expect(r, isNull);
      verify(store.getString(key)).called(1);
      verifyNoMoreInteractions(store);
    });

    test('retorna a task quando id existe', () async {
      final list = [sample(id: '1').toJson(), sample(id: '2').toJson()];
      when(store.getString(key)).thenReturn(jsonEncode(list));

      final r = await ds.getTaskById('2');

      expect(r, isNotNull);
      expect(r!.id, '2');
      verify(store.getString(key)).called(1);
      verifyNoMoreInteractions(store);
    });

    test(
      'lança StateError quando id não existe (comportamento atual)',
      () async {
        final list = [sample(id: '1').toJson()];
        when(store.getString(key)).thenReturn(jsonEncode(list));

        expect(ds.getTaskById('zzz'), throwsA(isA<StateError>()));

        verify(store.getString(key)).called(1);
        verifyNoMoreInteractions(store);
      },
    );
  });
}
