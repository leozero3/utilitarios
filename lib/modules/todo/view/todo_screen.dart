import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utilitarios/modules/todo/cubit/todo_cubit.dart';

import 'package:utilitarios/modules/todo/model/todo_model.dart';
import 'package:utilitarios/modules/todo/view/add_todo_screen.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _carregarTarefas();
  }

  void _carregarTarefas() {
    context.read<TodoCubit>().loadTodo(
          onlyComplete: _selectedIndex == 1,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            _selectedIndex == 0 ? 'Todas as Tarefas' : 'Tarefas Concluídas'),
      ),
      body: BlocConsumer<TodoCubit, TodoState>(
        listener: (context, state) {
          if (state.status == TodoStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('${state.errorMessage} erro' ?? 'Ocorreu um erro'),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == TodoStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == TodoStatus.completed) {
            final tarefas = state.todo;
            if (tarefas.isEmpty) {
              return const Center(
                child: Text('Nenhuma tarefa encontrada'),
              );
            }

            return ListView.builder(
              itemCount: tarefas.length,
              itemBuilder: (context, index) {
                final tarefa = tarefas[index];
                return Dismissible(
                  key: Key(tarefa.id.toString()),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    if (tarefa.id != null) {
                      context.read<TodoCubit>().deleteTodo(tarefa.id!);
                    }
                  },
                  child: ListTile(
                    title: Text(
                      tarefa.title,
                      style: TextStyle(
                        decoration: tarefa.completed
                            ? TextDecoration.lineThrough
                            : null,
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
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                      value: context.read<TodoCubit>(),
                      child: NovaTarefaPage(),
                    )),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _carregarTarefas();
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Todas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done_all),
            label: 'Concluídas',
          ),
        ],
      ),
    );
  }
}
