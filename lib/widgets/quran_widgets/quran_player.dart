import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/appcolors.dart';

class QuranPlayer extends StatefulWidget {
  const QuranPlayer({
    super.key,
    this.surahName = 'Surah Al-Kahf',
    this.reciterName = 'Mishary Rashid Alafasy',
    this.ayahNumber,
    this.onPlayPause,
  });
  final String surahName;
  final String reciterName;
  final int? ayahNumber;
  final VoidCallback? onPlayPause;
  @override
  State<QuranPlayer> createState() => _QuranPlayerState();
}

class _QuranPlayerState extends State<QuranPlayer>
    with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  double _progress = 0.0;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(covariant QuranPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.ayahNumber != widget.ayahNumber ||
        oldWidget.surahName != widget.surahName) {
      setState(() {
        _progress = 0.0;
        _isPlaying = false;
      });
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String _formatTime(double progress, {bool remaining = false}) {
    const totalSeconds = 847;
    final elapsed = (totalSeconds * progress).round();
    final display = remaining ? totalSeconds - elapsed : elapsed;
    final m = display ~/ 60;
    final s = display % 60;
    return '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    widget.onPlayPause?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 20.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // SURAH + AYAH INFO
          Row(
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.graphic_eq,
                  color: const Color.fromARGB(255, 79, 62, 0),
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.ayahNumber != null
                          ? '${widget.surahName} • Ayah ${widget.ayahNumber}'
                          : widget.surahName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      widget.reciterName,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.white.withValues(alpha: 0.60),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // CONTROLS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Rewind
              _PlayerIconButton(
                icon: Icons.replay_10_rounded,
                size: 26.sp,
                onTap: () {
                  setState(() {
                    _progress = (_progress - 0.011).clamp(0.0, 1.0);
                  });
                },
              ),
              // Play / Pause
              GestureDetector(
                onTap: _togglePlay,
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    final scale = _isPlaying ? _pulseAnimation.value : 1.0;
                    return Transform.scale(scale: scale, child: child);
                  },
                  child: Container(
                    width: 54.r,
                    height: 54.r,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.35),
                          blurRadius: 12.r,
                          offset: Offset(0, 4.h),
                        ),
                      ],
                    ),
                    child: Icon(
                      _isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 28.sp,
                    ),
                  ),
                ),
              ),
              // Forward
              _PlayerIconButton(
                icon: Icons.forward_10_rounded,
                size: 26.sp,
                onTap: () {
                  setState(() {
                    _progress = (_progress + 0.011).clamp(0.0, 1.0);
                  });
                },
              ),
            ],
          ),
          // PROGRESS
          Row(
            children: [
              Text(
                _formatTime(_progress),
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.white.withValues(alpha: 0.55),
                ),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3.h,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 14.r),
                    activeTrackColor: AppColors.accent,
                    inactiveTrackColor: Colors.white.withValues(alpha: 0.20),
                    thumbColor: AppColors.accent,
                    overlayColor: AppColors.accent.withValues(alpha: 0.20),
                  ),
                  child: Slider(
                    value: _progress,
                    min: 0,
                    max: 1,
                    onChanged: (value) {
                      setState(() {
                        _progress = value;
                      });
                    },
                  ),
                ),
              ),
              Text(
                '-${_formatTime(_progress, remaining: true)}',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.white.withValues(alpha: 0.55),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// PLAYER BUTTON
class _PlayerIconButton extends StatelessWidget {
  const _PlayerIconButton({required this.icon, required this.onTap, this.size});
  final IconData icon;
  final VoidCallback onTap;
  final double? size;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        color: Colors.white.withValues(alpha: 0.75),
        size: size ?? 22.sp,
      ),
    );
  }
}
