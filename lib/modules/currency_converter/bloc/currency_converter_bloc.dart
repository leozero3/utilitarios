import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:utilitarios/modules/currency_converter/model/currency_converter_model.dart';
import 'package:utilitarios/modules/currency_converter/services/dio_client.dart.dart';

part 'currency_converter_event.dart';
part 'currency_converter_state.dart';

class CurrencyConverterBloc
    extends Bloc<CurrencyConverterEvent, CurrencyConverterState> {
  final DioClient dioClient;

  CurrencyConverterBloc(this.dioClient) : super(CurrencyConverterInitial()) {
    on<CurrencySelected>((event, emit) async {
      emit(CurrencyConverterLoading());
      try {
        final response = await dioClient.getReq(event.currencyCode);

        // Pegue o primeiro objeto na lista para criar o modelo
        final List<dynamic> responseData = response.data;

        if (responseData.isNotEmpty) {
          final currencyData = CurrencyConverterModel.fromJson(responseData[0]);
          emit(CurrencyConverterLoaded(currencyData));
        } else {
          emit(
              CurrencyConverterError('Nenhum dado disponível para esta moeda'));
        }
      } catch (e) {
        emit(CurrencyConverterError('Erro ao carregar dados da moeda'));
      }
    });
  }
}
