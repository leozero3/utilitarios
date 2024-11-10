// lib/models/unit_model.dart

class Unidade {
  final String nome;
  final String simbolo;
  final double fatorConversao; // Em relação à unidade base da categoria

  Unidade(this.nome, this.simbolo, this.fatorConversao);
}

class CategoriaUnidade {
  final String nome;
  final List<Unidade> unidades;

  CategoriaUnidade(this.nome, this.unidades);
}

// Definição das categorias e unidades
final List<CategoriaUnidade> categorias = [
  // Comprimento
  CategoriaUnidade('Comprimento', [
    Unidade('Milímetro', 'mm', 0.001),
    Unidade('Centímetro', 'cm', 0.01),
    Unidade('Metro', 'm', 1.0),
    Unidade('Quilômetro', 'km', 1000.0),
    Unidade('Polegada', 'in', 0.0254),
    Unidade('Pé', 'ft', 0.3048),
    Unidade('Jarda', 'yd', 0.9144),
  ]),

  // Massa
  CategoriaUnidade('Massa', [
    Unidade('Grama', 'g', 0.001),
    Unidade('Quilograma', 'kg', 1.0),
    Unidade('Tonelada', 't', 1000.0),
    Unidade('Libra', 'lb', 0.453592),
    Unidade('Onça', 'oz', 0.0283495),
  ]),

  // Tempo
  CategoriaUnidade('Tempo', [
    Unidade('Segundo', 's', 1.0),
    Unidade('Minuto', 'min', 60.0),
    Unidade('Hora', 'h', 3600.0),
    Unidade('Dia', 'd', 86400.0),
    Unidade('Ano', 'ano', 31536000.0),
  ]),

  // Temperatura (a conversão de temperatura requer fórmulas específicas, mas aqui estão os fatores aproximados para uma base de referência)
  CategoriaUnidade('Temperatura', [
    Unidade('Kelvin', 'K', 1.0),
    Unidade('Celsius', '°C', 1.0), // Converte para Kelvin: (°C + 273.15)
    Unidade('Fahrenheit', '°F',
        1.0), // Converte para Kelvin: ((°F - 32) * 5/9) + 273.15
  ]),

  // Volume
  CategoriaUnidade('Volume', [
    Unidade('Metro cúbico', 'm³', 1.0),
    Unidade('Mililitro', 'mL', 0.000001),
    Unidade('Litro', 'L', 0.001),
    Unidade('Galão', 'gal', 0.00378541),
    Unidade('Pinta', 'pt', 0.000473176),
  ]),

  // Área
  CategoriaUnidade('Área', [
    Unidade('Centímetro quadrado', 'cm²', 0.0001),
    Unidade('Metro quadrado', 'm²', 1.0),
    Unidade('Quilômetro quadrado', 'km²', 1000000.0),
  ]),

  // Pressão
  CategoriaUnidade('Pressão', [
    Unidade('Pascal', 'Pa', 1.0),
    Unidade('Atmosfera', 'atm', 101325.0),
    Unidade('Bar', 'bar', 100000.0),
    Unidade('Milímetro de mercúrio', 'mmHg', 133.322),
  ]),

  // Energia
  CategoriaUnidade('Energia', [
    Unidade('Joule', 'J', 1.0),
    Unidade('Caloria', 'cal', 4.184),
    Unidade('Quilowatt-hora', 'kWh', 3600000.0),
    Unidade('Elétron-volt', 'eV', 1.60218e-19),
  ]),
];
