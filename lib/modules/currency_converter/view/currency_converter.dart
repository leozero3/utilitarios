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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversor de Moedas'),
      ),
      body: Center(
        child: Column(
          children: [
            DropdownButton<Currency>(
              value: _selectedBaseCurrency,
              hint: const Text('Selecione uma moeda base'),
              onChanged: (Currency? newValue) {
                setState(() {
                  _selectedBaseCurrency = newValue;
                  _selectedTargetCurrency = null; // Reseta a moeda de destino
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
            BlocBuilder<CurrencyConverterBloc, CurrencyConverterState>(
              builder: (context, state) {
                if (state is CurrencyConverterLoading) {
                  return const CircularProgressIndicator();
                } else if (state is CurrencyConverterLoaded) {
                  return _buildCurrencyData(state.currencyData);
                } else if (state is CurrencyConverterError) {
                  return Text(state.error);
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyData(CurrencyConverterModel data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Moeda: ${data.code}'),
        Text('Nome: ${data.name}'),
        Text('Máximo: ${data.high}'),
        Text('Mínimo: ${data.low}'),
        Text('Variação: ${data.varBid}'),
        Text('Percentual de Variação: ${data.pctChange}%'),
        Text('Compra: ${data.bid}'),
        Text('Venda: ${data.ask}'),
        Text('Data de Criação: ${data.createDate}'),
        Text('1 ${data.code} equivale a ${data.bid} ${data.codeIn}'),
      ],
    );
  }
}
