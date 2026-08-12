import 'package:flutter/material.dart';

class QiblaNeedlePainter extends CustomPainter {
  final Color color;
  const QiblaNeedlePainter({this.color = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final centerY = h / 2;
    final centerX = w / 2;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..isAntiAlias = true;

    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // 1. Left filled pointer (Qibla pointer tip pointing left)
    final leftTip = Path()
      ..moveTo(0, centerY)
      ..lineTo(centerX * 0.5, 0)
      ..lineTo(centerX, centerY)
      ..lineTo(centerX * 0.5, h)
      ..close();
    canvas.drawPath(leftTip, fillPaint);

    // 2. Right outlined pointer (Opposite tip pointing right)
    final rightTip = Path()
      ..moveTo(w, centerY)
      ..lineTo(centerX + (w - centerX) * 0.5, 0)
      ..lineTo(centerX, centerY)
      ..lineTo(centerX + (w - centerX) * 0.5, h)
      ..close();

    canvas.drawPath(rightTip, whitePaint);
    canvas.drawPath(rightTip, strokePaint);

    // 3. Center pivot circle
    final pivotRadius = h * 0.28;
    canvas.drawCircle(Offset(centerX, centerY), pivotRadius, fillPaint);
  }

  @override
  bool shouldRepaint(covariant QiblaNeedlePainter oldDelegate) =>
      oldDelegate.color != color;
}
