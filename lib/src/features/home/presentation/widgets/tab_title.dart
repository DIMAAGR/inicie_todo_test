import 'package:flutter/material.dart';
import 'package:inicie_todo_test/src/core/presentation/extensions/color_ext.dart';

import 'dart:ui' show lerpDouble;

class AnimatedTabLabel extends StatelessWidget {
  final TabController controller;
  final int index;
  final String title;
  const AnimatedTabLabel({
    super.key,
    required this.controller,
    required this.index,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;

    return AnimatedBuilder(
      animation: controller.animation!,
      builder: (context, _) {
        final v = controller.animation!.value;
        final t = (1.0 - (v - index).abs()).clamp(0.0, 1.0);

        final fontSize = lerpDouble(13, 20, t)!;
        final color = Color.lerp(colors.textSecondary, colors.textPrimary, t)!;
        final weight = FontWeight.lerp(FontWeight.w500, FontWeight.w700, t)!;
        final scale = lerpDouble(0.96, 1.0, t)!;

        return Transform.scale(
          alignment: Alignment.centerLeft,
          scale: scale,
          child: Text(
            title,
            softWrap: false,
            overflow: TextOverflow.fade,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: fontSize,
              fontWeight: weight,
              color: color,
            ),
          ),
        );
      },
    );
  }
}
