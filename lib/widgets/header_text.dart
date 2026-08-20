import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/theme_extensions.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.w700,
        color: context.textPrimary,
      ),
    );
  }
}
