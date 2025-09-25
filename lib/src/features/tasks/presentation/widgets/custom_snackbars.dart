import 'package:flutter/material.dart';
import 'package:inicie_todo_test/src/core/presentation/extensions/color_ext.dart';
import 'package:inicie_todo_test/src/core/theme/app_text_styles.dart';

abstract class CustomSnackbars {
  static SnackBar error(BuildContext context, String message) {
    return SnackBar(
      content: Row(
        children: [
          Icon(Icons.error, color: Theme.of(context).colors.textLight),
          SizedBox(width: 8),
          Text(
            message,
            style: AppTextStyles.body1Regular.copyWith(color: Theme.of(context).colors.textLight),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colors.error,
    );
  }

  static SnackBar success(BuildContext context, String message) {
    return SnackBar(
      content: Row(
        children: [
          Icon(Icons.check_circle, color: Theme.of(context).colors.textLight),
          SizedBox(width: 8),
          Text(
            message,
            style: AppTextStyles.body1Regular.copyWith(color: Theme.of(context).colors.textLight),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colors.success,
    );
  }
}
