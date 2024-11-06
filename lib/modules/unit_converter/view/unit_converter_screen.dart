// lib/screens/unit_converter_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utilitarios/modules/unit_converter/model/unit_converter_model.dart';
import '../cubit/unit_converter_cubit.dart';

class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  _UnitConverterScreenState createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  final TextEditingController _valueController = TextEditingController();
  CategoriaUnidade? selectedCategory;
  Unidade? selectedUnit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Conversor de Unidades")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input para valor a ser convertido
            TextField(
              controller: _valueController,
              decoration: InputDecoration(
                labelText: 'Valor para converter',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),

            // Dropdown para selecionar a categoria
            DropdownButton<CategoriaUnidade>(
              hint: Text("Selecione a Categoria"),
              value: selectedCategory,
              items: categorias.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category.nome),
                );
              }).toList(),
              onChanged: (CategoriaUnidade? newCategory) {
                setState(() {
                  selectedCategory = newCategory;
                  selectedUnit =
                      null; // Resetar a unidade ao trocar de categoria
                });
              },
            ),
            SizedBox(height: 16.0),

            // Dropdown para selecionar a unidade
            if (selectedCategory != null)
              DropdownButton<Unidade>(
                hint: Text("Selecione a Unidade"),
                value: selectedUnit,
                items: selectedCategory!.unidades.map((unit) {
                  return DropdownMenuItem(
                    value: unit,
                    child: Text(unit.nome),
                  );
                }).toList(),
                onChanged: (Unidade? newUnit) {
                  setState(() {
                    selectedUnit = newUnit;
                  });
                },
              ),
            SizedBox(height: 16.0),

            // Botão para realizar a conversão
            ElevatedButton(
              onPressed: () {
                if (_valueController.text.isNotEmpty && selectedUnit != null) {
                  double value = double.parse(_valueController.text);
                  context
                      .read<UnitConverterCubit>()
                      .convertValue(value, selectedUnit!, selectedCategory!);
                }
              },
              child: Text("Converter"),
            ),
            SizedBox(height: 16.0),

            // Exibir os resultados das conversões
            BlocBuilder<UnitConverterCubit, UnitConverterState>(
              builder: (context, state) {
                if (state.status == UnitConverterStatus.loading) {
                  return CircularProgressIndicator();
                } else if (state.status == UnitConverterStatus.converted) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.convertedValues?.length ?? 0,
                      itemBuilder: (context, index) {
                        final conversion = state.convertedValues![index];
                        final unit = conversion.keys.first;
                        final value = conversion[unit];
                        return ListTile(
                          title: Text('$value $unit'),
                        );
                      },
                    ),
                  );
                } else if (state.status == UnitConverterStatus.error) {
                  return Text(
                    state.errorMessage ?? 'Erro ao converter',
                    style: TextStyle(color: Colors.red),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
