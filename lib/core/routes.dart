import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:utilitarios/modules/currency_converter/bloc/currency_converter_bloc.dart';
import 'package:utilitarios/modules/currency_converter/services/dio_client.dart.dart';
import 'package:utilitarios/modules/currency_converter/view/currency_converter.dart';
import 'package:utilitarios/modules/fuel/view/fuel_screen.dart';
import 'package:utilitarios/modules/weather/screen/weather_screen.dart';
import 'package:utilitarios/modules/calculadora/calculadora_screen.dart';
import 'package:utilitarios/modules/imc/view/imc_screen.dart';
import 'package:utilitarios/modules/home/home_screen.dart';

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
    builder: (context, state) => const CalculadoraScreen(),
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
];
