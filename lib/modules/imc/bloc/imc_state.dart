import 'package:equatable/equatable.dart';

class ImcState extends Equatable {
  final double? imc;
  final String? categoria;

  const ImcState({this.imc, this.categoria});

  factory ImcState.initial() {
    return const ImcState();
  }

  //
  ImcState copyWith({double? imc, String? categoria}) {
    return ImcState(
      imc: imc ?? this.imc,
      categoria: categoria ?? this.categoria,
    );
  }

  @override
  List<Object?> get props => [imc, categoria];
}
