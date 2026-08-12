import 'package:flutter/material.dart';

class QiblaNeedlePainter extends CustomPainter {
  final Color color;
  const QiblaNeedlePainter({this.color = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;
    final diamondWidth = w * 0.72;

    // Diamond body
    final diamond = Path()
      ..moveTo(0, h / 2)
      ..lineTo(diamondWidth / 2, 0)
      ..lineTo(diamondWidth, h / 2)
      ..lineTo(diamondWidth / 2, h)
      ..close();
    canvas.drawPath(diamond, strokePaint);

    // Arrow tip
    final tip = Path()
      ..moveTo(diamondWidth, h * 0.15)
      ..lineTo(w, h / 2)
      ..lineTo(diamondWidth, h * 0.85)
      ..close();
    canvas.drawPath(tip, fillPaint);
  }

  @override
  bool shouldRepaint(covariant QiblaNeedlePainter oldDelegate) =>
      oldDelegate.color != color;
}
