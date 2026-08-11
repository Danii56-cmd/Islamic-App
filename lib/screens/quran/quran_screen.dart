import 'package:flutter/material.dart';
import 'package:islamic_app/core/appcolors.dart';
import 'package:islamic_app/widgets/appbar.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: Appbar(),
      body: Center(
        child: Text(
          "Quran Screen",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
