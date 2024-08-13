import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utilitarios/modules/imc/bloc/imc_bloc.dart';
import 'package:utilitarios/modules/imc/widgets/imc_meter.dart';

class ImcForm extends StatefulWidget {
  const ImcForm({Key? key}) : super(key: key);

  @override
  _ImcFormState createState() => _ImcFormState();
}

class _ImcFormState extends State<ImcForm> {
  final _formKey = GlobalKey<FormState>();
  final _pesoController = TextEditingController();
  final _alturaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _pesoController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Peso (kg)',
              prefixIcon: Icon(Icons.line_weight),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira o peso';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _alturaController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Altura (m)',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira a altura';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            child: const Text('Calcular IMC'),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                BlocProvider.of<ImcBloc>(context).add(
                  CalculateImc(
                    peso: double.parse(_pesoController.text),
                    altura: double.parse(_alturaController.text),
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
    );
  }

  @override
  void dispose() {
    _pesoController.dispose();
    _alturaController.dispose();
    super.dispose();
  }
}
