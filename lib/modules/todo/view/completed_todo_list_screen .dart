import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utilitarios/modules/todo/cubit/todo_cubit.dart';
import 'package:utilitarios/modules/todo/model/todo_model.dart';

class CompletedTodoListScreen extends StatelessWidget {
  const CompletedTodoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Carrega apenas tarefas concluídas ao abrir a tela
    context.read<TodoCubit>().loadTodo(onlyComplete: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas Concluídas'),
      ),
      body: BlocConsumer<TodoCubit, TodoState>(
        listener: (context, state) {
          if (state.status == TodoStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.errorMessage} erro'),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == TodoStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == TodoStatus.completed) {
            final concluidas = state.todo.where((t) => t.completed).toList();
            if (concluidas.isEmpty) {
              return const Center(
                child: Text('Nenhuma tarefa concluída'),
              );
            }

            return ListView.builder(
              itemCount: concluidas.length,
              itemBuilder: (context, index) {
                final tarefa = concluidas[index];
                return _buildTodoItem(context, tarefa);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildTodoItem(BuildContext context, TodoModel tarefa) {
    return ListTile(
      title: Text(
        tarefa.title,
        style: TextStyle(
          decoration: tarefa.completed ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(tarefa.description),
      leading: CircleAvatar(
        child: Text(tarefa.priority.toString()),
      ),
      trailing: Checkbox(
        value: tarefa.completed,
        onChanged: (_) {
          context.read<TodoCubit>().updateStatusTodo(tarefa);
        },
      ),
    );
  }
}
