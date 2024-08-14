import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utilitarios/modules/imc/bloc/imc_bloc.dart';
import 'package:utilitarios/modules/imc/widgets/imc_meter.dart';

class ImcForm extends StatefulWidget {
  const ImcForm({super.key});

  @override
  _ImcFormState createState() => _ImcFormState();
}

class _ImcFormState extends State<ImcForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Column(
            children: [
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
                            context
                                .read<ImcBloc>()
                                .add(UpdatePeso(peso: value));
                          },
                        ),
                      ],
                    );
                  } else {
                    return const Text('nada');
                  }
                },
              ),
              const SizedBox(height: 20),
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
                    return const Text(
                        'nada'); // Retorna um widget vazio se não for Calculado
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Calcular IMC'),
                onPressed: () {
                  final bloc = context.read<ImcBloc>();
                  if (bloc.state is Calculado) {
                    final state = bloc.state as Calculado;

                    bloc.add(
                      CalculateImc(
                        peso: state.peso, // Use o peso
                        altura: state.altura, // Use a altura
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 50),
              BlocBuilder<ImcBloc, ImcState>(
                builder: (context, state) {
                  if (state is Calculado) {
                    if (state.imc != null) {
                      return ImcMeter(
                        imcMeterData: state.imcMeterData!,
                      );
                    } else {
                      return const SizedBox(); // Espaço vazio caso o IMC ainda não tenha sido calculado
                    }
                  } else {
                    return const SizedBox(); // Espaço vazio caso o IMC ainda não tenha sido calculado
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
