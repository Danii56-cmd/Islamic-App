import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/appcolors.dart';

class QuranPlayer extends StatefulWidget {
  const QuranPlayer({
    super.key,
    this.surahName = 'Surah Al-Kahf',
    this.reciterName = 'Mishary Rashid Alafasy',
    this.ayahNumber,
    this.isPlaying = false,
    this.isLoading = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.progress = 0.0,
    this.onPlayPause,
    this.onSeek,
    this.onPrevious,
    this.onNext,
  });

  final String surahName;
  final String reciterName;
  final int? ayahNumber;
  final bool isPlaying;
  final bool isLoading;
  final Duration position;
  final Duration duration;
  final double progress;
  final VoidCallback? onPlayPause;
  final ValueChanged<double>? onSeek;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  State<QuranPlayer> createState() => _QuranPlayerState();
}

class _QuranPlayerState extends State<QuranPlayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  double? _dragValue;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final currentProgress = (_dragValue ?? widget.progress).clamp(0.0, 1.0);
    final remainingDuration = widget.duration > widget.position
        ? widget.duration - widget.position
        : Duration.zero;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.30),
            blurRadius: 20.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // SURAH + AYAH INFO & SPEAKER ICON
          Row(
            children: [
              Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  widget.isPlaying ? Icons.volume_up_rounded : Icons.graphic_eq,
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
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.reciterName,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.white.withValues(alpha: 0.70),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.speaker_rounded,
                                size: 10.sp,
                                color: AppColors.accent,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Speaker',
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // CONTROLS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Previous / Rewind
              _PlayerIconButton(
                icon: Icons.replay_10_rounded,
                size: 26.sp,
                onTap: () {
                  widget.onPrevious?.call();
                },
              ),
              // Play / Pause / Loading
              GestureDetector(
                onTap: widget.onPlayPause,
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    final scale =
                        widget.isPlaying ? _pulseAnimation.value : 1.0;
                    return Transform.scale(scale: scale, child: child);
                  },
                  child: Container(
                    width: 52.r,
                    height: 52.r,
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
                    child: widget.isLoading
                        ? Center(
                            child: SizedBox(
                              width: 22.r,
                              height: 22.r,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Icon(
                            widget.isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 28.sp,
                          ),
                  ),
                ),
              ),
              // Next / Forward
              _PlayerIconButton(
                icon: Icons.forward_10_rounded,
                size: 26.sp,
                onTap: () {
                  widget.onNext?.call();
                },
              ),
            ],
          ),

          // PROGRESS SLIDER & TIMESTAMPS
          Row(
            children: [
              Text(
                _formatDuration(widget.position),
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.white.withValues(alpha: 0.65),
                ),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3.h,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.r),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 12.r),
                    activeTrackColor: AppColors.accent,
                    inactiveTrackColor: Colors.white.withValues(alpha: 0.20),
                    thumbColor: AppColors.accent,
                    overlayColor: AppColors.accent.withValues(alpha: 0.20),
                  ),
                  child: Slider(
                    value: currentProgress,
                    min: 0,
                    max: 1,
                    onChanged: (value) {
                      setState(() {
                        _dragValue = value;
                      });
                    },
                    onChangeEnd: (value) {
                      setState(() {
                        _dragValue = null;
                      });
                      widget.onSeek?.call(value);
                    },
                  ),
                ),
              ),
              Text(
                widget.duration > Duration.zero
                    ? '-${_formatDuration(remainingDuration)}'
                    : '--:--',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.white.withValues(alpha: 0.65),
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
        color: Colors.white.withValues(alpha: 0.85),
        size: size ?? 22.sp,
      ),
    );
  }
}
