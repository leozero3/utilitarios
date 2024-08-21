import 'package:go_router/go_router.dart';
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
    builder: (context, state) => CurrencyConverter(),
  ),
];
