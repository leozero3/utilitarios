class ImcModel {
  final int? id;
  final double peso;
  final double altura;
  DateTime? date;
  double? imc;

  ImcModel(
      {this.id, this.date, this.imc, required this.peso, required this.altura});

  double calcularImc() {
    return peso / (altura * altura);
  }

  String categoriaImc() {
    double imc = calcularImc();
    if (imc < 16) {
      return 'Magreza grave';
    } else if (imc >= 16 && imc < 17) {
      return 'Magreza moderada';
    } else if (imc >= 17 && imc < 18.5) {
      return 'Magreza leve';
    } else if (imc >= 18.5 && imc < 25) {
      return 'Peso ideal';
    } else if (imc >= 25 && imc < 30) {
      return 'Sobrepeso';
    } else if (imc >= 30 && imc < 35) {
      return 'Obesidade grau I';
    } else if (imc >= 35 && imc < 40) {
      return 'Obesidade grau II (severa)';
    } else if (imc >= 40 && imc < 56) {
      return 'Obesidade grau III (mórbida)';
    } else {
      return 'Valor inválido';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'peso': peso,
      'altura': altura,
      'imc': calcularImc(),
      'categoria': categoriaImc(),
      'date': DateTime.now().toIso8601String()
    };
  }

  factory ImcModel.fromMap(Map<String, dynamic> map) {
    return ImcModel(
      id: map['id'],
      peso: map['peso'],
      altura: map['altura'],
      imc: map['imc'],
      date: DateTime.parse(map['date']),
      // If 'date' is not provided, use current date and time
    );
  }
}
