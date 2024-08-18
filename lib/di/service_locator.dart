import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setup() {
  // // Registre o repositório
  // getIt.registerLazySingleton<ImcRepository>(() => ImcRepository());

  // // Registre o bloco de histórico
  // getIt.registerLazySingleton<ImcHistoryBloc>(
  //     () => ImcHistoryBloc(getIt<ImcRepository>()));

  // // Registre o bloco de IMC com o bloco de histórico injetado
  // getIt.registerLazySingleton<ImcBloc>(
  //   () => ImcBloc(getIt<ImcHistoryBloc>()),
  // );
}
