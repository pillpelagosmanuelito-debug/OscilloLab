import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

/// Dibuja una pantalla de osciloscopio con grilla (divisiones) y la
/// forma de onda muestreada, imitando un display real de fosforo verde.
class OsciloscopioPantallaWidget extends StatelessWidget {
  const OsciloscopioPantallaWidget({super.key, required this.muestras});

  final List<double> muestras;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF06120A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.verdeFosforo.withOpacity(0.3)),
        ),
        child: CustomPaint(
          painter: _OsciloscopioPainter(muestras: muestras),
        ),
      ),
    );
  }
}

class _OsciloscopioPainter extends CustomPainter {
  _OsciloscopioPainter({required this.muestras});

  final List<double> muestras;

  @override
  void paint(Canvas canvas, Size size) {
    _dibujarGrilla(canvas, size);
    _dibujarSenal(canvas, size);
  }

  void _dibujarGrilla(Canvas canvas, Size size) {
    final Paint lineaGrilla = Paint()
      ..color = AppTheme.verdeFosforo.withOpacity(0.15)
      ..strokeWidth = 1;
    const int divisiones = 8;
    for (int i = 1; i < divisiones; i++) {
      final double x = size.width * i / divisiones;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), lineaGrilla);
      final double y = size.height * i / divisiones;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), lineaGrilla);
    }
    final Paint ejeCentral = Paint()
      ..color = AppTheme.verdeFosforo.withOpacity(0.35)
      ..strokeWidth = 1.4;
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), ejeCentral);
  }

  void _dibujarSenal(Canvas canvas, Size size) {
    if (muestras.isEmpty) return;
    final double maxAbs = muestras.map((v) => v.abs()).reduce((a, b) => a > b ? a : b);
    final double escala = maxAbs == 0 ? 1 : (size.height * 0.42) / maxAbs;

    final Paint trazo = Paint()
      ..color = AppTheme.verdeFosforo
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    final Path camino = Path();
    for (int i = 0; i < muestras.length; i++) {
      final double x = size.width * i / (muestras.length - 1);
      final double y = size.height / 2 - muestras[i] * escala;
      if (i == 0) {
        camino.moveTo(x, y);
      } else {
        camino.lineTo(x, y);
      }
    }
    canvas.drawPath(camino, trazo);
  }

  @override
  bool shouldRepaint(covariant _OsciloscopioPainter oldDelegate) {
    return oldDelegate.muestras != muestras;
  }
}
