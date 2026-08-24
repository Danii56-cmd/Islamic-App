import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:islamic_app/core/appcolors.dart';
import 'package:islamic_app/core/theme_extensions.dart';
import 'calendar_day.dart';

class CalendarGrid extends StatelessWidget {
  final DateTime visibleMonth;
  final DateTime selectedDate;
  final VoidCallback onNextMonth;
  final VoidCallback onPreviousMonth;
  final Function(DateTime) onDateSelected;

  const CalendarGrid({
    super.key,
    required this.visibleMonth,
    required this.selectedDate,
    required this.onDateSelected,
    required this.onNextMonth,
    required this.onPreviousMonth,
  });

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month - 1];
  }

  int _daysInMonth() {
    return DateTime(visibleMonth.year, visibleMonth.month + 1, 0).day;
  }

  bool _isSelected(DateTime date) {
    return date.year == selectedDate.year &&
        date.month == selectedDate.month &&
        date.day == selectedDate.day;
  }

  bool _isToday(DateTime date) {
    return DateUtils.isSameDay(date, DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(visibleMonth.year, visibleMonth.month, 1);

    final firstWeekday = firstDay.weekday % 7;
    final totalDays = _daysInMonth();
    final cells = <Widget>[];

    for (int i = 0; i < firstWeekday; i++) {
      cells.add(const SizedBox());
    }

    for (int day = 1; day <= totalDays; day++) {
      final date = DateTime(visibleMonth.year, visibleMonth.month, day);

      final hijriDate = HijriCalendar.fromDate(date);

      cells.add(
        CalendarDay(
          date: date,
          hijriDate: hijriDate,
          isSelected: _isSelected(date),
          isToday: _isToday(date),
          onTap: () => onDateSelected(date),
        ),
      );
    }

    final hijriMonth = HijriCalendar.fromDate(visibleMonth);

    return Container(
      padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 18.h),
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(17.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_monthName(visibleMonth.month)} ${visibleMonth.year}',
                    style: TextStyle(
                      color: context.textPrimary,
                      fontSize: 21.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    '${hijriMonth.getLongMonthName()} ${hijriMonth.hYear}',
                    style: TextStyle(
                      color: context.textSecondary,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  _NavigationButton(
                    icon: Icons.chevron_left_rounded,
                    onTap: onPreviousMonth,
                  ),
                  SizedBox(width: 7.w),
                  _NavigationButton(
                    icon: Icons.chevron_right_rounded,
                    onTap: onNextMonth,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 25.h),

          // Weekdays
          Row(
            children: const [
              _WeekDay('SUN'),
              _WeekDay('MON'),
              _WeekDay('TUE'),
              _WeekDay('WED'),
              _WeekDay('THU'),
              _WeekDay('FRI'),
              _WeekDay('SAT'),
            ],
          ),

          SizedBox(height: 10.h),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cells.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 7.h,
              childAspectRatio: 0.78,
            ),
            itemBuilder: (_, index) {
              return cells[index];
            },
          ),
        ],
      ),
    );
  }
}

class _WeekDay extends StatelessWidget {
  final String text;

  const _WeekDay(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: context.textSecondary,
            fontSize: 9.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavigationButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 29.w,
        height: 29.w,
        decoration: BoxDecoration(
          color: context.iconBackground,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 19.sp, color: context.textPrimary),
      ),
    );
  }
}
