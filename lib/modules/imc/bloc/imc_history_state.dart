part of 'imc_history_bloc.dart';

sealed class ImcHistoryState extends Equatable {
  const ImcHistoryState();

  @override
  List<Object> get props => [];
}

final class ImcHistoryInitial extends ImcHistoryState {}

class ImcHistoryLoaded extends ImcHistoryState {
  final List<ImcModel> history;
  final bool canLoadMore;

  const ImcHistoryLoaded(this.history, {this.canLoadMore = false});

  @override
  List<Object> get props => [history];
}

class ImcHistoryError extends ImcHistoryState {
  final String message;

  const ImcHistoryError(this.message);

  @override
  List<Object> get props => [message];
}
