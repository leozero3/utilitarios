import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:utilitarios/di/service_locator.dart';
import 'package:utilitarios/modules/currency_converter/bloc/currency_converter_bloc.dart';
import 'package:utilitarios/modules/currency_converter/services/dio_client.dart.dart';
import 'package:utilitarios/modules/currency_converter/view/currency_converter.dart';
import 'package:utilitarios/modules/fuel/view/fuel_screen.dart';
import 'package:utilitarios/modules/password_manager/auth/cubit/auth_cubit.dart';
import 'package:utilitarios/modules/password_manager/auth/view/auth_screen.dart';
import 'package:utilitarios/modules/password_manager/passwords/cubit/password_manager_cubit.dart';
import 'package:utilitarios/modules/password_manager/passwords/view/password_manager_screen.dart';
import 'package:utilitarios/modules/water_reminder/cubit/water_reminder_cubit.dart';
import 'package:utilitarios/modules/water_reminder/repository/water_reminder_repository.dart';
import 'package:utilitarios/modules/water_reminder/services/notification_service.dart';
import 'package:utilitarios/modules/water_reminder/view/water_reminder_screen.dart';
import 'package:utilitarios/modules/weather/view/weather_screen.dart';
import 'package:utilitarios/modules/calculadora/calculadora_screen.dart';
import 'package:utilitarios/modules/imc/view/imc_screen.dart';
import 'package:utilitarios/modules/home/home_screen.dart';
import 'package:get_it/get_it.dart';

final List<GoRoute> appRoutes = [
  GoRoute(
    path: '/',
    builder: (context, state) => HomeScreen(),
  ),
  GoRoute(
    path: '/tempo',
    builder: (context, state) => const WeatherScreen(),
  ),
  GoRoute(
    path: '/calculadora',
    builder: (context, state) => CalculadoraScreen(),
  ),
  GoRoute(
    path: '/calculadora-imc',
    builder: (context, state) => const ImcScreen(),
  ),
  GoRoute(
    path: '/combustivel',
    builder: (context, state) => const FuelScreen(),
  ),
  GoRoute(
    path: '/conversor-moedas',
    builder: (context, state) {
      final dio = Dio();
      return BlocProvider(
        create: (_) => CurrencyConverterBloc(DioClient(dio)),
        child: const CurrencyConverter(),
      );
    },
  ),
  GoRoute(
    path: '/lembrete-agua',
    builder: (context, state) {
      return BlocProvider(
        create: (context) => WaterReminderCubit(
          GetIt.I<WaterReminderRepository>(),
          GetIt.I<NotificationService>(),
          // GetIt.I<AlarmService>(),
        ),
        child: WaterReminderScreen(),
      );
    },
  ),
  GoRoute(
    path: '/auth-senhas',
    builder: (context, state) {
      return BlocProvider<AuthCubit>(
        create: (context) => AuthCubit(LocalAuthentication()),
        child: AuthScreen(),
      );

      // return AuthScreen();
    },
  ),
  GoRoute(
    path: '/gerenciador-senhas',
    builder: (context, state) {
      return BlocProvider(
        create: (context) => getIt<PasswordManagerCubit>()..loadPassword(),
        child: PasswordManagerScreen(),
      );
    },
  ),
];
