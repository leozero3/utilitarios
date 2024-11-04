import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:utilitarios/core/constants/app_icons.dart';
import 'package:utilitarios/modules/password_manager/passwords/cubit/password_manager_cubit.dart';

class PasswordManagerScreen extends StatelessWidget {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Key para o formulário

  PasswordManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciador de Senhas'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navega diretamente para a HomeScreen
          },
        ),
      ),
      body: Stack(
        children: [
          BlocBuilder<PasswordManagerCubit, PasswordManagerState>(
            builder: (context, state) {
              if (state.status == PasswordManagerStatus.loading) {
                return Center(child: CircularProgressIndicator());
              } else if (state.status == PasswordManagerStatus.loaded) {
                if (state.passwords.isEmpty) {
                  return empty(context);
                }
                return loaded(state);
              } else if (state.status == PasswordManagerStatus.adding) {
                return adding(context);
              } else if (state.status == PasswordManagerStatus.error) {
                return Center(child: Text('Erro: ${state.errorMessage}'));
              } else {
                return Center(
                  child: Image.asset(
                    'assets/password_manager/password.svg',
                    fit: BoxFit.cover,
                  ),
                );
              }
            },
          ),
          if (context.watch<PasswordManagerCubit>().state.status ==
                  PasswordManagerStatus.loaded &&
              context.watch<PasswordManagerCubit>().state.passwords.isNotEmpty)
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

  Padding adding(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SvgPicture.asset(AppIcons.padlock,
                  width: MediaQuery.of(context).size.width / 2),
              TextFormField(
                controller: _nameController,
                maxLength: 50,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
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
                    context.read<PasswordManagerCubit>().addPassword(
                          _nameController.text,
                          _passwordController.text,
                          _descriptionController.text,
                        );
                    _nameController.clear();
                    _passwordController.clear();
                    _descriptionController.clear();
                  }
                },
                child: Text('Salvar Senha'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<PasswordManagerCubit>().loadPassword();
                },
                child: Text('Voltar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListView loaded(PasswordManagerState state) {
    return ListView.builder(
      itemCount: state.passwords.length + 1,
      itemBuilder: (context, index) {
        if (index == state.passwords.length) {
          return SizedBox(height: 70); // Espaço para o botão
        }

        final password = state.passwords[index];
        return Card(
          elevation: 3,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
  }

  SingleChildScrollView empty(BuildContext context) {
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () {
          context.read<PasswordManagerCubit>().showAddPasswordForm();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(AppIcons.padlock,
                width: MediaQuery.of(context).size.width), // Imagem compacta
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Você ainda não possui senhas cadastradas. Clique em "Adicionar Senha" para adicionar.',
                style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 128, 126, 126)),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> dialog(
      BuildContext context, Map<String, dynamic> password) async {
    final decryptedPassword = await context
        .read<PasswordManagerCubit>()
        .getDecryptedPassword(password['id']);
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(password['name']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(),
              Text(
                'Descrição: ${password['description']}',
                style: TextStyle(fontSize: 17),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Clipboard.setData(
                      ClipboardData(text: password['description']));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Descrição copiada!')),
                  );
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.copy,
                      color: Colors.blue,
                    ),
                    Text(
                      'Copiar Descrição',
                      style: TextStyle(color: Colors.blue, fontSize: 13),
                    ),
                  ],
                ),
              ),
              //------------------------------------------------------------------------------------------------
              SizedBox(height: 10),
              Divider(),
              Text('Senha:',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text(
                decryptedPassword,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.blue,
                ),
              ),

              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: decryptedPassword));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Senha copiada!')),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Row(
                    children: [
                      Icon(Icons.copy, color: Colors.blue),
                      Text('Copiar senha',
                          style: TextStyle(color: Colors.blue, fontSize: 13))
                    ],
                  ),
                ),
              ),
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
