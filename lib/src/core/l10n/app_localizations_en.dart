// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_title => 'Inicie To-do';

  @override
  String get home_welcome => 'Welcome to\nInicie To-do!';

  @override
  String get home_tab_all => 'All Tasks';

  @override
  String get home_tab_pending => 'Pending';

  @override
  String get home_tab_completed => 'Completed';

  @override
  String get home_empty => 'No tasks found';

  @override
  String home_selected_count(int count) {
    return '$count selected';
  }

  @override
  String get home_cancel_selection => 'Cancel selection';

  @override
  String get home_menu_edit => 'Edit';

  @override
  String get home_menu_delete => 'Delete';

  @override
  String get task_new_title => 'Create new task';

  @override
  String get task_edit_title => 'Edit task';

  @override
  String get task_field_title => 'Title';

  @override
  String get task_field_title_hint => 'Enter the title';

  @override
  String get task_field_date => 'Date (Optional)';

  @override
  String get task_field_time => 'Time (Optional)';

  @override
  String get task_button_save => 'Save';

  @override
  String get task_no_due_date => 'No due date';

  @override
  String get msg_task_created => 'Task created successfully';

  @override
  String get msg_task_updated => 'Task updated successfully';

  @override
  String msg_tasks_deleted(int count) {
    return '$count task(s) deleted';
  }

  @override
  String get error_generic => 'An error occurred';

  @override
  String get error_title_required => 'Title is required';

  @override
  String get error_invalid_date_format => 'Incomplete date (use dd/mm/yyyy)';

  @override
  String get error_invalid_date => 'Invalid date';

  @override
  String get error_date_before_today => 'Date cannot be in the past';

  @override
  String get error_invalid_time_format => 'Incomplete time (use HH:mm)';

  @override
  String get error_invalid_time => 'Invalid time';

  @override
  String get error_time_before_now => 'Time cannot be earlier than now';

  @override
  String get error_task_not_found => 'Task not found';

  @override
  String error_max_length(int max) {
    return 'Max $max characters';
  }

  @override
  String get common_save => 'Save';

  @override
  String get common_undo => 'Undo';

  @override
  String get common_cancel => 'Cancel';

  @override
  String get common_edit => 'Edit';

  @override
  String get common_delete => 'Delete';
}
