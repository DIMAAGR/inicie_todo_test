import 'package:flutter/material.dart';
import 'package:inicie_todo_test/src/core/presentation/extensions/l10n_ext.dart';
import 'package:intl/intl.dart';

extension DateExt on DateTime {
  String formatRelative(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(year, month, day);

    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('dd/MM/yy');
    final l10n = context.l10n;

    final time = timeFormat.format(this);

    if (date == today) {
      return l10n.date_today(time);
    } else if (date == today.subtract(const Duration(days: 1))) {
      return l10n.date_yesterday(time);
    } else if (date == today.add(const Duration(days: 1))) {
      return l10n.date_tomorrow(time);
    } else {
      return l10n.date_default(dateFormat.format(this), time);
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
