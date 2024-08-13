import 'package:flutter/material.dart';
import 'dart:math';

class ImcMeter extends StatelessWidget {
  final ImcMeterData imcMeterData;

  const ImcMeter({super.key, required this.imcMeterData});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(200, 200), // Tamanho do velocímetro
      painter: _ImcMeterPainter(imcMeterData: imcMeterData),
    );
  }
}

class _ImcMeterPainter extends CustomPainter {
  final ImcMeterData imcMeterData;

  _ImcMeterPainter({required this.imcMeterData});

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
    // Número total de seções
    final sectionCount = imcMeterData.sectionColors.length;
    final sectionAngle = pi / sectionCount; // Ângulo de cada seção

    double startAngle = pi; // Inicia o arco a partir de 180°

    for (int i = 0; i < sectionCount; i++) {
      paint.color = imcMeterData.sectionColors[i];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sectionAngle,
        false,
        paint,
      );
      startAngle += sectionAngle;
    }

    final pointerLength = radius * 1; // Ajustar o comprimento do ponteiro

    // Desenhar o ponteiro do IMC
    paint.color = Colors.black;
    paint.strokeWidth = 4;
    canvas.drawLine(
      center,
      Offset(
        center.dx + pointerLength * cos(imcMeterData.pointerAngle),
        center.dy + pointerLength * sin(imcMeterData.pointerAngle),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Redesenhar sempre que o IMC mudar
  }
}

class ImcMeterData {
  final double pointerAngle;
  final List<Color> sectionColors;

  ImcMeterData({required this.pointerAngle, required this.sectionColors});
}
