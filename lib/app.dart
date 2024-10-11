import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/routes.dart'; // Importa as rotas configuradas
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
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
        brightness: Brightness.dark, // Define o tema como dark mode
        primarySwatch: Colors.blue,
      ),
    );
  }
}
