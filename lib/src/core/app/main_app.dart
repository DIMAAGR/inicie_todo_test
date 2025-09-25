import 'package:flutter/material.dart';
import 'package:inicie_todo_test/src/core/l10n/app_localizations.dart';
import 'package:inicie_todo_test/src/core/routes/app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:inicie_todo_test/src/core/theme/app_theme.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: buildRouter(),
      title: 'Inicie Todo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt'), Locale('en'), Locale('es')],
    );
  }
}
