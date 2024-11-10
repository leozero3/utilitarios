// lib/pages/nova_tarefa/nova_tarefa_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utilitarios/modules/todo/cubit/todo_cubit.dart';
import 'package:utilitarios/modules/todo/model/todo_model.dart';

class NovaTarefaPage extends StatefulWidget {
  const NovaTarefaPage({Key? key}) : super(key: key);

  @override
  _NovaTarefaPageState createState() => _NovaTarefaPageState();
}

class _NovaTarefaPageState extends State<NovaTarefaPage> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  int _prioridade = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _prioridade,
                decoration: const InputDecoration(
                  labelText: 'Prioridade',
                ),
                items: [1, 2, 3, 4, 5]
                    .map((priority) => DropdownMenuItem(
                          value: priority,
                          child: Text(priority.toString()),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _prioridade = value ?? 1;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final novaTarefa = TodoModel(
                      title: _tituloController.text,
                      description: _descricaoController.text,
                      priority: _prioridade,
                      completed: false,
                      createdAt: DateTime.now(),
                    );
                    context.read<TodoCubit>().addTodo(novaTarefa);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
