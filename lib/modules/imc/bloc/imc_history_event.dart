part of 'imc_history_bloc.dart';

sealed class ImcHistoryEvent extends Equatable {
  const ImcHistoryEvent();

  @override
  List<Object> get props => [];
}

class LoadImcHistoryEvent extends ImcHistoryEvent {}

class LoadMoreImcHistoryEvent extends ImcHistoryEvent {}

class HideImcHistoryEvent extends ImcHistoryEvent {}

class AddImcToHistory extends ImcHistoryEvent {
  final ImcModel imcModel;

  const AddImcToHistory(this.imcModel);

  @override
  List<Object> get props => [imcModel];
}

class DeleteImcHistoryEvent extends ImcHistoryEvent {
  final int id;
  DeleteImcHistoryEvent(this.id);

  @override
  List<Object> get props => [id];
}
