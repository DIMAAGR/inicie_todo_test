import 'package:intl/intl.dart';

final _dfDate = DateFormat('dd/MM/yyyy');
final _dfTime = DateFormat('HH:mm');

bool _isCompleteDate(String s) => RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(s);
bool _isCompleteTime(String s) => RegExp(r'^\d{2}:\d{2}$').hasMatch(s);

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

DateTime _todayAtMidnight() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

String? validateTitle(String? v) {
  if (v == null || v.trim().isEmpty) return 'title_is_required';
  return null;
}

String? validateDate(String? s) {
  if (s == null || s.trim().isEmpty) return null;

  if (!_isCompleteDate(s)) return 'date_incomplete';

  final d = _parseDateStrict(s);
  if (d == null) return 'date_invalid';

  if (d.isBefore(_todayAtMidnight())) return 'date_cannot_be_in_the_past';
  return null;
}

String? validateTime(String? timeStr, {String? dateStr}) {
  if (timeStr == null || timeStr.trim().isEmpty) return null;

  if (!_isCompleteTime(timeStr)) return 'time_incomplete';

  DateTime baseDate;
  if (dateStr != null && dateStr.trim().isNotEmpty && _isCompleteDate(dateStr)) {
    final d = _parseDateStrict(dateStr);
    if (d == null) return 'date_invalid';
    baseDate = d;
  } else {
    baseDate = _todayAtMidnight();
  }

  final dt = _parseTimeOnDateStrict(timeStr, baseDate);
  if (dt == null) return 'time_invalid';

  final now = DateTime.now();
  if (DateTime(baseDate.year, baseDate.month, baseDate.day).isAtSameMomentAs(_todayAtMidnight())) {
    if (dt.isBefore(now)) return 'time_cannot_be_in_the_past';
  }
  return null;
}
