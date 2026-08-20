import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/theme_extensions.dart';
import 'event_schedule_card.dart';

class EventScheduleSection extends StatelessWidget {
  const EventScheduleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 6.w,
              height: 6.w,
              decoration: BoxDecoration(
                color: context.accent,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 7.w),
            Text(
              'Events Schedule',
              style: TextStyle(
                color: context.textPrimary,
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: 18.h),
        EventScheduleCard(
          date: 'APRIL 10–12',
          title: 'Eid-al-Fitr',
          description:
              'The festival of breaking the fast marks '
              'the end of Ramadan.',
          tag: 'Holiday',
          tagBackground: Color(0xFFEDE6C7),
          accentColor: context.accent,
        ),
        SizedBox(height: 15.h),
        EventScheduleCard(
          date: 'MAY 09',
          title: 'Dhul-Qi’dah Begins',
          description:
              'The 11th month of the Islamic calendar, '
              'a sacred month of peace.',
          tag: 'Sunnah',
          tagBackground: Color(0xFFE7E9E8),
          accentColor: context.iconBackground,
        ),
        SizedBox(height: 15.h),
        EventScheduleCard(
          date: 'JUNE 16',
          title: 'Eid-al-Adha',
          description:
              'The festival of sacrifice occurring '
              'during the Hajj season.',
          tag: 'Major',
          tagBackground: Color(0xFFFFD8D5),
          accentColor: context.iconBackground,
        ),
      ],
    );
  }
}
