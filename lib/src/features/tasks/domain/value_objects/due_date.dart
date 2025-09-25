import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:inicie_todo_test/src/core/failures/failures.dart';

final _dfDate = DateFormat('dd/MM/yyyy');
final _dfTime = DateFormat('HH:mm');

bool _isCompleteDate(String s) => RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(s);
bool _isCompleteTime(String s) => RegExp(r'^\d{2}:\d{2}$').hasMatch(s);

DateTime _todayAtMidnight() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

DateTime? _parseDateStrict(String s) {
  try {
    return _dfDate.parseStrict(s);
  } catch (_) {
    return null;
  }
}

DateTime? _parseTimeOnDateStrict(String time, DateTime date) {
  try {
    final t = _dfTime.parseStrict(time);
    return DateTime(date.year, date.month, date.day, t.hour, t.minute);
  } catch (_) {
    return null;
  }
}

final class DueDate extends Equatable {
  final DateTime? value;
  const DueDate._(this.value);

  static Either<Failure, DueDate> fromUser({String? date, String? time, bool forbidPast = false}) {
    final dateRaw = (date ?? '').trim();
    final timeRaw = (time ?? '').trim();

    if (dateRaw.isEmpty && timeRaw.isEmpty) {
      return Right(const DueDate._(null));
    }

    var baseDate = _todayAtMidnight();

    if (dateRaw.isNotEmpty) {
      if (!_isCompleteDate(dateRaw)) {
        return const Left(ValidationFailure('invalid_date_format'));
      }
      final parsedDate = _parseDateStrict(dateRaw);
      if (parsedDate == null) {
        return const Left(ValidationFailure('invalid_date'));
      }
      if (forbidPast && parsedDate.isBefore(baseDate)) {
        return const Left(ValidationFailure('date_before_today'));
      }
      baseDate = parsedDate;
    }

    if (timeRaw.isEmpty) {
      final candidate = DateTime(baseDate.year, baseDate.month, baseDate.day, 23, 59);
      return Right(DueDate._(candidate));
    }

    if (!_isCompleteTime(timeRaw)) {
      return const Left(ValidationFailure('invalid_time_format'));
    }
    final parsedTime = _parseTimeOnDateStrict(timeRaw, baseDate);
    if (parsedTime == null) {
      return const Left(ValidationFailure('invalid_time'));
    }

    if (forbidPast && baseDate.isAtSameMomentAs(_todayAtMidnight())) {
      if (parsedTime.isBefore(DateTime.now())) {
        return const Left(ValidationFailure('time_before_now'));
      }
    }

    return Right(DueDate._(parsedTime));
  }

  factory DueDate.fromEpochMs(int? epochMs) {
    if (epochMs == null) return const DueDate._(null);
    return DueDate._(DateTime.fromMillisecondsSinceEpoch(epochMs));
  }

  int? toEpochMs() => value?.millisecondsSinceEpoch;

  bool get hasDate => value != null;
  bool get isOverdue {
    if (value == null) return false;
    return value!.isBefore(DateTime.now());
  }

  @override
  List<Object?> get props => [value];
}
