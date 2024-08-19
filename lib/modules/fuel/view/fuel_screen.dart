import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utilitarios/modules/fuel/cubit/fuel_cubit.dart';

class FuelScreen extends StatelessWidget {
  const FuelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FuelCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Calculadora de Combustível'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<FuelCubit, FuelState>(
                builder: (context, state) {
                  if (state is FuelLoaded) {
                    return Column(
                      children: [
                        // Slider para o preço do álcool
                        Text(
                          'Preço do Álcool',
                          style: TextStyle(fontSize: 22),
                        ),
                        Text(
                          'R\$${state.alcoholPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Slider(
                          value: state.alcoholPrice,
                          min: 2.0,
                          max: 6.0,
                          divisions: 400,
                          label: state.alcoholPrice.toStringAsFixed(2),
                          onChanged: (value) {
                            context.read<FuelCubit>().updatePrices(
                                  value,
                                  state.gasolinePrice,
                                );
                          },
                        ),

                        // Slider para o preço da gasolina
                        Text(
                          'Preço da Gasolina',
                          style: TextStyle(fontSize: 22),
                        ),
                        Text(
                          'R\$${state.gasolinePrice.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Slider(
                          value: state.gasolinePrice,
                          min: 4.0,
                          max: 10.0,
                          divisions: 600,
                          label: state.gasolinePrice.toStringAsFixed(2),
                          onChanged: (value) {
                            context.read<FuelCubit>().updatePrices(
                                  state.alcoholPrice,
                                  value,
                                );
                          },
                        ),

                        const SizedBox(height: 20),

                        // Botão de calcular
                        ElevatedButton(
                          onPressed: () {
                            context.read<FuelCubit>().calculateFuelAdvantage();
                          },
                          child: const Text('Calcular'),
                        ),

                        const SizedBox(height: 20),

                        // Exibir o resultado
                        state.isCalculationDone
                            ? (state.isAlcoholBetter == true
                                ? Column(
                                    children: [
                                      Text(
                                        'Etanol é mais vantajoso',
                                        style: const TextStyle(fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        '${state.result!.toStringAsFixed(2)}% do valor da Gasolina',
                                        style: const TextStyle(fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      Text(
                                        'Gasolina é mais vantajosa',
                                        style: const TextStyle(fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        '${state.result!.toStringAsFixed(2)}% do valor do Etanol',
                                        style: const TextStyle(fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ))
                            : Text(
                                'Insira os valores e calcule.',
                                style: const TextStyle(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                      ],
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
