import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'fuel_state.dart';

class FuelCubit extends Cubit<FuelState> {
  FuelCubit() : super(const FuelLoaded(alcoholPrice: 3.0, gasolinePrice: 6.0));

  void updatePrices(double alcoholPrice, double gasolinePrice) {
    if (state is FuelLoaded) {
      final updatedState = (state as FuelLoaded).copyWith(
        alcoholPrice: alcoholPrice,
        gasolinePrice: gasolinePrice,
        isCalculationDone: false, // Indica que o cálculo não foi feito ainda
      );
      emit(updatedState);
    }
  }

  void calculateFuelAdvantage() {
    if (state is FuelLoaded) {
      final currentState = state as FuelLoaded;
      final ratio = currentState.alcoholPrice / currentState.gasolinePrice;
      final isAlcoholBetter = ratio <= 0.7;

      emit(currentState.copyWith(
          result: ratio,
          isAlcoholBetter: isAlcoholBetter,
          isCalculationDone: true));
    }
  }
}
