import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utilitarios/modules/imc/bloc/imc_bloc.dart';
import 'package:utilitarios/modules/imc/bloc/imc_state.dart';
import 'package:utilitarios/modules/imc/widgets/imc_form.dart';

class ImcScreen extends StatelessWidget {
  const ImcScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ImcBloc>(
      create: (context) => ImcBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Calculadora IMC'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const ImcForm(),
              // const SizedBox(height: 20),
              BlocBuilder<ImcBloc, ImcState>(
                builder: (context, state) {
                  if (state.imc != null) {
                    return Column(
                      children: [
                        Text(
                          'Seu IMC: ${state.imc!.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Categoria: ${state.categoria}',
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[600]),
                        ),
                      ],
                    );
                  } else {
                    return Text(
                      'Insira seus dados para calcular o IMC',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
