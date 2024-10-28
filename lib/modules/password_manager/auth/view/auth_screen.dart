import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:utilitarios/modules/password_manager/auth/cubit/auth_cubit.dart';

class AuthScreen extends StatelessWidget {
  // final TextEditingController _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Autenticação')),
      body: BlocConsumer<AuthCubit, bool>(
        listener: (context, authenticated) {
          if (authenticated) {
            // Navegue para a tela de gerenciamento de senhas
            context.go('/gerenciador-senhas');
          } else {
            // Exiba uma mensagem de erro
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Autenticação falhou!')),
            );
          }
        },
        builder: (context, authenticated) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (authenticated)
                  CircularProgressIndicator()
                else ...[
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Chame authenticate para usar biometria
                        context.read<AuthCubit>().authenticate();
                      },
                      child: Text('Autenticar com Biometria'),
                    ),
                  ),
                  // SizedBox(height: 20),
                  // TextField(
                  //   controller: _pinController,
                  //   decoration: InputDecoration(labelText: 'Digite seu PIN'),
                  //   keyboardType: TextInputType.number,
                  //   obscureText: true, // Para ocultar a entrada do PIN
                  // ),
                  // SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // Verifique o PIN usando authenticateWithPin
                  //     context
                  //         .read<AuthCubit>()
                  //         .authenticateWithPin(_pinController.text);
                  //   },
                  //   child: Text('Autenticar com PIN'),
                  // ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
