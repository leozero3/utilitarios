import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/routes.dart'; // Importa as rotas configuradas

class MyApp extends StatelessWidget {
  final GoRouter _router = GoRouter(
    routes: appRoutes,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      title: 'Utilidades',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
