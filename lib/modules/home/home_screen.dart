import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> utilities = [
      {'title': 'Tempo', 'route': '/tempo'},
      {'title': 'Calculadora de IMC', 'route': '/calculadora-imc'},
      {'title': 'Alcool ou Gasolina', 'route': '/combustivel'},
      {'title': 'Conversor de Moedas', 'route': '/conversor-moedas'},
      {'title': 'Lembrete de Beber Água', 'route': '/lembrete-agua'},
      {'title': 'Gerenciador de Senhas', 'route': '/auth-senhas'},
      // {'title': 'Gerenciador de Senhas', 'route': '/gerenciador-senhas'},
      {'title': 'Calculadora', 'route': '/calculadora'},
      {'title': 'Lista de Tarefas', 'route': '/lista-tarefas'},
      {'title': 'Controle de Despesas', 'route': '/controle-despesas'},
      {'title': 'Conversor de Unidades', 'route': '/conversor-unidades'},
      {
        'title': 'Cronômetro e Temporizador',
        'route': '/cronometro-temporizador'
      },
      {
        'title': 'Calculadora de Empréstimos',
        'route': '/calculadora-emprestimos'
      },
      // Adicione outros utilitários aqui
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Utilidades'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        padding: const EdgeInsets.all(10.0),
        itemCount: utilities.length,
        itemBuilder: (ctx, i) {
          return Card(
            elevation: 5,
            child: InkWell(
              onTap: () {
                // Navega usando o `Navigator.pushNamed`
                Navigator.pushNamed(context, utilities[i]['route']!);
              },
              child: Center(
                child: Text(
                  utilities[i]['title']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
