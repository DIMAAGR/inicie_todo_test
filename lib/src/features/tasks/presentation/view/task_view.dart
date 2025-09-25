import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inicie_todo_test/src/core/failures/failures.dart';
import 'package:inicie_todo_test/src/core/presentation/extensions/color_ext.dart';
import 'package:inicie_todo_test/src/core/presentation/masks/masks.dart';
import 'package:inicie_todo_test/src/core/presentation/validators/validators.dart';
import 'package:inicie_todo_test/src/core/state/view_model_state.dart';
import 'package:inicie_todo_test/src/core/theme/app_text_styles.dart';
import 'package:inicie_todo_test/src/features/tasks/presentation/view_model/task_view_model.dart';
import 'package:inicie_todo_test/src/features/tasks/presentation/widgets/custom_snackbars.dart';
import 'package:inicie_todo_test/src/features/tasks/presentation/widgets/task_text_form_field.dart';

final taskErrorProvider = Provider<Failure?>((ref) {
  final s = ref.watch(taskViewModelProvider);
  Failure? pickError(ViewModelState<Failure, dynamic> st) =>
      st is ErrorState<Failure, dynamic> ? st.error : null;

  return pickError(s.createTaskState) ?? pickError(s.updateTaskState) ?? pickError(s.getTaskState);
});

class TaskView extends ConsumerStatefulWidget {
  final String? id;
  const TaskView({super.key, this.id});

  @override
  ConsumerState<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends ConsumerState<TaskView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late final ProviderSubscription _removeVmSub;
  late final ProviderSubscription _removeErrSub;

  @override
  void initState() {
    super.initState();

    _removeErrSub = ref.listenManual<Failure?>(taskErrorProvider, (prev, next) {
      if (next != null && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(CustomSnackbars.error(context, next.message));
          ref.read(taskViewModelProvider.notifier).clearErrors();
        });
      }
    });

    _removeVmSub = ref.listenManual(taskViewModelProvider, (prev, next) {
      final wasCreating = prev?.createTaskState is LoadingState;
      final isCreated = next.createTaskState is SuccessState;

      final wasUpdating = prev?.updateTaskState is LoadingState;
      final isUpdated = next.updateTaskState is SuccessState;

      if (mounted && wasCreating && isCreated) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(CustomSnackbars.success(context, 'task_created_successfully'));
          if (context.mounted) context.pop(true);
        });
      }

      if (mounted && wasUpdating && isUpdated) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(CustomSnackbars.success(context, 'task_updated_successfully'));
          if (context.mounted) context.pop(true);
        });
      }
    });

    if (widget.id != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        loadEditData();
      });
    } else {
      setTextControllerListeners();
    }
  }

  void setTextControllerListeners() {
    final notifier = ref.read(taskViewModelProvider.notifier);
    _titleController.addListener(() {
      notifier.setTitle(_titleController.text);
    });
    _dateController.addListener(() {
      notifier.setDate(_dateController.text);
    });
    _timeController.addListener(() {
      notifier.setTime(_timeController.text);
    });
  }

  Future<void> loadEditData() async {
    await ref.read(taskViewModelProvider.notifier).getTask(widget.id!);
    final vm = ref.read(taskViewModelProvider);

    _titleController.text = vm.titleRaw;
    _dateController.text = vm.dateRaw;
    _timeController.text = vm.timeRaw;

    setTextControllerListeners();
  }

  @override
  void dispose() {
    _removeErrSub.close();
    _removeVmSub.close();
    _titleController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(taskViewModelProvider);
    final notifier = ref.read(taskViewModelProvider.notifier);

    if (vm.getTaskState is LoadingState) {
      return Scaffold(
        body: Center(
          child: SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(color: Theme.of(context).colors.textPrimary),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colors.selectionEffect,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),

              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  if (widget.id == null) {
                    notifier.createTask();
                  } else {
                    notifier.editTask();
                  }
                }
              },
              child: Text('save'),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.id != null ? 'edit_task' : 'create_a_new_task',
                      style: AppTextStyles.h5,
                    ),
                    SizedBox(height: 16),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TaskTextFormField(
                            controller: _titleController,
                            titleText: 'task_title',
                            hintText: 'task_title_hint',
                            validator: validateTitle,
                          ),
                          SizedBox(height: 24),
                          TaskTextFormField(
                            controller: _dateController,
                            titleText: 'optional_due_date',
                            hintText: 'DD/MM/AAAA',
                            inputMask: TextInputDateFormatter.dateMask,
                            validator: validateDate,
                          ),
                          SizedBox(height: 24),
                          TaskTextFormField(
                            controller: _timeController,
                            titleText: 'Hora (Opcional)',
                            hintText: 'HH:MM',
                            inputMask: TextInputDateFormatter.timeMask,
                            validator: (s) => validateTime(s, dateStr: _dateController.text),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
