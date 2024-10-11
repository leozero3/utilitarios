import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utilitarios/modules/currency_converter/bloc/currency_converter_bloc.dart';
import 'package:utilitarios/modules/currency_converter/model/currency_converter_model.dart';
import 'package:utilitarios/modules/currency_converter/model/currency_model.dart';
import 'package:xml/xml.dart' as xml;

class CurrencyConverter extends StatefulWidget {
  const CurrencyConverter({super.key});

  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  List<Currency> _currencies = []; // Todas as moedas
  Map<String, List<Currency>> _currencyPairs = {}; // Pares de conversão
  Currency? _selectedBaseCurrency;
  Currency? _selectedTargetCurrency;
  final TextEditingController _inputValueController = TextEditingController();
  double? _result;

  @override
  void initState() {
    super.initState();
    _loadCurrencies();
  }

  Future<void> _loadCurrencies() async {
    // Carrega todas as moedas com seus nomes
    final String xmlStringMoedas =
        await rootBundle.loadString('assets/xml/moedas.xml');
    final documentMoedas = xml.XmlDocument.parse(xmlStringMoedas);

    Map<String, String> allCurrencies = {};
    documentMoedas.findAllElements('xml').forEach((element) {
      element.children.where((node) => node is xml.XmlElement).forEach((node) {
        final code = (node as xml.XmlElement).name.toString();
        final name = node.innerText;
        allCurrencies[code] = name;
      });
    });

    // Carrega os pares de conversão
    final String xmlStringPairs =
        await rootBundle.loadString('assets/xml/moedas_comb.xml');
    final documentPairs = xml.XmlDocument.parse(xmlStringPairs);

    Map<String, List<Currency>> currencyPairs = {};

    documentPairs.findAllElements('xml').forEach((element) {
      element.children.where((node) => node is xml.XmlElement).forEach((node) {
        final pair = (node as xml.XmlElement).name.toString(); // ex: USD-BRL
        final currencies = pair.split('-'); // Divide em [USD, BRL]
        final base = currencies[0];
        final destination = currencies[1];

        final baseCurrency = Currency(code: base, name: allCurrencies[base]!);
        final destinationCurrency =
            Currency(code: destination, name: allCurrencies[destination]!);

        if (currencyPairs.containsKey(base)) {
          currencyPairs[base]!.add(destinationCurrency);
        } else {
          currencyPairs[base] = [destinationCurrency];
        }

        if (!_currencies.any((currency) => currency.code == base)) {
          _currencies.add(baseCurrency);
        }
      });
    });

    setState(() {
      _currencyPairs = currencyPairs;
      _currencies.sort(
          (a, b) => a.code.compareTo(b.code)); // Opcional: ordenar as moedas
    });
  }

  void _calculateResult(double rate) {
    final double? inputValue = double.tryParse(_inputValueController.text);
    if (inputValue != null) {
      setState(() {
        _result = inputValue * rate;
      });
    } else {
      setState(() {
        _result = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversor de Moedas'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 30),
            DropdownButton<Currency>(
              value: _selectedBaseCurrency,
              hint: const Text('Selecione uma moeda base'),
              onChanged: (Currency? newValue) {
                setState(() {
                  _selectedBaseCurrency = newValue;
                  _selectedTargetCurrency = null; // Reseta a moeda de destino
                  _inputValueController
                      .clear(); // Limpa o valor do campo de entrada
                  _result = null; // Reseta o resultado
                });
              },
              items: _currencies
                  .map<DropdownMenuItem<Currency>>((Currency currency) {
                return DropdownMenuItem<Currency>(
                  value: currency,
                  child: Text('${currency.code} - ${currency.name}'),
                );
              }).toList(),
            ),
            if (_selectedBaseCurrency != null)
              DropdownButton<Currency>(
                value: _selectedTargetCurrency,
                hint: const Text('Selecione a moeda de destino'),
                onChanged: (Currency? newValue) {
                  setState(() {
                    _selectedTargetCurrency = newValue;
                    _inputValueController
                        .clear(); // Limpa o valor do campo de entrada
                    _result = null; // Reseta o resultado
                  });
                  if (_selectedBaseCurrency != null && newValue != null) {
                    context.read<CurrencyConverterBloc>().add(
                          CurrencySelected(
                              '${_selectedBaseCurrency!.code}-${newValue.code}'),
                        );
                  }
                },
                items: _currencyPairs[_selectedBaseCurrency!.code]!
                    .map<DropdownMenuItem<Currency>>((Currency currency) {
                  return DropdownMenuItem<Currency>(
                    value: currency,
                    child: Text('${currency.code} - ${currency.name}'),
                  );
                }).toList(),
              ),
            SizedBox(height: 30),
            BlocBuilder<CurrencyConverterBloc, CurrencyConverterState>(
              builder: (context, state) {
                if (state is CurrencyConverterLoading) {
                  return const CircularProgressIndicator();
                } else if (state is CurrencyConverterLoaded) {
                  return Center(
                      child: Column(
                    children: [
                      _buildCurrencyData(state.currencyData),
                      SizedBox(height: 30),
                      Divider(),
                      SizedBox(height: 30),
                    ],
                  ));
                } else if (state is CurrencyConverterError) {
                  return Text(state.error);
                }
                return Container();
              },
            ),
            BlocBuilder<CurrencyConverterBloc, CurrencyConverterState>(
              builder: (context, state) {
                if (state is CurrencyConverterLoaded) {
                  final currencyData = state.currencyData;
                  return Column(
                    children: [
                      Text('Conversor'),
                      Text(currencyData.code),
                      SizedBox(
                        width: 200,
                        child: TextField(
                          controller: _inputValueController,
                          onChanged: (value) =>
                              _calculateResult(currencyData.bid),
                          keyboardType: TextInputType.number,
                          maxLength: 15,
                          maxLines: 1,
                          minLines: 1,
                          decoration: InputDecoration(
                              label: Text('Insira o valor'),
                              border: OutlineInputBorder()),
                        ),
                      ),
                      Text(_result == null ? '' : currencyData.codeIn),

                      const SizedBox(height: 20),

                      Text(_result == null
                          ? ''
                          : 'Resultado : ${_result?.toStringAsFixed(2)} ${currencyData.codeIn}'), // exibir valor resultado dos textfield * ou outro
                    ],
                  );
                }

                return Text('asd');
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _inputValueController.dispose();
    super.dispose();
  }

  Widget _buildCurrencyData(CurrencyConverterModel data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Moeda: ${data.code}'),
        Text('Nome: ${data.name}'),
        Text('Máximo: ${data.high.toStringAsFixed(2)}'),
        Text('Mínimo: ${data.low.toStringAsFixed(2)}'),
        Text('Variação: ${data.varBid}'),
        Text('Percentual de Variação: ${data.pctChange.toStringAsFixed(2)}%'),
        Text('Compra: ${data.bid.toStringAsFixed(2)}'),
        Text('Venda: ${data.ask.toStringAsFixed(2)}'),
        Text('Data de Criação: ${data.createDate}'),
        Text(
            '1 ${data.code} equivale a ${data.bid.toStringAsFixed(2)} ${data.codeIn}'),
      ],
    );
  }
}
