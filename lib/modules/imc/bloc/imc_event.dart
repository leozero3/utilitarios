part of 'imc_bloc.dart';

abstract class ImcEvent extends Equatable {
  const ImcEvent();

  @override
  List<Object> get props => [];
}

class CalculateImc extends ImcEvent {
  final double peso;
  final double altura;

  const CalculateImc({required this.peso, required this.altura});

  @override
  List<Object> get props => [peso, altura];
}

class UpdatePeso extends ImcEvent {
  final double peso;

  const UpdatePeso({required this.peso});

  @override
  List<Object> get props => [peso];
}

class UpdateAltura extends ImcEvent {
  final double altura;

  const UpdateAltura({required this.altura});

  @override
  List<Object> get props => [altura];
}

class SaveImcEvent extends ImcEvent {}
