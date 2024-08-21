import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'currency_converter_event.dart';
part 'currency_converter_state.dart';

class CurrencyConverterBloc extends Bloc<CurrencyConverterEvent, CurrencyConverterState> {
  CurrencyConverterBloc() : super(CurrencyConverterInitial()) {
    on<CurrencyConverterEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
