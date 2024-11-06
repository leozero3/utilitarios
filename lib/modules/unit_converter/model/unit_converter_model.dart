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
  CategoriaUnidade('Comprimento', [
    Unidade('Metro', 'm', 1.0),
    Unidade('Centímetro', 'cm', 0.01),
    Unidade('Quilômetro', 'km', 1000.0),
    Unidade('Milímetro', 'mm', 0.001),
    Unidade('Polegada', 'in', 0.0254),
    Unidade('Pé', 'ft', 0.3048),
    Unidade('Jarda', 'yd', 0.9144),
  ]),
  CategoriaUnidade('Massa', [
    Unidade('Quilograma', 'kg', 1.0),
    Unidade('Grama', 'g', 0.001),
    Unidade('Tonelada', 't', 1000.0),
    Unidade('Libra', 'lb', 0.453592),
    Unidade('Onça', 'oz', 0.0283495),
  ]),
];
