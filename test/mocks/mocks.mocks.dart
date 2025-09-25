import 'package:inicie_todo_test/src/core/storage/wrapper/shared_preferences_wrapper.dart';
import 'package:inicie_todo_test/src/features/tasks/data/datasource/task_local_data_source.dart';
import 'package:inicie_todo_test/src/features/tasks/domain/repositories/task_repository.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([KeyValueWrapper, TasksLocalDataSource, TaskRepository])
void main() {}
