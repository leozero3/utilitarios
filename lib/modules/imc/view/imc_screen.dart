import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utilitarios/modules/imc/bloc/imc_bloc.dart';
import 'package:utilitarios/modules/imc/bloc/imc_history_bloc.dart';
import 'package:utilitarios/modules/imc/repository/imc_repository.dart';
import 'package:utilitarios/modules/imc/widgets/imc_form.dart';
import 'package:utilitarios/modules/imc/widgets/imc_historic.dart';

class ImcScreen extends StatelessWidget {
  const ImcScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ImcBloc(ImcHistoryBloc(ImcRepository()))),
        BlocProvider(create: (_) => ImcHistoryBloc(ImcRepository())),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Calculadora IMC'),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ImcForm(),
                const ImcHistoric(), // Atualizado para usar o ImcHistoryBloc
              ],
            ),
          ),
        ),
      ),
    );
  }
}
