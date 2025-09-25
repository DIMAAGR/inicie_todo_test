import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inicie_todo_test/src/core/routes/app_routes.dart';
import 'package:inicie_todo_test/src/features/home/presentation/view/home_view.dart';
import 'package:inicie_todo_test/src/features/tasks/presentation/view/task_view.dart';

GoRouter buildRouter() {
  return GoRouter(
    routes: [
      GoRoute(name: AppRoutes.home, path: '/', builder: (context, state) => const HomeView()),
      GoRoute(
        name: AppRoutes.newTask,
        path: '/tasks/new',
        pageBuilder: (context, state) => _slideUpPage(key: state.pageKey, child: const TaskView()),
      ),

      GoRoute(
        name: AppRoutes.editTask,
        path: '/tasks/:id/edit',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'];
          return _slideUpPage(
            key: state.pageKey,
            child: TaskView(id: id),
          );
        },
      ),
    ],
  );
}

CustomTransitionPage _slideUpPage({required LocalKey key, required Widget child}) {
  return CustomTransitionPage(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    barrierDismissible: false,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final begin = const Offset(0, 1);
      final end = Offset.zero;
      final curve = Curves.easeOutCubic;

      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      final opacity = CurvedAnimation(parent: animation, curve: Curves.easeOut);

      return FadeTransition(
        opacity: opacity,
        child: SlideTransition(position: animation.drive(tween), child: child),
      );
    },
  );
}
