import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utilitarios/di/service_locator.dart';
import 'package:utilitarios/modules/imc/bloc/imc_bloc.dart';
import 'package:utilitarios/modules/imc/bloc/imc_history_bloc.dart';
import 'package:utilitarios/modules/imc/widgets/imc_meter.dart';

class ImcForm extends StatelessWidget {
  ImcForm({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ImcBloc, ImcState>(
          listener: (context, state) {
            if (state is SaveImcSuccess) {
              // Mostra mensagem de sucesso
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('IMC salvo com sucesso!')),
              );

              // Dispara o evento de carregamento do histórico
              context.read<ImcHistoryBloc>().add(LoadImcHistoryEvent());
            } else if (state is SaveImcError) {
              // Mostra mensagem de erro
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
      ],
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Peso slider
            BlocBuilder<ImcBloc, ImcState>(
              builder: (context, state) {
                if (state is Calculado) {
                  return Column(
                    children: [
                      Text('Peso: ${state.peso.toStringAsFixed(1)} kg'),
                      Slider(
                        value: state.peso,
                        min: 30.0,
                        max: 250.0,
                        divisions: 2200,
                        label: '${state.peso.toStringAsFixed(1)} kg',
                        onChanged: (value) {
                          context.read<ImcBloc>().add(UpdatePeso(peso: value));
                        },
                      ),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),

            const SizedBox(height: 20),

            // Altura slider
            BlocBuilder<ImcBloc, ImcState>(
              builder: (context, state) {
                if (state is Calculado) {
                  return Column(
                    children: [
                      Text('Altura: ${state.altura.toStringAsFixed(2)} m'),
                      Slider(
                        value: state.altura,
                        min: 1.00,
                        max: 2.50,
                        divisions: 150,
                        label: '${state.altura.toStringAsFixed(2)} m',
                        onChanged: (value) {
                          context
                              .read<ImcBloc>()
                              .add(UpdateAltura(altura: value));
                        },
                      ),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),

            const SizedBox(height: 20),

            // Botão para calcular o IMC
            ElevatedButton(
              child: const Text('Calcular IMC'),
              onPressed: () {
                final bloc = context.read<ImcBloc>();
                if (bloc.state is Calculado) {
                  final state = bloc.state as Calculado;
                  bloc.add(
                    CalculateImc(
                      peso: state.peso, // Usa o peso atual
                      altura: state.altura, // Usa a altura atual
                    ),
                  );
                }
              },
            ),

            const SizedBox(height: 50),

            // Exibir o IMC Meter se o IMC for calculado
            BlocBuilder<ImcBloc, ImcState>(
              builder: (context, state) {
                if (state is Calculado && state.imc != null) {
                  return ImcMeter(
                    imcMeterData: state.imcMeterData!,
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),

            // Exibir IMC e Categoria se o cálculo foi realizado
            BlocBuilder<ImcBloc, ImcState>(
              builder: (context, state) {
                if (state is Calculado && state.imc != null) {
                  return Column(
                    children: [
                      Text(
                        'Seu IMC: ${state.imc?.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Categoria: ${state.categoria}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      ElevatedButton(
                        child: const Text('Salvar IMC'),
                        onPressed: () {
                          context.read<ImcBloc>().add(SaveImcEvent());
                          context
                              .read<ImcHistoryBloc>()
                              .add(LoadImcHistoryEvent());
                        },
                      ),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
