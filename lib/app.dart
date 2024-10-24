import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:utilitarios/core/ui/app_theme.dart';
import 'core/routes/routes.dart'; // Importa as rotas configuradas
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  final GoRouter _router = GoRouter(
    routes: appRoutes,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: const Locale('pt', 'BR'),
        supportedLocales: const [
          Locale('pt', 'BR'),
        ],
        routerConfig: _router,
        title: 'Utilidades',
        theme: AppTheme.darkTheme);
  }
}
