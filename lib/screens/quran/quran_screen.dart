import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:islamic_app/core/appcolors.dart';
import 'package:islamic_app/providers/quran_provider.dart';
import 'package:islamic_app/screens/quran/duas_suplications_screen.dart';
import 'package:islamic_app/widgets/appbar.dart';
import 'package:islamic_app/widgets/header_text.dart';
import 'package:islamic_app/widgets/quran_widgets/ayah_card.dart';
import 'package:islamic_app/widgets/quran_widgets/quran_player.dart';

class QuranScreen extends StatefulWidget {
  final bool showDuas;
  final VoidCallback onCloseDuas;

  const QuranScreen({
    super.key,
    required this.showDuas,
    required this.onCloseDuas,
  });

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showSurahPicker(BuildContext context, QuranProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.scaffoldBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.85,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              expand: false,
              builder: (_, scrollController) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: AppColors.textMuted.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Select Surah",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Text(
                            "${provider.allSurahs.length} Surahs",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),
                      // Search inside modal
                      TextField(
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search by name or number...',
                          hintStyle: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.textMuted,
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: AppColors.textMuted,
                            size: 20.sp,
                          ),
                          filled: true,
                          fillColor: AppColors.textMuted.withValues(alpha: 0.08),
                          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (q) {
                          setModalState(() {
                            provider.searchSurahs(q);
                          });
                        },
                      ),
                      SizedBox(height: 14.h),
                      Expanded(
                        child: ListView.separated(
                          controller: scrollController,
                          physics: const BouncingScrollPhysics(),
                          itemCount: provider.filteredSurahs.length,
                          separatorBuilder: (_, __) => SizedBox(height: 8.h),
                          itemBuilder: (context, index) {
                            final surah = provider.filteredSurahs[index];
                            final isSelected =
                                provider.currentSurah?.number == surah.number;

                            return InkWell(
                              onTap: () {
                                provider.fetchSurah(surah.number);
                                Navigator.pop(ctx);
                              },
                              borderRadius: BorderRadius.circular(14.r),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                  vertical: 12.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.accent.withValues(alpha: 0.15)
                                      : AppColors.cardBackground,
                                  borderRadius: BorderRadius.circular(14.r),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.accent
                                        : Colors.transparent,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 34.r,
                                      height: 34.r,
                                      decoration: BoxDecoration(
                                        color: AppColors.textMuted.withValues(
                                          alpha: 0.1,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${surah.number}',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 14.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            surah.englishName,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          SizedBox(height: 2.h),
                                          Text(
                                            '${surah.englishNameTranslation} • ${surah.numberOfAyahs} Verses',
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      surah.name,
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Amiri',
                                        color: AppColors.primary,
                                      ),
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showDuas) {
      return DuasScreen(onBack: widget.onCloseDuas);
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: const Appbar(),
      body: Consumer<QuranProvider>(
        builder: (context, provider, _) {
          final surah = provider.currentSurah;
          final surahTitle =
              surah != null ? 'Surah ${surah.englishName}' : 'Surah Al-Kahf';
          final surahSubtitle = surah != null
              ? surah.subtitle
              : 'The Cave  •  110 Verses  •  Meccan';

          final isLoading = provider.ayahsStatus == QuranLoadStatus.loading;
          final isError = provider.ayahsStatus == QuranLoadStatus.error;
          final ayahs = provider.currentAyahs;

          return Stack(
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

                  // Current reading label & Surah selector icon
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          'CURRENT READING',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accent,
                            letterSpacing: 1.2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _showSurahPicker(context, provider),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Change Surah',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 16.sp,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),

                  // Surah title
                  HeaderText(text: surahTitle),
                  SizedBox(height: 6.h),

                  // Subtitle
                  Text(
                    surahSubtitle,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 14.h),

                  // Search field
                  GestureDetector(
                    onTap: () => _showSurahPicker(context, provider),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _searchController,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search Surah or Verse...',
                          hintStyle: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.textMuted,
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: AppColors.textMuted,
                            size: 20.sp,
                          ),
                          filled: true,
                          fillColor:
                              AppColors.textMuted.withValues(alpha: 0.07),
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
                            borderSide: const BorderSide(
                              color: AppColors.accent,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Loading State
                  if (isLoading)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  else if (isError)
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.cloud_off_rounded,
                            size: 36.sp,
                            color: AppColors.textMuted,
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            provider.errorMessage ?? 'Could not load verses.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            onPressed: () =>
                                provider.fetchSurah(surah?.number ?? 18),
                            child: const Text(
                              'Retry',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    // Ayah cards
                    for (int i = 0; i < ayahs.length; i++) ...[
                      AyahCard(
                        ayahNumber: ayahs[i].numberInSurah,
                        arabicText: ayahs[i].arabicText,
                        translation: ayahs[i].translation,
                        tag: i == 0
                            ? AyahTag.highlight
                            : (provider.isBookmarked(ayahs[i])
                                ? AyahTag.saved
                                : AyahTag.none),
                        isBookmarked: provider.isBookmarked(ayahs[i]),
                        onBookmarkTap: () =>
                            provider.toggleBookmark(ayahs[i]),
                        onShareTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: const Duration(seconds: 1),
                              content: Text(
                                'Ayah ${ayahs[i].numberInSurah} copied to clipboard',
                              ),
                            ),
                          );
                        },
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
                child: QuranPlayer(
                  surahName: surahTitle,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
