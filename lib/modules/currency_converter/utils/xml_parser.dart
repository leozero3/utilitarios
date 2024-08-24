import 'package:utilitarios/modules/currency_converter/model/currency_model.dart';
import 'package:xml/xml.dart' as xml;
import 'package:flutter/services.dart' show rootBundle;

Future<List<Currency>> parseXml() async {
  final xmlString = await rootBundle.loadString('assets/xml/moedas.xml');
  final document = xml.XmlDocument.parse(xmlString);
  final currencies = <Currency>[];

  for (var element in document.findAllElements('xml')) {
    final code = element.getAttribute('code')!;
    final name = element.getAttribute('name')!;

    currencies.add(Currency(
      code: code,
      name: name,
    ));
  }

  return currencies;
}
