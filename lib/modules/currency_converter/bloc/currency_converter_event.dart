part of 'currency_converter_bloc.dart';

sealed class CurrencyConverterEvent extends Equatable {
  const CurrencyConverterEvent();

  @override
  List<Object> get props => [];
}

class CurrencySelected extends CurrencyConverterEvent {
  final String currencyCode;

  CurrencySelected(this.currencyCode);

  @override
  List<Object> get props => [currencyCode];
}

class CurrencyLoadSuccess extends CurrencyConverterEvent {
  final CurrencyConverterModel currencyData;

  CurrencyLoadSuccess(this.currencyData);

  @override
  List<Object> get props => [currencyData];
}

class CurrencyLoadFailure extends CurrencyConverterEvent {
  final String error;
  CurrencyLoadFailure(this.error);
  @override
  List<Object> get props => [error];
}
