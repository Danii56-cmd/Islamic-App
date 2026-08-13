import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass_v2/flutter_compass_v2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/widgets/qibla_widgets/qibla_needle.dart';

/// Real-time Qibla compass.
/// Uses a StreamBuilder on FlutterCompass.events directly so the needle
/// re-renders on EVERY magnetometer event without going through parent setState.
class QiblaCompass extends StatelessWidget {
  final double qiblaBearing; // fixed bearing from user location to Kaaba

  const QiblaCompass({super.key, required this.qiblaBearing});

  double _normalize(double v) {
    var r = v % 360;
    if (r < 0) r += 360;
    return r;
  }

  /// Needle rotation angle in radians.
  /// relativeBearing = how many degrees clockwise from the phone's "up" direction
  /// the Kaaba sits.  We then convert that to a Transform.rotate angle.
  double _needleAngle(double deviceHeading) {
    final relative = _normalize(qiblaBearing - deviceHeading);
    // At 0° the Row widget points right (East). Kaaba at 0° relative (= North)
    // needs the arrow pointing up → subtract 90°.
    return (relative - 90) * math.pi / 180;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        // Default heading = 0 (needle points to qibla at static bearing)
        final heading = snapshot.data?.heading ?? 0.0;
        final angle = _needleAngle(heading);

        return SizedBox(
          width: 270.w,
          height: 270.w,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _outerRing(),
              _mainCircle(),
              _compassFace(),
              Transform.rotate(angle: angle, child: _pointerRow()),
            ],
          ),
        );
      },
    );
  }

  Widget _outerRing() => Container(
    width: 260.w,
    height: 260.w,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: const Color(0xFFECECEC), width: 1.2),
    ),
  );

  Widget _mainCircle() => Container(
    width: 215.w,
    height: 215.w,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.07),
          blurRadius: 22,
          spreadRadius: 2,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.02),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
  );

  Widget _compassFace() {
    return Container(
      width: 160.w,
      height: 160.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFF5F6F5),
        border: Border.all(color: const Color(0xFFE5E7E5), width: 1),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          _label('N', Alignment.topCenter),
          _label('E', Alignment.centerRight),
          _label('S', Alignment.bottomCenter),
          _label('W', Alignment.centerLeft),
        ],
      ),
    );
  }

  Widget _label(String text, Alignment alignment) => Align(
    alignment: alignment,
    child: Padding(
      padding: EdgeInsets.all(10.w),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF4E5855),
        ),
      ),
    ),
  );

  Widget _pointerRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/kaaba.png',
          width: 20.w,
          height: 20.w,
          fit: BoxFit.contain,
        ),
        SizedBox(width: 4.w),
        SizedBox(
          width: 62.w,
          height: 16.w,
          child: const CustomPaint(painter: QiblaNeedlePainter()),
        ),
        SizedBox(width: 24.w),
      ],
    );
  }
}
