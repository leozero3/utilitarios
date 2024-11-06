import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:utilitarios/modules/unit_converter/model/unit_converter_model.dart';

part 'unit_converter_state.dart';

class UnitConverterCubit extends Cubit<UnitConverterState> {
  UnitConverterCubit() : super(UnitConverterState.initial());

  void convertValue(double value, Unidade fromUnit, CategoriaUnidade category) {
    emit(UnitConverterState.loading());

    try {
      final baseValue = value * fromUnit.fatorConversao;
      List<Map<String, double>> results = category.unidades.map(
        (unit) {
          double convertedValue = baseValue / unit.fatorConversao;
          return {unit.simbolo: convertedValue};
        },
      ).toList();
      emit(UnitConverterState.converted(results));
    } catch (e) {
      emit(UnitConverterState.error(errorMessage: 'Erro na Conversão'));
    }
  }
}
