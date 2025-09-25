import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inicie_todo_test/src/core/failures/failures.dart';

final class TaskTitle extends Equatable {
  static const int maxLen = 250;
  final String value;

  const TaskTitle._(this.value);

  static Either<Failure, TaskTitle> create(String raw) {
    final text = raw.trim();
    if (text.isEmpty) {
      return Left(const ValidationFailure('title_required'));
    }
    if (text.length > maxLen) {
      return Left(ValidationFailure('max_length'));
    }
    return Right(TaskTitle._(text));
  }

  @override
  List<Object?> get props => [value];

  @override
  String toString() => value;
}
