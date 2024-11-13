import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'tracking_state.dart';

class TrackingCubit extends Cubit<TrackingState> {
  TrackingCubit() : super(TrackingInitial());
}
