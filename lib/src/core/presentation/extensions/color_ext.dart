import 'package:flutter/material.dart';
import 'package:inicie_todo_test/src/core/theme/app_colors.dart';

extension ColorExtension on ThemeData {

  AppColors get colors => brightness == Brightness.light
      ? AppColorsLight()
      : AppColorsDark();
}