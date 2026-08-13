import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/appcolors.dart';
import 'package:islamic_app/screens/quran/duas_suplications_screen.dart';
import 'package:islamic_app/widgets/appbar.dart';
import 'package:islamic_app/widgets/header_text.dart';
import 'package:islamic_app/widgets/quran_widgets/ayah_card.dart';
import 'package:islamic_app/widgets/quran_widgets/quran_player.dart';

// Sample data

const _kAyahs = [
  _AyahData(
    number: 1,
    arabic:
        'الْحَمْدُ لِلَّهِ الَّذِي أَنزَلَ عَلَىٰ\nعَبْدِهِ الْكِتَابَ وَلَمْ يَجْعَلْ\nلَهُ عِوَجًا ۜ',
    translation:
        '[All] praise is [due] to Allah, who has sent down upon His Servant '
        'the Book and has not made therein any deviance.',
    tag: AyahTag.highlight,
    isBookmarked: false,
  ),
  _AyahData(
    number: 2,
    arabic:
        'قَيِّمًا لِّيُنذِرَ بَأْسًا شَدِيدًا\nمِن لَّدُنْهُ وَيُبَشِّرَ الْمُؤْمِنِينَ\nالَّذِينَ يَعْمَلُونَ الصَّالِحَاتِ\nأَنَّ لَهُمْ أَجْرًا حَسَنًا',
    translation:
        '[He has made it] straight, to warn of severe punishment from Him '
        'and to give good tidings to the believers who do righteous deeds '
        'that they will have a good reward.',
    tag: AyahTag.saved,
    isBookmarked: true,
  ),
  _AyahData(
    number: 3,
    arabic: 'مَّاكِثِينَ فِيهِ أَبَدًا',
    translation: 'In which they will remain forever.',
    tag: AyahTag.highlight,
    isBookmarked: false,
  ),
  _AyahData(
    number: 4,
    arabic: 'وَيُنذِرَ الَّذِينَ قَالُوا اتَّخَذَ اللَّهُ وَلَدًا',
    translation: 'And to warn those who say, "Allah has taken a son."',
    tag: AyahTag.none,
    isBookmarked: false,
  ),
  _AyahData(
    number: 5,
    arabic:
        'مَّا لَهُم بِهِ مِنْ عِلْمٍ وَلَا لِآبَائِهِمْ ۚ\nكَبُرَتْ كَلِمَةً تَخْرُجُ مِنْ أَفْوَاهِهِمْ ۚ\nإِن يَقُولُونَ إِلَّا كَذِبًا',
    translation:
        'They have no knowledge of it, nor had their fathers. Grave is the '
        'word that comes out of their mouths; they speak not except a lie.',
    tag: AyahTag.none,
    isBookmarked: false,
  ),
];

class QuranScreen extends StatelessWidget {
  /// Whether the Duas sub-view should be showing right now (controlled by
  /// MainScreen, so Home's Duas container can land here, on the Quran tab,
  /// index 1, already showing Duas).
  final bool showDuas;
  final VoidCallback onCloseDuas;

  const QuranScreen({
    super.key,
    required this.showDuas,
    required this.onCloseDuas,
  });

  @override
  Widget build(BuildContext context) {
    if (showDuas) {
      return DuasScreen(onBack: onCloseDuas);
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: Appbar(),
      body: Stack(
        children: [
          ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              top: 0,
              bottom: 130.h,
            ),
            children: [
              SizedBox(height: 18.h),

              // Current reading label
              Text(
                'CURRENT READING',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accent,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 8.h),

              // Surah title
              HeaderText(text: 'Surah Al-Kahf'),
              SizedBox(height: 6.h),

              // Subtitle
              Text(
                'The Cave  •  110 Verses  •  Meccan',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 14.h),

              // Search field
              _SearchField(),
              SizedBox(height: 20.h),

              // Ayah cards
              for (int i = 0; i < _kAyahs.length; i++) ...[
                AyahCard(
                  ayahNumber: _kAyahs[i].number,
                  arabicText: _kAyahs[i].arabic,
                  translation: _kAyahs[i].translation,
                  tag: _kAyahs[i].tag,
                  isBookmarked: _kAyahs[i].isBookmarked,
                ),
                SizedBox(height: 18.h),
              ],
            ],
          ),

          // Floating player
          Positioned(
            left: 20.w,
            right: 20.w,
            bottom: 16.h,
            child: const QuranPlayer(),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(fontSize: 13.sp, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: 'Search Surah or Verse...',
        hintStyle: TextStyle(fontSize: 13.sp, color: AppColors.textMuted),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: AppColors.textMuted,
          size: 20.sp,
        ),
        filled: true,
        fillColor: AppColors.textMuted.withValues(alpha: 0.07),
        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.accent, width: 1.5),
        ),
      ),
    );
  }
}

// Internal data class

class _AyahData {
  const _AyahData({
    required this.number,
    required this.arabic,
    required this.translation,
    required this.tag,
    required this.isBookmarked,
  });

  final int number;
  final String arabic;
  final String translation;
  final AyahTag tag;
  final bool isBookmarked;
}
