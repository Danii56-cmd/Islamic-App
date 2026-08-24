// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:islamic_app/core/appconstants.dart';
import 'package:islamic_app/core/theme_extensions.dart';
import 'package:islamic_app/providers/location_provider.dart';
import 'package:islamic_app/widgets/custom_pop_scope.dart';
import 'package:islamic_app/widgets/islamiccalendr_widgets/calendar_grid.dart';
import 'package:islamic_app/widgets/islamiccalendr_widgets/calendar_header.dart';
import 'package:islamic_app/widgets/islamiccalendr_widgets/event_card.dart';
import 'package:islamic_app/widgets/islamiccalendr_widgets/event_schedule_section.dart';
import 'package:islamic_app/widgets/islamiccalendr_widgets/islamic_info_card.dart';
import 'package:provider/provider.dart';

class IslamicCalendarScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const IslamicCalendarScreen({super.key, this.onBack});

  @override
  State<IslamicCalendarScreen> createState() => _IslamicCalendarScreenState();
}

class _IslamicCalendarScreenState extends State<IslamicCalendarScreen> {
  DateTime _visibleMonth = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  void _previousMonth() {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1, 1);
    });
  }

  String _getCurrentHijri() {
    final hijri = HijriCalendar.fromDate(_selectedDate);

    return '${hijri.getLongMonthName()} ${hijri.hYear} AH';
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopScope(
      isRoot: false,
      onBackPressed: () {
        if (widget.onBack != null) {
          widget.onBack!();
          return true;
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: context.background,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),

                // Back Button + Title
                Row(
                  children: [
                    // if (widget.onBack != null) ...[
                    //   InkWell(
                    //     onTap: widget.onBack,
                    //     borderRadius: BorderRadius.circular(20.r),
                    //     child: Container(
                    //       padding: EdgeInsets.all(10.w),
                    //       decoration: BoxDecoration(
                    //         color: Color(0xFFF2F4F3),
                    //         shape: BoxShape.circle,
                    //       ),
                    //       child: Icon(
                    //         Icons.arrow_back_ios_new_rounded,
                    //         size: 16.sp,
                    //         color: context.textPrimary,
                    //       ),
                    //     ),
                    //   ),
                    // ],
                  ],
                ),
                SizedBox(height: 20.h),
                Consumer<LocationProvider>(
                  builder: (context, locProvider, _) {
                    final loc = locProvider.location?.label ?? 'Makkah, KSA';
                    return CalendarHeader(
                      hijriDate: _getCurrentHijri(),
                      location: loc,
                    );
                  },
                ),
                SizedBox(height: 20.h),
                CalendarGrid(
                  visibleMonth: _visibleMonth,
                  selectedDate: _selectedDate,
                  onDateSelected: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                  onPreviousMonth: _previousMonth,
                  onNextMonth: _nextMonth,
                ),
                SizedBox(height: 30.h),
                UpcomingEventCard(
                  onReminderTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Reminder set for Eid-al-Fitr.'),
                      ),
                    );
                  },
                ),
                SizedBox(height: 28.h),
                const EventScheduleSection(),
                SizedBox(height: 60.h),
                const IslamicInfoCard(
                  image: Appconstants.mosqueImage,
                  title: 'Understanding Hijri',
                  description:
                      'Discover the history and significance '
                      'of the lunar calendar system.',
                ),
                SizedBox(height: 20.h),
                const IslamicInfoCard(
                  image: Appconstants.quranImage,
                  title: 'Sacred Months',
                  description:
                      'Learn about the four sacred months '
                      'in Islam and their unique virtues.',
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
