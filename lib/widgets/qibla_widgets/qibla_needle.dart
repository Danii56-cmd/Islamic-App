import 'package:flutter/material.dart';

/// Vertical needle painter pointing UP (towards 12 o'clock / Qibla).
class QiblaNeedlePainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final bool isAligned;

  const QiblaNeedlePainter({
    this.primaryColor = const Color(0xFF004D40),
    this.secondaryColor = const Color(0xFFC5A038),
    this.isAligned = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final centerX = w / 2;
    final centerY = h / 2;

    final headColor = isAligned ? const Color(0xFF00796B) : primaryColor;
    final tailColor = const Color(0xFFB0BEC5);

    // 1. Top Qibla needle (pointing UP)
    final headPaint = Paint()
      ..color = headColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final headStrokePaint = Paint()
      ..color = isAligned ? const Color(0xFFC5A038) : Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..isAntiAlias = true;

    final topTip = Path()
      ..moveTo(centerX, 0) // Pointed tip at top
      ..lineTo(centerX + w * 0.38, centerY)
      ..lineTo(centerX, centerY - h * 0.05)
      ..lineTo(centerX - w * 0.38, centerY)
      ..close();

    canvas.drawPath(topTip, headPaint);
    canvas.drawPath(topTip, headStrokePaint);

    // 2. Bottom tail needle (pointing DOWN)
    final tailPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final tailStrokePaint = Paint()
      ..color = tailColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..isAntiAlias = true;

    final bottomTip = Path()
      ..moveTo(centerX, h) // Tip at bottom
      ..lineTo(centerX + w * 0.3, centerY)
      ..lineTo(centerX, centerY + h * 0.05)
      ..lineTo(centerX - w * 0.3, centerY)
      ..close();

    canvas.drawPath(bottomTip, tailPaint);
    canvas.drawPath(bottomTip, tailStrokePaint);

    // 3. Center pivot ring & dot
    final pivotOuterPaint = Paint()
      ..color = isAligned ? const Color(0xFFC5A038) : primaryColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final pivotInnerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawCircle(Offset(centerX, centerY), w * 0.28, pivotOuterPaint);
    canvas.drawCircle(Offset(centerX, centerY), w * 0.14, pivotInnerPaint);
  }

  @override
  bool shouldRepaint(covariant QiblaNeedlePainter oldDelegate) =>
      oldDelegate.primaryColor != primaryColor ||
      oldDelegate.secondaryColor != secondaryColor ||
      oldDelegate.isAligned != isAligned;
}
