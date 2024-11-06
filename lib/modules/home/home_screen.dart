import 'package:flutter/material.dart';
import 'package:utilitarios/core/routes/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    utilities;

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
