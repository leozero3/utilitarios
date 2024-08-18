import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:utilitarios/modules/imc/models/imc_model.dart';
import 'package:utilitarios/modules/imc/repository/imc_repository.dart';

part 'imc_history_event.dart';
part 'imc_history_state.dart';

class ImcHistoryBloc extends Bloc<ImcHistoryEvent, ImcHistoryState> {
  final ImcRepository _repository;
  int _currentPage = 0;
  final int _pageSize = 5;

  ImcHistoryBloc(this._repository) : super(ImcHistoryInitial()) {
    on<LoadImcHistoryEvent>((event, emit) async {
      try {
        // Obtenha os IMCs da página atual
        _currentPage = 0;
        final history = await _repository.getImcHistory(limit: _pageSize);
        emit(ImcHistoryLoaded(history,
            canLoadMore: history.length == _pageSize));
      } catch (e) {
        emit(const ImcHistoryError("Falha ao carregar o historico"));
      }
    });

    on<LoadMoreImcHistoryEvent>((event, emit) async {
      if (state is ImcHistoryLoaded) {
        final currentState = state as ImcHistoryLoaded;
        try {
          final history = await _repository.getImcHistory(
              limit: _pageSize, offset: (_currentPage + 1) * _pageSize);
          _currentPage++;
          final updatedHistory = List<ImcModel>.from(currentState.history)
            ..addAll(history);

          emit(ImcHistoryLoaded(updatedHistory,
              canLoadMore: history.length == _pageSize));
        } catch (e) {
          emit(const ImcHistoryError("Falha ao carregar mais histórico"));
        }
      }
    });

    on<DeleteImcHistoryEvent>((event, emit) async {
      if (state is ImcHistoryLoaded) {
        final currentState = state as ImcHistoryLoaded;
        try {
          await _repository.deleteImc(event.id);
          final updatedHistory =
              currentState.history.where((imc) => imc.id != event.id).toList();

          emit(ImcHistoryLoaded(updatedHistory,
              canLoadMore: updatedHistory.length >= _pageSize));
        } catch (e) {
          emit(const ImcHistoryError("Falha ao excluir o IMC"));
        }
      }
    });

    on<HideImcHistoryEvent>((event, emit) {
      emit(ImcHistoryInitial());
    });

    on<AddImcToHistory>((event, emit) async {
      try {
        // Obtenha o histórico atual
        List<ImcModel> currentHistory = [];
        if (state is ImcHistoryLoaded) {
          currentHistory = (state as ImcHistoryLoaded).history;
        }

        // Adiciona o novo IMC ao histórico
        final updatedHistory = List<ImcModel>.from(currentHistory)
          ..add(event.imcModel);

        // Salva o novo IMC no repositório
        await _repository.saveImc(event.imcModel);

        // Emite o novo estado com o histórico atualizado diretamente
        emit(ImcHistoryLoaded(updatedHistory));
      } catch (e) {
        emit(const ImcHistoryError("Falha ao adicionar o IMC ao histórico"));
      }
    });
  }
}
