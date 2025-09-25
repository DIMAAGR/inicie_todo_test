// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get app_title => 'Inicie To-do';

  @override
  String get home_welcome => 'Bienvenido a\nInicie To-do!';

  @override
  String get home_tab_all => 'Todas las tareas';

  @override
  String get home_tab_pending => 'Pendientes';

  @override
  String get home_tab_completed => 'Completadas';

  @override
  String get home_empty => 'No se encontraron tareas';

  @override
  String home_selected_count(int count) {
    return '$count seleccionada(s)';
  }

  @override
  String get home_cancel_selection => 'Cancelar selección';

  @override
  String get home_menu_edit => 'Editar';

  @override
  String get home_menu_delete => 'Eliminar';

  @override
  String get task_new_title => 'Crear nueva tarea';

  @override
  String get task_edit_title => 'Editar tarea';

  @override
  String get task_field_title => 'Título';

  @override
  String get task_field_title_hint => 'Ingrese el título';

  @override
  String get task_field_date => 'Fecha (Opcional)';

  @override
  String get task_field_time => 'Hora (Opcional)';

  @override
  String get task_button_save => 'Guardar';

  @override
  String get task_no_due_date => 'Sin fecha límite';

  @override
  String get msg_task_created => 'Tarea creada con éxito';

  @override
  String get msg_task_updated => 'Tarea actualizada con éxito';

  @override
  String msg_tasks_deleted(int count) {
    return '$count tarea(s) eliminada(s)';
  }

  @override
  String get error_generic => 'Ocurrió un error';

  @override
  String get error_title_required => 'El título es obligatorio';

  @override
  String get error_invalid_date_format => 'Fecha incompleta (use dd/mm/aaaa)';

  @override
  String get error_invalid_date => 'Fecha inválida';

  @override
  String get error_date_before_today => 'La fecha no puede ser anterior a hoy';

  @override
  String get error_invalid_time_format => 'Hora incompleta (use HH:mm)';

  @override
  String get error_invalid_time => 'Hora inválida';

  @override
  String get error_time_before_now =>
      'La hora no puede ser anterior a la actual';

  @override
  String get error_task_not_found => 'Tarea no encontrada';

  @override
  String error_max_length(int max) {
    return 'Máximo $max caracteres';
  }

  @override
  String get common_save => 'Guardar';

  @override
  String get common_undo => 'Deshacer';

  @override
  String get common_cancel => 'Cancelar';

  @override
  String get common_edit => 'Editar';

  @override
  String get common_delete => 'Eliminar';

  @override
  String date_today(String time) {
    return 'Hoy a las $time';
  }

  @override
  String date_yesterday(String time) {
    return 'Ayer a las $time';
  }

  @override
  String date_tomorrow(String time) {
    return 'Mañana a las $time';
  }

  @override
  String date_default(String date, String time) {
    return '$date a las $time';
  }
}
