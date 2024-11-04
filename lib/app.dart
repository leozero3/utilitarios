import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sqflite/sqflite.dart';
import 'package:utilitarios/core/ui/app_theme.dart';
import 'package:utilitarios/modules/currency_converter/view/currency_converter.dart';
import 'package:utilitarios/modules/fuel/view/fuel_screen.dart';
import 'package:utilitarios/modules/home/home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:utilitarios/modules/imc/view/imc_screen.dart';
import 'package:utilitarios/modules/password_manager/auth/cubit/auth_cubit.dart';
import 'package:utilitarios/modules/password_manager/auth/view/auth_screen.dart';
import 'package:utilitarios/modules/password_manager/passwords/cubit/password_manager_cubit.dart';
import 'package:utilitarios/modules/password_manager/passwords/view/password_manager_screen.dart';
import 'package:utilitarios/modules/water_reminder/cubit/water_reminder_cubit.dart';
import 'package:utilitarios/modules/water_reminder/repository/impl_water_reminder_repository.dart';
import 'package:utilitarios/modules/water_reminder/repository/water_reminder_repository.dart';
import 'package:utilitarios/modules/water_reminder/services/database_water_reminder.dart';
import 'package:utilitarios/modules/water_reminder/services/notification_service.dart';
import 'package:utilitarios/modules/water_reminder/view/water_reminder_screen.dart';
import 'package:utilitarios/modules/weather/view/weather_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterGetIt(
      modulesRouter: [
        FlutterGetItModuleRouter(
          name: '/',
          pages: [
            FlutterGetItPageRouter(
              name: '/',
              builder: (context) => HomeScreen(),
            ),
            // Página Tempo
            FlutterGetItPageRouter(
              name: '/tempo',
              builder: (context) => WeatherScreen(),
            ),
            // Página Calculadora de IMC
            FlutterGetItPageRouter(
              name: '/calculadora-imc',
              builder: (context) => ImcScreen(),
            ),
            // Página Alcool ou Gasolina
            FlutterGetItPageRouter(
              name: '/combustivel',
              builder: (context) => FuelScreen(),
            ),
            // Página Conversor de Moedas
            FlutterGetItPageRouter(
              name: '/conversor-moedas',
              builder: (context) => CurrencyConverter(),
            ),
            // Página Lembrete de Beber Água

            // Página Gerenciador de Senhas

            // Página Calculadora
            FlutterGetItPageRouter(
              name: '/calculadora',
              // builder: (context) => CalculatorScreen(),
            ),
            // Página Lista de Tarefas
            FlutterGetItPageRouter(
              name: '/lista-tarefas',
              // builder: (context) => TaskListScreen(),
            ),
            // Página Controle de Despesas
            FlutterGetItPageRouter(
              name: '/controle-despesas',
              // builder: (context) => ExpenseTrackerScreen(),
            ),
            // Página Conversor de Unidades
            FlutterGetItPageRouter(
              name: '/conversor-unidades',
              // builder: (context) => UnitConverterScreen(),
            ),
            // Página Cronômetro e Temporizador
            FlutterGetItPageRouter(
              name: '/cronometro-temporizador',
              // builder: (context) => TimerScreen(),
            ),
            // Página Calculadora de Empréstimos
            FlutterGetItPageRouter(
              name: '/calculadora-emprestimos',
              // builder: (context) => LoanCalculatorScreen(),
            ),
          ],
        ),
        FlutterGetItModuleRouter(name: '/', pages: [
          FlutterGetItPageRouter(
            name: '/auth-senhas',
            builder: (context) {
              return BlocProvider(
                // create: (context) => PasswordManagerCubit()..loadPassword(),
                // child: PasswordManagerScreen(),
                create: (context) => AuthCubit(LocalAuthentication()),
                child: AuthScreen(),
              );
            },
            bindings: [
              Bind.lazySingleton<PasswordManagerCubit>(
                (i) {
                  log('registerLazySingleton<PasswordManagerCubit>');
                  return PasswordManagerCubit();
                },
              )
            ],
          ),
          FlutterGetItPageRouter(
            name: '/gerenciador-senhas',
            builder: (context) {
              return BlocProvider(
                create: (context) => PasswordManagerCubit()..loadPassword(),
                child: PasswordManagerScreen(),
              );
            },
            bindings: [
              Bind.lazySingleton<PasswordManagerCubit>(
                (i) {
                  log('registerLazySingleton<PasswordManagerCubit>');
                  return PasswordManagerCubit();
                },
              )
            ],
          ),
        ]),
        FlutterGetItModuleRouter(name: '/', pages: [
          FlutterGetItPageRouter(
              name: '/lembrete-agua',
              bindings: [
                // Bind.singletonAsync<Database>(
                //   (i) async {
                //     print('Iniciando banco de dados...');
                //     final db = await DatabaseService.;
                //     print('Banco de dados inicializado.');
                //     return db;
                //   },
                // ),

                Bind.singleton<WaterReminderRepository>(
                  (i) => ImplWaterReminderRepository(),
                  // dependsOn: [Database],
                ),
                Bind.lazySingleton<NotificationService>(
                  (i) => NotificationService(
                      Injector.get<FlutterLocalNotificationsPlugin>()),
                ),
                Bind.singleton<FlutterLocalNotificationsPlugin>(
                  (i) => FlutterLocalNotificationsPlugin(),
                ),
                // Bind.singletonAsync<Database>(
                //   (i) async {
                //     print('>>>>>>>>>>>Inicializando banco de dados...');
                //     final db = await DatabaseService.initDatabase();
                //     print(
                //         '>>>>>>>>>>>Banco de dados inicializado com sucesso.');
                //     print('>>>>>>>>>>>Inicializando $db');

                //     return db;
                //   },
                // ),
                // Bind.singleton<WaterReminderRepository>(
                //     (i) =>
                //         ImplWaterReminderRepository(Injector.get<Database>()),
                //     dependsOn: [Database]),
                // Bind.lazySingleton<NotificationService>((i) =>
                //     NotificationService(
                //         Injector.get<FlutterLocalNotificationsPlugin>()))
              ],
              builder: (context) {
                return BlocProvider(
                  create: (context) => WaterReminderCubit(
                    Injector.get<WaterReminderRepository>(),
                    Injector.get<NotificationService>(),
                  ),
                  child: WaterReminderScreen(),
                );
              }),
        ]),
      ],
      builder: (context, routes, isReady) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: const Locale('pt', 'BR'),
          supportedLocales: const [Locale('pt', 'BR')],
          title: 'Utilidades',
          initialRoute: '/',
          routes: routes, // Rotas geradas pelo FlutterGetIt
          theme: AppTheme.darkTheme,
        );
      },
    );
  }
}
