import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/appcolors.dart';
import 'package:islamic_app/widgets/qibla_widgets/qibla_needle.dart';

/// Real-time Qibla compass.
///
/// flutter_qiblah gives us two bearings:
/// - qiblaDirection: Qibla bearing from true/magnetic North, 0..360.
/// - deviceDirection: current phone heading, 0..360.
///
/// IMPORTANT:
/// The compass face stays fixed on screen. Only the Qibla pointer moves.
/// The pointer position is the relative bearing:
///
///   relative = Qibla bearing - phone heading
///
/// This prevents the whole compass from spinning and makes the pointer
/// always show where the Kaaba is relative to the phone.
class QiblaCompass extends StatefulWidget {
  final double qiblaDirection;
  final double deviceDirection;

  const QiblaCompass({
    super.key,
    required this.qiblaDirection,
    required this.deviceDirection,
  });

  @override
  State<QiblaCompass> createState() => _QiblaCompassState();
}

class _QiblaCompassState extends State<QiblaCompass> {
  double _targetAngle = 0;
  bool _hasReading = false;

  @override
  void initState() {
    super.initState();
    _updateNeedle(widget.qiblaDirection, widget.deviceDirection);
  }

  @override
  void didUpdateWidget(covariant QiblaCompass oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.qiblaDirection != widget.qiblaDirection ||
        oldWidget.deviceDirection != widget.deviceDirection) {
      _updateNeedle(widget.qiblaDirection, widget.deviceDirection);
    }
  }

  double _normalize(double value) {
    var result = value % 360;
    if (result < 0) result += 360;
    return result;
  }

  double _shortestDelta(double from, double to) {
    var delta = _normalize(to) - _normalize(from);

    if (delta > 180) {
      delta -= 360;
    } else if (delta < -180) {
      delta += 360;
    }

    return delta;
  }

  void _updateNeedle(double qibla, double heading) {
    if (!qibla.isFinite || !heading.isFinite) return;

    // Bearing relative to the top of the phone/screen.
    // 0° = straight ahead, 90° = right, 180° = behind, 270° = left.
    final relativeBearing = _normalize(qibla - heading);

    // QiblaNeedlePainter points to the RIGHT at 0 radians.
    // Therefore North/straight ahead (0° bearing) needs -90°.
    final targetRadians = (relativeBearing - 90) * math.pi / 180;

    if (!_hasReading) {
      _targetAngle = targetRadians;
      _hasReading = true;
      return;
    }

    // Move through the shortest path. This avoids a 359° -> 0° spin.
    final currentDegrees = _targetAngle * 180 / math.pi;
    final targetDegrees = targetRadians * 180 / math.pi;
    final nextDegrees =
        currentDegrees + _shortestDelta(currentDegrees, targetDegrees);

    _targetAngle = nextDegrees * math.pi / 180;

    if (mounted) setState(() {});
  }

  bool get _isAligned {
    final difference = _shortestDelta(
      widget.deviceDirection,
      widget.qiblaDirection,
    ).abs();

    return difference <= 5;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340.w,
      height: 340.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _outerRing(),
          _mainCircle(),
          _compassFace(),

          // ONLY the Qibla pointer rotates.
          // The compass face/N/E/S/W remains fixed.
          if (_hasReading) _qiblaPointer(),

          _centerDot(),
          _topIndicator(),
        ],
      ),
    );
  }

  Widget _outerRing() => Container(
    width: 340.w,
    height: 340.w,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: AppColors.prayerCardText.withValues(alpha: 0.35),
        width: 1,
      ),
    ),
  );

  Widget _mainCircle() => Container(
    width: 290.w,
    height: 290.w,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: AppColors.cardBackground,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 18,
          offset: const Offset(0, 12),
        ),
      ],
    ),
  );

  Widget _compassFace() {
    return Container(
      width: 225.w,
      height: 225.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.textMuted.withValues(alpha: 0.08),
        border: Border.all(color: AppColors.divider, width: 1),
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
      padding: EdgeInsets.all(18.w),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    ),
  );

  Widget _qiblaPointer() {
    // Draw the pointer directly from the latest sensor reading.
    // No long animation: the pointer must follow the phone immediately.
    return Transform.rotate(
      angle: _targetAngle,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.mosque_outlined, size: 18.sp, color: Colors.black),
          SizedBox(width: 6.w),
          SizedBox(
            width: 60.w,
            height: 22.w,
            child: const CustomPaint(painter: QiblaNeedlePainter()),
          ),
        ],
      ),
    );
  }

  Widget _centerDot() => AnimatedContainer(
    duration: const Duration(milliseconds: 100),
    width: _isAligned ? 13.w : 10.w,
    height: _isAligned ? 13.w : 10.w,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: _isAligned ? const Color(0xff00897B) : AppColors.primary,
      boxShadow: _isAligned
          ? [
              BoxShadow(
                color: const Color(0xff00897B).withValues(alpha: 0.28),
                blurRadius: 10,
                spreadRadius: 3,
              ),
            ]
          : null,
    ),
  );

  Widget _topIndicator() {
    return Positioned(
      top: 8.w,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 7.w,
        height: _isAligned ? 20.w : 16.w,
        decoration: BoxDecoration(
          color: _isAligned ? const Color(0xff00897B) : AppColors.accent,
          borderRadius: BorderRadius.circular(5.r),
        ),
      ),
    );
  }
}
