part of 'fuel_cubit.dart';

sealed class FuelState extends Equatable {
  const FuelState();

  @override
  List<Object> get props => [];
}

final class FuelInitial extends FuelState {}

final class FuelLoaded extends FuelState {
  final double alcoholPrice;
  final double gasolinePrice;
  final double? result;

  const FuelLoaded({
    required this.alcoholPrice,
    required this.gasolinePrice,
    this.result,
  });

  // Implementação do copyWith
  FuelLoaded copyWith({
    double? alcoholPrice,
    double? gasolinePrice,
    double? result,
  }) {
    return FuelLoaded(
      alcoholPrice: alcoholPrice ?? this.alcoholPrice,
      gasolinePrice: gasolinePrice ?? this.gasolinePrice,
      result: result ?? this.result,
    );
  }

  @override
  List<Object> get props => [alcoholPrice, gasolinePrice, result ?? 0.0];
}
