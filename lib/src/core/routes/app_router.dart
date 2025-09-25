import 'package:go_router/go_router.dart';
import 'package:inicie_todo_test/src/core/routes/app_routes.dart';
import 'package:inicie_todo_test/src/features/home/presentation/view/home_view.dart';

GoRouter buildRouter() {
  return GoRouter(
    
    routes: [
      GoRoute(path: AppRoutes.home, builder: (context, state) => const HomeView()),
    ],
  );
}