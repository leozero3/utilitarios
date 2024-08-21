part of 'currency_converter_bloc.dart';

sealed class CurrencyConverterState extends Equatable {
  const CurrencyConverterState();
  
  @override
  List<Object> get props => [];
}

final class CurrencyConverterInitial extends CurrencyConverterState {}
