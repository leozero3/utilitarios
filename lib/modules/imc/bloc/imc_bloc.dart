import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:utilitarios/modules/imc/models/imc_model.dart';
import 'package:utilitarios/modules/imc/widgets/imc_meter.dart';

part 'imc_event.dart';
part 'imc_state.dart';

class ImcBloc extends Bloc<ImcEvent, ImcState> {
  ImcBloc() : super(Initial()) {
    on<CalculateImc>(
      (event, emit) {
        //
        print(event);
        print(emit);

        final imcModel = ImcModel(peso: event.peso, altura: event.altura);
        final imc = imcModel.calcularImc();
        final imcMeterData = _calculateImcMeterData(imc);
        emit(Calculado(
          imc: imcModel
              .calcularImc(), // Calcula o IMC com base no peso e altura.
          categoria: imcModel.categoriaImc(),
          imcMeterData: imcMeterData,
        ));
//
      },
    );
  }

  ImcMeterData _calculateImcMeterData(double imc) {
    const sectionCount = 8;
    final imcRanges = [
      [0, 15.99], // Magreza grave
      [16, 16.99], // Magreza moderada
      [17, 18.49], // Magreza leve
      [18.5, 24.99], // Peso ideal
      [25, 29.99], // Sobrepeso
      [30, 34.99], // Obesidade grau I
      [35, 39.99], // Obesidade grau
      [40, 56], // Obesidade grau III
    ];

    final colors = [
      Colors.blue,
      Colors.blue[600]!,
      Colors.blue[800]!,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.red,
      Colors.red[900]!,
    ];

    double normalizedImc = 0;
    for (int i = 0; i < imcRanges.length; i++) {
      if (imc >= imcRanges[i][0] && imc < imcRanges[i][1]) {
        normalizedImc =
            (imc - imcRanges[i][0]) / (imcRanges[i][1] - imcRanges[i][0]);
        normalizedImc = (i + normalizedImc) / sectionCount;
        break;
      }
    }

    final pointerAngle = pi + normalizedImc * pi;

    return ImcMeterData(pointerAngle: pointerAngle, sectionColors: colors);
  }
}
