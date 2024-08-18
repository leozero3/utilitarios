part of 'imc_bloc.dart';

abstract class ImcState extends Equatable {
  const ImcState();

  @override
  List<Object?> get props => [];
}

class Initial extends ImcState {
  final double? imc = 0.0;
  final String? categoria = '';
  final ImcMeterData? imcMeterData;
  final double peso = 0.0;
  final double altura = 0.0;

  const Initial({
    this.imcMeterData,
  });
}

class Calculado extends ImcState {
  final double? imc;
  final String? categoria;
  final ImcMeterData? imcMeterData;
  final double peso;
  final double altura;
  const Calculado({
    required this.peso,
    required this.altura,
    this.imc,
    this.categoria,
    this.imcMeterData,
  });

  @override
  List<Object?> get props => [
        imc,
        categoria,
        imcMeterData,
        peso,
        altura,
      ];
}

class SaveImcSuccess extends ImcState {
  @override
  List<Object?> get props => [];
}

class SaveImcError extends ImcState {
  final String message;

  SaveImcError(this.message);

  @override
  List<Object?> get props => [message];
}
