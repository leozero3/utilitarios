class CurrencyConverterModel {
  final String code; // Código da moeda
  final String codeIn; // Código da moeda de conversão
  final String name; // Nome completo da conversão
  final double high; // Valor máximo
  final double low; // Valor mínimo
  final double varBid; // Variação do bid
  final double pctChange; // Percentual de variação
  final double bid; // Valor de compra
  final double ask; // Valor de venda
  final DateTime createDate; // Data de criação

  CurrencyConverterModel({
    required this.code,
    required this.codeIn,
    required this.name,
    required this.high,
    required this.low,
    required this.varBid,
    required this.pctChange,
    required this.bid,
    required this.ask,
    required this.createDate,
  });

  // Método para converter JSON em um objeto CurrencyRate
  factory CurrencyConverterModel.fromJson(Map<String, dynamic> json) {
    return CurrencyConverterModel(
      code: json['code'],
      codeIn: json['codein'],
      name: json['name'],
      high: double.parse(json['high']),
      low: double.parse(json['low']),
      varBid: double.parse(json['varBid']),
      pctChange: double.parse(json['pctChange']),
      bid: double.parse(json['bid']),
      ask: double.parse(json['ask']),
      createDate: DateTime.parse(json['create_date']),
    );
  }
}
