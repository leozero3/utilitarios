import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utilitarios/modules/password_manager/cubit/password_manager_cubit.dart';

class PasswordManagerScreen extends StatelessWidget {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _passwordController = TextEditingController();

  PasswordManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gerenciador de Senhas')),
      body: BlocBuilder<PasswordManagerCubit, PasswordManagerState>(
        builder: (context, state) {
          if (state.status == PasswordManagerStatus.loading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.status == PasswordManagerStatus.loaded) {
            return ListView.builder(
              itemCount: state.passwords.length,
              itemBuilder: (context, index) {
                final password = state.passwords[index];
                return Card(
                  elevation: 3, // Adiciona uma leve sombra ao card
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Bordas arredondadas
                  ),
                  child: InkWell(
                    onLongPress: () {
                      // Ao segurar o card, abrir o diálogo para confirmação de exclusão
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: Text('Excluir Senha'),
                            content: Text(
                                'Você tem certeza que deseja excluir a senha "${password['name']}"?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Fechar o diálogo
                                },
                                child: Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Excluir a senha
                                  context
                                      .read<PasswordManagerCubit>()
                                      .deletePassword(password[
                                          'id']); // Exemplo: usando o id da senha
                                  Navigator.of(context)
                                      .pop(); // Fechar o diálogo após a exclusão
                                },
                                child: Text('Excluir',
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(password['name']),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Descrição: ${password['description']}'),
                                SizedBox(height: 10),
                                Text(
                                    'Senha: ${password['password']}'), // Senha descriptografada
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Fechar'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            password['name'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text('Descrição: ${password['description']}'),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state.status == PasswordManagerStatus.adding) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Nome'),
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Descrição'),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Senha'),
                    obscureText: true, // Para esconder a senha
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      final name = _nameController.text;
                      final description = _descriptionController.text;
                      final password = _passwordController.text;

                      if (name.isNotEmpty &&
                          description.isNotEmpty &&
                          password.isNotEmpty) {
                        context.read<PasswordManagerCubit>().addPassword(
                              name,
                              password,
                              description,
                            );

                        // Limpa os campos do formulário após salvar
                        _nameController.clear();
                        _passwordController.clear();
                        _descriptionController.clear();
                      }
                    },
                    child: Text('Salvar Senha'),
                  ),
                ],
              ),
            );
          } else if (state.status == PasswordManagerStatus.error) {
            return Center(child: Text('Erro: ${state.errorMessage}'));
          } else {
            return Center(child: Text('Nenhuma senha encontrada.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Alterna para o modo de adicionar senha
          context.read<PasswordManagerCubit>().showAddPasswordForm();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
