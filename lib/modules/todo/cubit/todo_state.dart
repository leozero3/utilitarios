part of 'todo_cubit.dart';

enum TodoStatus { initial, loading, completed, error }

class TodoState extends Equatable {
  final TodoStatus status;
  final List<TodoModel> todo;
  final String? errorMessage;

  const TodoState({
    required this.status,
    this.todo = const [], // Inicializa com uma lista vazia
    this.errorMessage,
  });

  factory TodoState.initial() {
    return const TodoState(status: TodoStatus.initial);
  }

  factory TodoState.loading() {
    return const TodoState(status: TodoStatus.loading);
  }

  factory TodoState.completed({required List<TodoModel> todo}) {
    return TodoState(
      status: TodoStatus.completed,
      todo: todo, // Armazena a lista de tarefas no estado
    );
  }

  factory TodoState.error({required String message}) {
    return TodoState(
      status: TodoStatus.error,
      errorMessage: message,
    );
  }

  @override
  List<Object?> get props => [
        status,
        todo,
        errorMessage,
      ];
}
