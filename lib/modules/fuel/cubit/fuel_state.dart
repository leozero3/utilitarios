part of 'fuel_cubit.dart';

sealed class FuelState extends Equatable {
  const FuelState();

  @override
  List<Object> get props => [];
}

class FuelLoaded extends FuelState {
  final double alcoholPrice;
  final double gasolinePrice;
  final double? result;
  final bool? isAlcoholBetter;
  final bool isCalculationDone;

  const FuelLoaded({
    required this.alcoholPrice,
    required this.gasolinePrice,
    this.result,
    this.isAlcoholBetter,
    this.isCalculationDone = false,
  });

  FuelLoaded copyWith({
    double? alcoholPrice,
    double? gasolinePrice,
    double? result,
    bool? isAlcoholBetter,
    bool? isCalculationDone,
  }) {
    return FuelLoaded(
      alcoholPrice: alcoholPrice ?? this.alcoholPrice,
      gasolinePrice: gasolinePrice ?? this.gasolinePrice,
      result: result ?? this.result,
      isAlcoholBetter: isAlcoholBetter ?? this.isAlcoholBetter,
      isCalculationDone: isCalculationDone ?? this.isCalculationDone,
    );
  }

  @override
  List<Object> get props => [
        alcoholPrice,
        gasolinePrice,
        result ?? 0.0,
        isAlcoholBetter ?? false,
        isCalculationDone,
      ];
}
