import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'fuel_state.dart';

class FuelCubit extends Cubit<FuelState> {
  FuelCubit() : super(FuelInitial());

  void updateAlcoolPrice(double price) {
    emit(state.c());
  }
}
