import 'package:sqflite/sqflite.dart';
import 'package:utilitarios/modules/todo/database/todo_database.dart';
import 'package:utilitarios/modules/todo/model/todo_model.dart';
import 'package:utilitarios/modules/todo/repository/todo_repository.dart';

class ITodoRepository implements TodoRepository {
  static Database? _db;

  Future<Database> get _database async {
    if (_db != null) return _db!;
    _db = await TodoDatabase.instance.initDatabase();
    return _db!;
  }

  @override
  Future<List<TodoModel>> getAll() async {
    final db = await _database; // Aguarda a inicialização
    final result =
        await db.query('todos', where: 'completed = ?', whereArgs: [0]);
    return result.map((e) => TodoModel.fromMap(e)).toList();
  }

  @override
  Future<List<TodoModel>> getAsCompleted() async {
    final db = await _database;
    final result =
        await db.query('todos', where: 'completed = ?', whereArgs: [1]);
    return result.map((e) => TodoModel.fromMap(e)).toList();
  }

  @override
  Future<void> save(TodoModel todo) async {
    final db = await _database;
    await db.insert('todos', todo.toMap());
  }

  @override
  Future<void> update(TodoModel todo) async {
    final db = await _database;
    if (todo.id != null) {
      await db.update(
        'todos',
        todo.toMap(),
        where: 'id = ?',
        whereArgs: [todo.id],
      );
    } else {
      throw Exception("ID do Todo não pode ser nulo para atualização");
    }
  }

  @override
  Future<void> delete(int id) async {
    final db = await _database;
    await db.delete('todos', where: 'id =?', whereArgs: [id]);
  }
}
