import 'package:utilitarios/modules/todo/model/todo_model.dart';

abstract class TodoRepository {
  Future<List<TodoModel>> getAll();
  Future<List<TodoModel>> getAsCompleted();
  // Future<TodoModel> getById(int id);
  Future<void> save(TodoModel todo);
  Future<void> update(TodoModel todo);
  Future<void> delete(int id);
}
