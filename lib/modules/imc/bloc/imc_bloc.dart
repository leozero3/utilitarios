import 'package:bloc/bloc.dart';
import 'package:utilitarios/modules/imc/bloc/imc_event.dart';
import 'package:utilitarios/modules/imc/bloc/imc_state.dart';
import 'package:utilitarios/modules/imc/models/imc_model.dart';

class ImcBloc extends Bloc<ImcEvent, ImcState> {
  ImcBloc() : super(ImcState.initial()) {
    on<CalculateImc>(
      (event, emit) {
        //
        print(event);
        print(emit);

        final imcModel = ImcModel(peso: event.peso, altura: event.altura);
//
        emit(
          state.copyWith(
            imc: imcModel
                .calcularImc(), // Calcula o IMC com base no peso e altura.
            categoria: imcModel.categoriaImc(),
          ),
        );
//
      },
    );
  }

  // @override
  // Stream<ImcState> mapEventToState(ImcEvent event) async* {
  //   if (event is CalculateImc) {
  //     final imcModel = ImcModel(peso: event.peso, altura: event.altura);

  //     yield state.copyWith(
  //       imc: imcModel.calcularImc(),
  //       categoria: imcModel.categoriaImc(),
  //     );
  //   }
  // }
}
