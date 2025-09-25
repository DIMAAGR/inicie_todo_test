import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inicie_todo_test/src/core/presentation/extensions/color_ext.dart';
import 'package:inicie_todo_test/src/core/theme/app_text_styles.dart';

class TaskTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? titleText;
  final TextInputType? keyboardType;
  final TextInputFormatter? inputMask;

  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final void Function(String?)? onSaved;
  final String? initialValue;

  const TaskTextFormField({
    super.key,
    this.controller,
    this.hintText,
    this.titleText,
    this.keyboardType,
    this.inputMask,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onSaved,
    this.initialValue,
  });

  @override
  State<TaskTextFormField> createState() => _TaskTextFormFieldState();
}

class _TaskTextFormFieldState extends State<TaskTextFormField> {
  late final bool _ownsController;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;

    return FormField<String>(
      validator: widget.validator,
      initialValue: _controller.text,
      onSaved: widget.onSaved,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (state) {
        void syncToForm(String v) {
          if (state.value != v) state.didChange(v);
          widget.onChanged?.call(v);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if ((widget.titleText ?? '').isNotEmpty)
              Text(widget.titleText!, style: AppTextStyles.button),
            if ((widget.titleText ?? '').isNotEmpty) const SizedBox(height: 4),

            Focus(
              child: TextField(
                controller: _controller,
                keyboardType: widget.keyboardType,
                inputFormatters: widget.inputMask != null ? [widget.inputMask!] : null,
                onChanged: syncToForm,
                onSubmitted: (v) {
                  widget.onFieldSubmitted?.call(v);
                  state.validate();
                },
                style: AppTextStyles.button,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

                  enabledBorder: state.hasError
                      ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: colors.error, width: 1.5),
                        )
                      : OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: colors.textPrimary, width: 1.5),
                        ),
                  focusedBorder: state.hasError
                      ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: colors.error, width: 2.2),
                        )
                      : OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: colors.selectionEffect, width: 2),
                        ),

                  errorText: null,
                  errorStyle: const TextStyle(height: 0, fontSize: 0),
                ),
              ),
            ),

            if (state.hasError) ...[
              const SizedBox(height: 4),
              Text(
                state.errorText!,
                style: AppTextStyles.caption.copyWith(color: Theme.of(context).colors.error),
                textAlign: TextAlign.start,
              ),
            ],
          ],
        );
      },
    );
  }
}
