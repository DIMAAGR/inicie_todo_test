// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get app_title => 'Inicie To-do';

  @override
  String get home_welcome => 'Bem Vindo ao\nInicie To-do!';

  @override
  String get home_tab_all => 'Todas as Tarefas';

  @override
  String get home_tab_pending => 'Pendentes';

  @override
  String get home_tab_completed => 'Concluídas';

  @override
  String get home_empty => 'Nenhuma tarefa encontrada';

  @override
  String home_selected_count(int count) {
    return '$count selecionada(s)';
  }

  @override
  String get home_cancel_selection => 'Cancelar seleção';

  @override
  String get home_menu_edit => 'Editar';

  @override
  String get home_menu_delete => 'Apagar';

  @override
  String get task_new_title => 'Criar nova tarefa';

  @override
  String get task_edit_title => 'Editar tarefa';

  @override
  String get task_field_title => 'Título';

  @override
  String get task_field_title_hint => 'Digite o título';

  @override
  String get task_field_date => 'Data (Opcional)';

  @override
  String get task_field_time => 'Hora (Opcional)';

  @override
  String get task_button_save => 'Salvar';

  @override
  String get task_no_due_date => 'Nenhuma data definida';

  @override
  String get msg_task_created => 'Tarefa criada com sucesso';

  @override
  String get msg_task_updated => 'Tarefa atualizada com sucesso';

  @override
  String msg_tasks_deleted(int count) {
    return '$count tarefa(s) excluída(s)';
  }

  @override
  String get error_generic => 'Ocorreu um erro';

  @override
  String get error_title_required => 'Título é obrigatório';

  @override
  String get error_invalid_date_format => 'Data incompleta (use dd/mm/aaaa)';

  @override
  String get error_invalid_date => 'Data inválida';

  @override
  String get error_date_before_today => 'A data não pode ser anterior a hoje';

  @override
  String get error_invalid_time_format => 'Hora incompleta (use HH:mm)';

  @override
  String get error_invalid_time => 'Hora inválida';

  @override
  String get error_time_before_now =>
      'O horário não pode ser anterior ao atual';

  @override
  String get error_task_not_found => 'Tarefa não encontrada';

  @override
  String error_max_length(int max) {
    return 'Máx $max caracteres';
  }

  @override
  String get common_save => 'Salvar';

  @override
  String get common_undo => 'Desfazer';

  @override
  String get common_cancel => 'Cancelar';

  @override
  String get common_edit => 'Editar';

  @override
  String get common_delete => 'Apagar';
}
