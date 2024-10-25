import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utilitarios/modules/password_manager/cubit/password_manager_cubit.dart';

class PasswordManagerScreen extends StatelessWidget {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Key para o formulário

  PasswordManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gerenciador de Senhas')),
      body: Stack(
        children: [
          BlocBuilder<PasswordManagerCubit, PasswordManagerState>(
            builder: (context, state) {
              if (state.status == PasswordManagerStatus.loading) {
                return Center(child: CircularProgressIndicator());
              } else if (state.status == PasswordManagerStatus.loaded) {
                return ListView.builder(
                  itemCount: state.passwords.length + 1,
                  itemBuilder: (context, index) {
                    if (index == state.passwords.length) {
                      return SizedBox(height: 70);
                    }

                    final password = state.passwords[index];
                    return Card(
                      elevation: 3,
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        onTap: () {
                          dialog(context, password);
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
                  child: Form(
                    key: _formKey, // Atribui o GlobalKey ao Form
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            maxLength: 50,
                            decoration: InputDecoration(
                              labelText: 'Nome',
                              border: OutlineInputBorder(),
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(256),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'O campo Nome é obrigatório';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _descriptionController,
                            maxLength: 50,
                            decoration: InputDecoration(
                              labelText: 'Descrição',
                              border: OutlineInputBorder(),
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(256),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'O campo Descrição é obrigatório';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            maxLength: 256,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Senha',
                              border: OutlineInputBorder(),
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(256),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'O campo Senha é obrigatório';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final name = _nameController.text;
                                final description = _descriptionController.text;
                                final password = _passwordController.text;

                                if (name.isNotEmpty &&
                                    description.isNotEmpty &&
                                    password.isNotEmpty) {
                                  context
                                      .read<PasswordManagerCubit>()
                                      .addPassword(
                                        name,
                                        password,
                                        description,
                                      );

                                  _nameController.clear();
                                  _passwordController.clear();
                                  _descriptionController.clear();
                                }
                              }
                            },
                            child: Text('Salvar Senha'),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                              child: Text('Voltar'),
                              onPressed: () {
                                context
                                    .read<PasswordManagerCubit>()
                                    .loadPassword();
                              }),
                        ],
                      ),
                    ),
                  ),
                );
              } else if (state.status == PasswordManagerStatus.error) {
                return Center(child: Text('Erro: ${state.errorMessage}'));
              } else {
                return Center(child: Text('Nenhuma senha encontrada.'));
              }
            },
          ),
          if (context.watch<PasswordManagerCubit>().state.status ==
              PasswordManagerStatus.loaded)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: () {
                  context.read<PasswordManagerCubit>().showAddPasswordForm();
                },
                child: Text('Adicionar Senha'),
              ),
            ),
        ],
      ),
    );
  }

  Future<dynamic> dialog(BuildContext context, Map<String, dynamic> password) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(password['name']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Descrição: ${password['description']}'),
              SizedBox(height: 10),
              Text('Senha: ${password['password']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            context
                                .read<PasswordManagerCubit>()
                                .deletePassword(password['id']);
                            Navigator.of(context).pop();
                          },
                          child: Text('Excluir',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Deletar', style: TextStyle(color: Colors.red)),
            ),
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
  }
}
