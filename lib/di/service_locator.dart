import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:utilitarios/modules/currency_converter/services/dio_client.dart.dart';

final getIt = GetIt.instance;

void setup() {
  // // Registre o repositório
  getIt.registerSingleton<DioClient>(DioClient(Dio()));

  // // Registre o bloco de histórico
  // getIt.registerLazySingleton<ImcHistoryBloc>(
  //     () => ImcHistoryBloc(getIt<ImcRepository>()));

  // // Registre o bloco de IMC com o bloco de histórico injetado
  // getIt.registerLazySingleton<ImcBloc>(
  //   () => ImcBloc(getIt<ImcHistoryBloc>()),
  // );
}
