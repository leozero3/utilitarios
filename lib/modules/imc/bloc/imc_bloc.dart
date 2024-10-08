import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:utilitarios/modules/imc/bloc/imc_history_bloc.dart';
import 'package:utilitarios/modules/imc/models/imc_model.dart';
import 'package:utilitarios/modules/imc/repository/imc_repository.dart';
import 'package:utilitarios/modules/imc/widgets/imc_meter.dart';

part 'imc_event.dart';
part 'imc_state.dart';

class ImcBloc extends Bloc<ImcEvent, ImcState> {
  final ImcRepository _repository = ImcRepository();
  final ImcHistoryBloc _historyBloc;

  ImcBloc(this._historyBloc) : super(const Calculado(peso: 70, altura: 1.75)) {
    // Calcula o IMC
    on<CalculateImc>((event, emit) {
      final imcModel = ImcModel(peso: event.peso, altura: event.altura);
      final imc = imcModel.calcularImc();
      final imcMeterData = _calculateImcMeterData(imc);
      emit(Calculado(
        peso: event.peso,
        altura: event.altura,
        imc: imc,
        categoria: imcModel.categoriaImc(),
        imcMeterData: imcMeterData,
      ));
    });

    // Atualiza o peso
    on<UpdatePeso>((event, emit) {
      final calculadoState = state as Calculado;
      emit(Calculado(
        peso: event.peso,
        altura: calculadoState.altura,
        imc: calculadoState.imc,
        categoria: calculadoState.categoria,
        imcMeterData: calculadoState.imcMeterData,
      ));
    });

    // Atualiza a altura
    on<UpdateAltura>((event, emit) {
      final calculadoState = state as Calculado;
      emit(Calculado(
        peso: calculadoState.peso,
        altura: event.altura,
        imc: calculadoState.imc,
        categoria: calculadoState.categoria,
        imcMeterData: calculadoState.imcMeterData,
      ));
    });

    // Salva o IMC e atualiza o histórico
    on<SaveImcEvent>((event, emit) async {
      if (state is Calculado) {
        final calculadoState = state as Calculado;
        final imcModel = ImcModel(
          peso: calculadoState.peso,
          altura: calculadoState.altura,
        );

        // Salva o IMC no repositório
        await _repository.saveImc(imcModel);

        // Atualiza o histórico de IMC através do ImcHistoryBloc
        _historyBloc.add(AddImcToHistory(imcModel));

        // Reemite o estado atual para manter a UI
        emit(Calculado(
          peso: calculadoState.peso,
          altura: calculadoState.altura,
          imc: calculadoState.imc,
          categoria: calculadoState.categoria,
          imcMeterData: calculadoState.imcMeterData,
        ));
      }
    });
  }

  // Calcula os dados para o ImcMeter
  ImcMeterData _calculateImcMeterData(double imc) {
    const sectionCount = 8;
    final imcRanges = [
      [0, 15.99], // Magreza grave
      [16, 16.99], // Magreza moderada
      [17, 18.49], // Magreza leve
      [18.5, 24.99], // Peso ideal
      [25, 29.99], // Sobrepeso
      [30, 34.99], // Obesidade grau I
      [35, 39.99], // Obesidade grau II
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
