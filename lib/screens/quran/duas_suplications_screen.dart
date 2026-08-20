import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:islamic_app/core/appcolors.dart';
import 'package:islamic_app/models/dua_model.dart';
import 'package:islamic_app/providers/duas_provider.dart';
import 'package:islamic_app/widgets/appbar.dart';

class DuasScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const DuasScreen({super.key, this.onBack});

  @override
  State<DuasScreen> createState() => _DuasScreenState();
}

class _DuasScreenState extends State<DuasScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: const Appbar(),
      body: SafeArea(
        child: Consumer<DuasProvider>(
          builder: (context, provider, _) {
            final isLoading = provider.status == DuasLoadStatus.loading;
            final isError = provider.status == DuasLoadStatus.error;
            final categories = provider.categories;
            final selectedCategory = provider.selectedCategory;
            final duas = provider.filteredDuas;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 6.h),

                // Back button + Title
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                      if (widget.onBack != null) ...[
                        InkWell(
                          onTap: widget.onBack,
                          borderRadius: BorderRadius.circular(20.r),
                          child: Container(
                            padding: EdgeInsets.all(10.r),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF2F4F3),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 16.sp,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                      ],
                      Expanded(
                        child: Text(
                          "Duas & Supplications",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12.h),

                // Search field
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => provider.search(v),
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search Duas by title or meaning...',
                      hintStyle: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textMuted,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: AppColors.textMuted,
                        size: 20.sp,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear_rounded,
                                color: AppColors.textMuted,
                                size: 18.sp,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                provider.search('');
                                setState(() {});
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: AppColors.textMuted.withValues(alpha: 0.07),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.h),
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

                SizedBox(height: 12.h),

                // Category chips row
                if (categories.isNotEmpty)
                  SizedBox(
                    height: 36.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => SizedBox(width: 8.w),
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        final isSelected = cat == selectedCategory;

                        return GestureDetector(
                          onTap: () {
                            provider.selectCategory(cat);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.divider.withValues(alpha: 0.6),
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.2,
                                        ),
                                        blurRadius: 4.r,
                                        offset: Offset(0, 2.h),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Center(
                              child: Text(
                                cat,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? AppColors.textOnPrimary
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                SizedBox(height: 12.h),

                // Duas List
                Expanded(
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        )
                      : isError
                          ? Center(
                              child: Text(
                                provider.errorMessage ??
                                    'Failed to load Duas.',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            )
                          : duas.isEmpty
                              ? Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(32.w),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.search_off_rounded,
                                          size: 48.sp,
                                          color: AppColors.textMuted,
                                        ),
                                        SizedBox(height: 12.h),
                                        Text(
                                          "No Duas found matching your search.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  padding: EdgeInsets.fromLTRB(
                                    20.w,
                                    4.h,
                                    20.w,
                                    24.h,
                                  ),
                                  itemCount: duas.length,
                                  separatorBuilder: (_, __) =>
                                      SizedBox(height: 16.h),
                                  itemBuilder: (context, index) {
                                    final dua = duas[index];
                                    final isFav = provider.isFavorite(dua);

                                    return _DuaCard(
                                      dua: dua,
                                      isFavorite: isFav,
                                      onToggleFavorite: () =>
                                          provider.toggleFavorite(dua),
                                    );
                                  },
                                ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DuaCard extends StatelessWidget {
  final DuaModel dua;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const _DuaCard({
    required this.dua,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 8.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Row: Category tag + Actions
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentLight.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    dua.category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromARGB(255, 120, 95, 0),
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onToggleFavorite,
                  child: Icon(
                    isFavorite ? Icons.bookmark : Icons.bookmark_outline,
                    size: 20.sp,
                    color: isFavorite
                        ? AppColors.primary
                        : AppColors.textMuted,
                  ),
                ),
                SizedBox(width: 12.w),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 1),
                        content: Text('Copied "${dua.title}" to clipboard'),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.share_outlined,
                    size: 20.sp,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // Title
            Text(
              dua.title,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),

            SizedBox(height: 14.h),

            // Arabic Text
            Text(
              dua.arabicText,
              style: TextStyle(
                fontSize: 22.sp,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontFamily: 'Amiri',
                height: 1.8,
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),

            if (dua.transliteration.isNotEmpty) ...[
              SizedBox(height: 12.h),
              Text(
                dua.transliteration,
                style: TextStyle(
                  fontSize: 12.5.sp,
                  fontStyle: FontStyle.italic,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],

            SizedBox(height: 10.h),

            // Translation
            Text(
              dua.translation,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textPrimary.withValues(alpha: 0.9),
                height: 1.5,
              ),
            ),

            SizedBox(height: 12.h),

            // Reference
            Row(
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  size: 14.sp,
                  color: AppColors.accent,
                ),
                SizedBox(width: 6.w),
                Flexible(
                  child: Text(
                    dua.reference,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
