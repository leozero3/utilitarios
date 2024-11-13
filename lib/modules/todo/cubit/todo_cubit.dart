import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:utilitarios/modules/todo/model/todo_model.dart';
import 'package:utilitarios/modules/todo/repository/i_todo_repository.dart';
import 'package:utilitarios/modules/todo/repository/todo_repository.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  final TodoRepository _repository;
  bool _isFilteringCompleted = false; // Controle de filtro atual

  TodoCubit()
      : _repository = ITodoRepository(),
        super(TodoState.initial());

  Future<void> loadTodo({bool onlyComplete = false}) async {
    try {
      _isFilteringCompleted = onlyComplete;
      emit(TodoState.loading());
      final todo = onlyComplete
          ? await _repository.getAsCompleted()
          : await _repository.getAll();
      emit(TodoState.completed(todo: todo));
      log('loadTodo');
    } catch (e) {
      emit(TodoState.error(message: e.toString()));
      log('Erro ao carregar');
    }
  }

  void addTodo(TodoModel todoModel) async {
    try {
      await _repository.save(todoModel);
      await loadTodo(
          onlyComplete:
              _isFilteringCompleted); // Carrega conforme o filtro atual
    } on Exception catch (e) {
      emit(TodoState.error(message: e.toString()));
      log('Erro ao salvar');
    }
  }

  void updateStatusTodo(TodoModel todoModel) async {
    try {
      todoModel.completed = !todoModel.completed;
      await _repository.update(todoModel);
      await loadTodo(
          onlyComplete:
              _isFilteringCompleted); // Carrega conforme o filtro atual
    } catch (e) {
      emit(TodoState.error(message: e.toString()));
      log('Erro ao atualizar');
    }
  }

  void deleteTodo(int id) async {
    try {
      await _repository.delete(id);
      await loadTodo(
          onlyComplete:
              _isFilteringCompleted); // Carrega conforme o filtro atual
    } catch (e) {
      emit(TodoState.error(message: e.toString()));
      log('Erro ao deletar');
    }
  }
}
