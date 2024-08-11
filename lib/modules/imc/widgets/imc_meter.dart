import 'package:flutter/material.dart';
import 'dart:math';

class ImcMeter extends StatelessWidget {
  final double imc;

  const ImcMeter({super.key, required this.imc});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(200, 200), // Tamanho do velocímetro
      painter: _ImcMeterPainter(imc: imc),
    );
  }
}

class _ImcMeterPainter extends CustomPainter {
  final double imc;

  _ImcMeterPainter({required this.imc});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 1.7;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 35;

    // Desenhar arco principal do velocímetro
    paint.color = Colors.grey.shade300;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi, // Ângulo inicial (π radianos = 180°)
      pi, // Ângulo de varredura (π radianos = 180°)
      false,
      paint,
    );

    // Definir as seções para que todas tenham o mesmo tamanho visual
    const sectionCount = 8; // Número total de seções
    const sectionAngle = pi / sectionCount; // Ângulo de cada seção

    final categoryColors = [
      Colors.blue,
      Colors.blue[600]!,
      Colors.blue[800]!,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.red,
      Colors.red[900]!,
    ];

    double startAngle = pi; // Inicia o arco a partir de 180°

    for (int i = 0; i < sectionCount; i++) {
      paint.color = categoryColors[i];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sectionAngle,
        false,
        paint,
      );
      startAngle += sectionAngle;
    }

    // Mapear o IMC para a posição no arco visual
    final imcRanges = [
      [0, 15.99], // Magreza grave
      [16, 16.99], // Magreza moderada
      [17, 18.49], // Magreza leve
      [18.5, 24.99], // Peso ideal
      [25, 29.99], // Sobrepeso
      [30, 34.99], // Obesidade grau I
      [35, 39.99], // Obesidade grau
      [40, 56], // Obesidade grau III
    ];

    // Encontrar o ângulo correspondente ao IMC
    double normalizedImc = 0;
    for (int i = 0; i < imcRanges.length; i++) {
      if (imc >= imcRanges[i][0] && imc < imcRanges[i][1]) {
        normalizedImc =
            (imc - imcRanges[i][0]) / (imcRanges[i][1] - imcRanges[i][0]);
        normalizedImc = (i + normalizedImc) / sectionCount;
        break;
      }
    }

    // Calcular o ângulo do ponteiro com base no IMC normalizado
    final pointerAngle = pi + normalizedImc * pi;

    final pointerLength = radius * 1; // Ajustar o comprimento do ponteiro

    // Desenhar o ponteiro do IMC
    paint.color = Colors.black;
    paint.strokeWidth = 4;
    canvas.drawLine(
      center,
      Offset(
        center.dx + pointerLength * cos(pointerAngle),
        center.dy + pointerLength * sin(pointerAngle),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Redesenhar sempre que o IMC mudar
  }
}
