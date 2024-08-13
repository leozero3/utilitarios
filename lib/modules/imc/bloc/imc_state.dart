part of 'imc_bloc.dart';

abstract class ImcState extends Equatable {
  const ImcState();
  // final double? imc;
  // final String? categoria;
  // final ImcMeterData? imcMeterData;

  // const ImcState({
  //   this.imc,
  //   this.categoria,
  //   this.imcMeterData,
  // });

  @override
  List<Object?> get props => [];
}

class Initial extends ImcState {}

class Calculado extends ImcState {
  final double? imc;
  String? categoria;
  ImcMeterData? imcMeterData;
  Calculado({
    this.imc,
    this.categoria,
    this.imcMeterData,
  });

  @override
  List<Object?> get props => [imc, categoria, imcMeterData];
}
