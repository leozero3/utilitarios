part of 'currency_converter_bloc.dart';

sealed class CurrencyConverterState extends Equatable {
  const CurrencyConverterState();

  @override
  List<Object> get props => [];
}

final class CurrencyConverterInitial extends CurrencyConverterState {}

class CurrencyConverterLoading extends CurrencyConverterState {}

class CurrencyConverterLoaded extends CurrencyConverterState {
  final CurrencyConverterModel currencyData;

  CurrencyConverterLoaded(this.currencyData);

  @override
  List<Object> get props => [currencyData];
}

class CurrencyConverterError extends CurrencyConverterState {
  final String error;

  CurrencyConverterError(this.error);

  @override
  List<Object> get props => [error];
}
