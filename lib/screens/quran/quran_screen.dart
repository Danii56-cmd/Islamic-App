import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/appcolors.dart';
import 'package:islamic_app/core/theme_extensions.dart';
import 'package:islamic_app/models/favourites_model.dart';
import 'package:islamic_app/providers/favourites_provider.dart';
import 'package:islamic_app/providers/quran_provider.dart';
import 'package:islamic_app/screens/favourites/favourites_screen.dart';
import 'package:islamic_app/screens/quran/duas_suplications_screen.dart';
import 'package:islamic_app/widgets/appbar.dart';
import 'package:islamic_app/widgets/header_text.dart';
import 'package:islamic_app/widgets/quran_widgets/ayah_card.dart';
import 'package:islamic_app/widgets/quran_widgets/quran_player.dart';
import 'package:provider/provider.dart';

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

  // Currently selected/playing Ayah.
  int? _selectedAyahNumber;
  // Currently selected Surah.
  int? _selectedSurahNumber;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // SURAH PICKER
  void _showSurahPicker(BuildContext context, QuranProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.background,
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Drag handle
                      Center(
                        child: Container(
                          width: 40.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: context.textMuted.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Header
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Select Surah',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: context.textPrimary,
                              ),
                            ),
                          ),
                          Text(
                            '${provider.allSurahs.length} Surahs',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: context.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),

                      // Search
                      TextField(
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: context.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search by name or number...',
                          hintStyle: TextStyle(
                            fontSize: 13.sp,
                            color: context.textMuted,
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: context.textMuted,
                            size: 20.sp,
                          ),
                          filled: true,
                          fillColor: context.textMuted.withValues(alpha: 0.08),
                          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (query) {
                          setModalState(() {
                            provider.searchSurahs(query);
                          });
                        },
                      ),
                      SizedBox(height: 14.h),

                      // Surah list
                      Expanded(
                        child: ListView.separated(
                          controller: scrollController,
                          physics: const BouncingScrollPhysics(),
                          itemCount: provider.filteredSurahs.length,
                          separatorBuilder: (_, __) => SizedBox(height: 8.h),
                          itemBuilder: (context, index) {
                            final selectedSurah =
                                provider.filteredSurahs[index];
                            final isSelected =
                                provider.currentSurah?.number ==
                                selectedSurah.number;
                            return InkWell(
                              onTap: () {
                                // Clear selected Ayah because
                                // the user is changing Surah.
                                setState(() {
                                  _selectedAyahNumber = null;
                                  _selectedSurahNumber = selectedSurah.number;
                                });
                                provider.fetchSurah(selectedSurah.number);
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
                                      ? context.accent.withValues(alpha: 0.15)
                                      : context.card,
                                  borderRadius: BorderRadius.circular(14.r),
                                  border: Border.all(
                                    color: isSelected
                                        ? context.accent
                                        : Colors.transparent,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Number
                                    Container(
                                      width: 34.r,
                                      height: 34.r,
                                      decoration: BoxDecoration(
                                        color: context.textMuted.withValues(
                                          alpha: 0.1,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${selectedSurah.number}',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w700,
                                          color: context.textPrimary,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 14.w),

                                    // English information
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            selectedSurah.englishName,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w700,
                                              color: context.textPrimary,
                                            ),
                                          ),
                                          SizedBox(height: 2.h),
                                          Text(
                                            '${selectedSurah.englishNameTranslation} • ${selectedSurah.numberOfAyahs} Verses',
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              color: context.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Arabic name
                                    Text(
                                      selectedSurah.name,
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Amiri',
                                        color: context.primary,
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

  // AYAH SELECTION
  void _selectAyah({required int surahNumber, required int ayahNumber}) {
    setState(() {
      _selectedSurahNumber = surahNumber;
      _selectedAyahNumber = ayahNumber;
    });
  }

  // BUILD
  @override
  Widget build(BuildContext context) {
    // Show Duas screen when requested.
    if (widget.showDuas) {
      return DuasScreen(onBack: widget.onCloseDuas);
    }

    return Scaffold(
      backgroundColor: context.background,
      appBar: const Appbar(),
      body: Consumer<QuranProvider>(
        builder: (context, provider, _) {
          final surah = provider.currentSurah;
          final surahTitle = surah != null
              ? 'Surah ${surah.englishName}'
              : 'Surah Al-Kahf';
          final surahSubtitle = surah != null
              ? surah.subtitle
              : 'The Cave  •  110 Verses  •  Meccan';
          final isLoading = provider.ayahsStatus == QuranLoadStatus.loading;
          final isError = provider.ayahsStatus == QuranLoadStatus.error;
          final ayahs = provider.currentAyahs;
          final currentSurahNumber = surah?.number ?? 18;
          final currentSurahName = surah?.englishName ?? 'Al-Kahf';

          return Stack(
            children: [
              // MAIN QURAN CONTENT
              ListView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  top: 0,
                  bottom: 150.h,
                ),
                children: [
                  SizedBox(height: 18.h),
                  // CURRENT READING
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const FavouritesScreen(
                                initialTabIndex: 0,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.bookmark_outline,
                              size: 15.sp,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              'Favourites',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      GestureDetector(
                        onTap: () {
                          _showSurahPicker(context, provider);
                        },
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
                  // SURAH TITLE
                  HeaderText(text: surahTitle),
                  SizedBox(height: 6.h),
                  // SURAH SUBTITLE
                  Text(
                    surahSubtitle,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: context.textSecondary,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  // SEARCH
                  GestureDetector(
                    onTap: () {
                      _showSurahPicker(context, provider);
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _searchController,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: context.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search Surah or Verse...',
                          hintStyle: TextStyle(
                            fontSize: 13.sp,
                            color: context.textMuted,
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: context.textMuted,
                            size: 20.sp,
                          ),
                          filled: true,
                          fillColor: context.textMuted.withValues(alpha: 0.07),
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
                            borderSide: BorderSide(
                              color: context.accent,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // LOADING
                  if (isLoading)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: context.primary,
                        ),
                      ),
                    )
                  // ERROR
                  else if (isError)
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: context.card,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.cloud_off_rounded,
                            size: 36.sp,
                            color: context.textMuted,
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            provider.errorMessage ?? 'Could not load verses.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: context.textSecondary,
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
                            onPressed: () {
                              provider.fetchSurah(currentSurahNumber);
                            },
                            child: const Text(
                              'Retry',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    )
                  // AYAH LIST
                  else if (ayahs.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      child: Center(
                        child: Text(
                          'No verses available.',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: context.textSecondary,
                          ),
                        ),
                      ),
                    )
                  else
                    ...ayahs.map((ayah) {
                      final isSelected =
                          _selectedSurahNumber == currentSurahNumber &&
                          _selectedAyahNumber == ayah.numberInSurah;
                      return Column(
                        children: [
                          // AYAH CARD
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              _selectAyah(
                                surahNumber: currentSurahNumber,
                                ayahNumber: ayah.numberInSurah,
                              );
                            },
                            child: Consumer<FavoritesProvider>(
                              builder: (context, favorites, child) {
                                final isFavorite = favorites.isAyahFavorite(
                                  surahNumber: currentSurahNumber,
                                  ayahNumber: ayah.numberInSurah,
                                );
                                return AyahCard(
                                  ayahNumber: ayah.numberInSurah,
                                  arabicText: ayah.arabicText,
                                  translation: ayah.translation,
                                  isBookmarked: isFavorite,
                                  onBookmarkTap: () {
                                    favorites.toggleAyahFavorite(
                                      FavoriteAyah(
                                        surahNumber: currentSurahNumber,
                                        surahName: currentSurahName,
                                        ayahNumber: ayah.numberInSurah,
                                        arabic: ayah.arabicText,
                                        translation: ayah.translation,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),

                          // SELECTED AYAH INDICATOR
                          if (isSelected)
                            Padding(
                              padding: EdgeInsets.only(top: 6.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.graphic_eq_rounded,
                                    size: 14.sp,
                                    color: context.accent,
                                  ),
                                  SizedBox(width: 5.w),
                                  Text(
                                    'Selected Ayah ${ayah.numberInSurah}',
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                      color: context.accent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(height: 18.h),
                        ],
                      );
                    }),
                ],
              ),
              // FLOATING QURAN PLAYER
              Positioned(
                left: 20.w,
                right: 20.w,
                bottom: 16.h,
                child: QuranPlayer(
                  surahName: surahTitle,
                  // This is the Ayah selected by the user.
                  ayahNumber: _selectedAyahNumber,
                  reciterName: 'Mishary Rashid Alafasy',
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
