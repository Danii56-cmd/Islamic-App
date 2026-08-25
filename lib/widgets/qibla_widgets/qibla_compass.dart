import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/widgets/qibla_widgets/qibla_needle.dart';

/// Real-time Qibla compass displaying rotating magnetic dial and accurate Qibla pointer.
class QiblaCompass extends StatelessWidget {
  final double qiblaBearing;
  final double deviceHeading;
  final bool isAligned;
  final bool needsCalibration;

  const QiblaCompass({
    super.key,
    required this.qiblaBearing,
    required this.deviceHeading,
    this.isAligned = false,
    this.needsCalibration = false,
  });

  @override
  Widget build(BuildContext context) {
    // Dial angle rotates counter-clockwise to keep 'N' aligned with physical North
    final dialAngle = -deviceHeading * (math.pi / 180.0);

    // Needle angle points towards Qibla relative to device forward axis (12 o'clock)
    final needleAngle = (qiblaBearing - deviceHeading) * (math.pi / 180.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (needsCalibration) ...[
          Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3CD),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: const Color(0xFFFFEEBA)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.screen_rotation_outlined,
                  size: 15.sp,
                  color: const Color(0xFF856404),
                ),
                SizedBox(width: 6.w),
                Text(
                  'Calibrate compass: move phone in figure 8',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF856404),
                  ),
                ),
              ],
            ),
          ),
        ],

        // Main Compass Stack
        SizedBox(
          width: 280.w,
          height: 280.w,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 1. Outer decorative / glow ring
              _outerRing(),

              // 2. Rotating compass dial (ticks, N, E, S, W)
              Transform.rotate(
                angle: dialAngle,
                child: _rotatingDial(),
              ),

              // 3. Forward phone target notch (fixed at 12 o'clock top)
              _topForwardMarker(),

              // 4. Rotating Qibla Needle + Kaaba Icon pointing directly to Qibla
              Transform.rotate(
                angle: needleAngle,
                child: _qiblaPointer(),
              ),

              // 5. Center alignment badge / status
              if (isAligned) _alignmentBadge(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _outerRing() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 272.w,
      height: 272.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isAligned
              ? const Color(0xFF00796B)
              : const Color(0xFFE0E5E2),
          width: isAligned ? 2.5 : 1.2,
        ),
        boxShadow: isAligned
            ? [
                BoxShadow(
                  color: const Color(0xFF00796B).withValues(alpha: 0.25),
                  blurRadius: 18,
                  spreadRadius: 4,
                ),
              ]
            : null,
      ),
    );
  }

  Widget _rotatingDial() {
    return Container(
      width: 236.w,
      height: 236.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Dial degree markings
          CustomPaint(
            size: Size(236.w, 236.w),
            painter: _CompassDialPainter(),
          ),

          // Inner circular track
          Container(
            width: 172.w,
            height: 172.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF7F9F8),
              border: Border.all(color: const Color(0xFFE8ECE9), width: 1),
            ),
          ),

          // Cardinal directions on rotating dial
          _cardinalLabel(
            'N',
            Alignment.topCenter,
            color: const Color(0xFFD32F2F),
            isNorth: true,
          ),
          _cardinalLabel('E', Alignment.centerRight),
          _cardinalLabel('S', Alignment.bottomCenter),
          _cardinalLabel('W', Alignment.centerLeft),
        ],
      ),
    );
  }

  Widget _cardinalLabel(
    String text,
    Alignment alignment, {
    Color? color,
    bool isNorth = false,
  }) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Text(
          text,
          style: TextStyle(
            fontSize: isNorth ? 14.sp : 12.sp,
            fontWeight: isNorth ? FontWeight.w800 : FontWeight.w600,
            color: color ?? const Color(0xFF5A6662),
          ),
        ),
      ),
    );
  }

  Widget _topForwardMarker() {
    return Positioned(
      top: 2.h,
      child: Container(
        width: 12.w,
        height: 12.w,
        decoration: BoxDecoration(
          color: isAligned ? const Color(0xFF00796B) : const Color(0xFFC5A038),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _qiblaPointer() {
    return SizedBox(
      width: 220.w,
      height: 220.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Needle painter
          SizedBox(
            width: 22.w,
            height: 145.h,
            child: CustomPaint(
              painter: QiblaNeedlePainter(
                primaryColor: const Color(0xFF004D40),
                secondaryColor: const Color(0xFFC5A038),
                isAligned: isAligned,
              ),
            ),
          ),

          // Kaaba Icon on the pointed tip
          Positioned(
            top: 6.h,
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/kaaba.png',
                width: 26.w,
                height: 26.w,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _alignmentBadge() {
    return Positioned(
      bottom: 22.h,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: const Color(0xFF00796B),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00796B).withValues(alpha: 0.35),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 12.sp),
            SizedBox(width: 4.w),
            Text(
              'Facing Qibla',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompassDialPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final tickPaint = Paint()
      ..color = const Color(0xFFCFD8DC)
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    final majorTickPaint = Paint()
      ..color = const Color(0xFF90A4AE)
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 360; i += 5) {
      final isMajor = i % 30 == 0;
      final isCardinal = i % 90 == 0;

      if (isCardinal) continue; // Skip cardinal spots (N, E, S, W have text)

      final angle = (i - 90) * (math.pi / 180.0);
      final tickLength = isMajor ? 8.0 : 4.0;

      final startRadius = radius - 10.0;
      final endRadius = startRadius - tickLength;

      final startX = center.dx + startRadius * math.cos(angle);
      final startY = center.dy + startRadius * math.sin(angle);
      final endX = center.dx + endRadius * math.cos(angle);
      final endY = center.dy + endRadius * math.sin(angle);

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        isMajor ? majorTickPaint : tickPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
