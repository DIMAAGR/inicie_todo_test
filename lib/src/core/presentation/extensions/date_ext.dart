import 'package:intl/intl.dart';

extension DateExt on DateTime {
  String formatRelative() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(year, month, day);

    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('dd/MM/yy');

    if (date == today) {
      return 'Hoje às ${timeFormat.format(this)}';
    } else if (date == today.subtract(const Duration(days: 1))) {
      return 'Ontem às ${timeFormat.format(this)}';
    } else if (date == today.add(const Duration(days: 1))) {
      return 'Amanhã às ${timeFormat.format(this)}';
    } else {
      return '${dateFormat.format(this)} às ${timeFormat.format(this)}';
    }
  }

  String toDDMMYYYY() {
    final dateFormat = DateFormat('dd/MM/yyyy');
    return dateFormat.format(this);
  }

  String toHHMM() {
    final timeFormat = DateFormat('HH:mm');
    return timeFormat.format(this);
  }

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  bool get isOlderThanNow {
    final now = DateTime.now();
    return isBefore(now);
  }

  
}