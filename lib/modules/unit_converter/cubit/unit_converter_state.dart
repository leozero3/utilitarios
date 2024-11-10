part of 'unit_converter_cubit.dart';

//enum
enum UnitConverterStatus { initial, loading, converted, error }

class UnitConverterState extends Equatable {
  final UnitConverterStatus status;
  final List<Map<String, double>>? convertedValues;
  final String? errorMessage;

  const UnitConverterState(
      {required this.status, this.convertedValues, this.errorMessage});

  factory UnitConverterState.initial() {
    return UnitConverterState(status: UnitConverterStatus.initial);
  }

  factory UnitConverterState.loading() {
    return UnitConverterState(status: UnitConverterStatus.loading);
  }

  factory UnitConverterState.converted(List<Map<String, double>> values) {
    return UnitConverterState(
        status: UnitConverterStatus.converted, convertedValues: values);
  }

  factory UnitConverterState.error({required String errorMessage}) {
    return UnitConverterState(
        status: UnitConverterStatus.error, errorMessage: errorMessage);
  }
  @override
  List<Object?> get props => [status, convertedValues, errorMessage];
}
