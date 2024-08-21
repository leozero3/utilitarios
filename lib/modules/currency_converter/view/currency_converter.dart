import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:utilitarios/modules/currency_converter/model/currency_model.dart';
import 'package:xml/xml.dart' as xml;

class CurrencyConverter extends StatefulWidget {
  const CurrencyConverter({super.key});

  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  List<Currency> _currencies = [];
  List<String> _currencyNames = [];
  Currency? _selectedCurrency;

  @override
  void initState() {
    super.initState();
    _loadCurrencies();
  }

  Future<void> _loadCurrencies() async {
    // Carrega o conteúdo do arquivo XML
    final String xmlString =
        await rootBundle.loadString('assets/xml/moedas.xml');

    // Parse o XML
    final document = xml.XmlDocument.parse(xmlString);

    // Extraia os códigos e nomes das moedas
    final currencies = document.findAllElements('xml').expand((element) {
      return element.children
          .where((node) => node is xml.XmlElement)
          .map((node) {
        final code = (node as xml.XmlElement).name.toString(); // Sigla da moeda
        final name = node.text; // Nome da moeda
        return Currency(code: code, name: name);
      });
    }).toList();

    // Adicione os nomes das moedas em uma lista separada se precisar de strings
    _currencyNames = currencies.map((currency) => currency.name).toList();

    setState(() {
      _currencies = currencies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversor de Moedas'),
      ),
      body: Column(
        children: [
          DropdownButton<Currency>(
            value: _selectedCurrency,
            hint: const Text('Selecione uma moeda'),
            elevation: 24,
            focusColor: Colors.red,
            dropdownColor: const Color.fromARGB(255, 220, 224, 226),
            borderRadius: BorderRadius.circular(10),
            menuMaxHeight: MediaQuery.of(context).size.height * .8,
            onChanged: (Currency? newValue) {
              setState(() {
                _selectedCurrency = newValue;
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
        ],
      ),
    );
  }
}
