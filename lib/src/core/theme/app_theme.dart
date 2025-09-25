import 'package:flutter/material.dart';
import 'package:inicie_todo_test/src/core/theme/app_colors.dart';
import 'package:inicie_todo_test/src/core/theme/app_text_styles.dart';

abstract class AppTheme {
  static ThemeData light() {
    final colors = AppColorsLight();
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: colors.background,
      primaryColor: colors.primary,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          textStyle: AppTextStyles.button,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
    );
  }
}
