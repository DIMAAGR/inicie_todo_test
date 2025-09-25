import 'dart:ui';

sealed class AppColors {
  final Color primary;
  final Color textPrimary;
  final Color textSecondary;
  final Color textLight;
  
  final Color background;

  final Color error;
  final Color warning;
  final Color success;

  final Color tapEffect;
  final Color selectionEffect;

  const AppColors( {
    required this.primary,
    required this.textPrimary,
    required this.textSecondary,
    required this.textLight,
    required this.background,
    required this.error,
    required this.warning,
    required this.success,
    required this.tapEffect,
    required this.selectionEffect,

  });
}

class AppColorsLight extends AppColors {
  const AppColorsLight()
      : super(
          primary: const Color(0xFF4F4F4F),
          textPrimary: const Color(0xFF4F4F4F),
          textSecondary: const Color(0xFF9F9F9F),
          textLight: const Color(0xFFFFFFFF),
          background: const Color(0xFFFFFFFF),
          error: const Color(0xFFFF3245),
          warning: const Color(0xFFFBAB49),
          success: const Color(0xFF7BCD3C),
          tapEffect: const Color(0xFFF5F7FC),
          selectionEffect: const Color(0xFF2F417D),
        );
}

class AppColorsDark extends AppColors {
  const AppColorsDark()
      : super(
          primary: const Color(0xFFFFFFFF),
          textPrimary: const Color(0xFFFFFFFF),
          textSecondary: const Color(0xFFBDBDBD),
          textLight: const Color(0xFF121212),
          background: const Color(0xFF121212),
          error: const Color(0xFFFF6B81),
          warning: const Color(0xFFFFC85C),
          success: const Color(0xFF7BCD3C),
          tapEffect: const Color(0xFF2A2A2A),
          selectionEffect: const Color(0xFF627DFF),
        );
}