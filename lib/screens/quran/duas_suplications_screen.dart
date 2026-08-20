import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/widgets/header_text.dart';
import 'package:provider/provider.dart';
import 'package:islamic_app/core/appcolors.dart';
import 'package:islamic_app/core/appconstants.dart';
import 'package:islamic_app/models/dua_model.dart';
import 'package:islamic_app/providers/duas_provider.dart';
import 'package:islamic_app/widgets/appbar.dart';

// Featured category data
class _FeaturedCategory {
  final String label;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final String categoryKey;

  const _FeaturedCategory({
    required this.label,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    required this.categoryKey,
  });
}

final List<_FeaturedCategory> _featuredCategories = [
  _FeaturedCategory(
    label: 'Morning &\nEvening',
    icon: Icons.wb_sunny_outlined,
    bgColor: AppColors.primary,
    iconColor: AppColors.accent,
    categoryKey: 'Morning & Evening',
  ),
  _FeaturedCategory(
    label: 'Travel &\nSafety',
    icon: Icons.flight,
    bgColor: const Color(0xFFF2F4F7),
    iconColor: AppColors.textSecondary,
    categoryKey: 'Travel',
  ),
  _FeaturedCategory(
    label: 'Health &\nSickness',
    icon: Icons.healing,
    bgColor: AppColors.accent,
    iconColor: Colors.white,
    categoryKey: 'Protection',
  ),
  _FeaturedCategory(
    label: 'Anxiety &\nPeace',
    icon: Icons.self_improvement,
    bgColor: const Color(0xFFF2F4F7),
    iconColor: AppColors.textSecondary,
    categoryKey: 'Hardship & Anxiety',
  ),
];

// Main Screen
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
      body: Consumer<DuasProvider>(
        builder: (context, provider, _) {
          final isLoading = provider.status == DuasLoadStatus.loading;
          final isError = provider.status == DuasLoadStatus.error;
          final duas = provider.filteredDuas;

          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (isError) {
            return Center(
              child: Text(
                provider.errorMessage ?? 'Failed to load Duas.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            );
          }

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: _ScreenHeader(
                  onBack: widget.onBack,
                  searchController: _searchController,
                  onSearch: (v) {
                    provider.search(v);
                    setState(() {});
                  },
                  onClear: () {
                    _searchController.clear();
                    provider.search('');
                    setState(() {});
                  },
                ),
              ),

              // Featured Categories
              if (_searchController.text.isEmpty) ...[
                SliverToBoxAdapter(
                  child: _FeaturedCategoriesSection(
                    selectedCategory: provider.selectedCategory,
                    onCategoryTap: (key) {
                      provider.selectCategory(key);
                      setState(() {});
                    },
                  ),
                ),

                // Daily Remembrance label
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 12.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Daily Remembrance',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => provider.selectCategory('All'),
                          child: Text(
                            'View all →',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              // Duas list or empty state
              duas.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
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
                              'No Duas found matching your search.',
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
                  : SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        if (index < duas.length) {
                          final dua = duas[index];
                          return Padding(
                            padding: EdgeInsets.fromLTRB(
                              20.w,
                              index == 0 ? 0 : 16.h,
                              20.w,
                              0,
                            ),
                            child: _DuaCard(
                              dua: dua,
                              isFavorite: provider.isFavorite(dua),
                              onToggleFavorite: () =>
                                  provider.toggleFavorite(dua),
                            ),
                          );
                        }
                        // Featured collection banner at the end
                        return Padding(
                          padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 32.h),
                          child: const _FeaturedCollectionBanner(),
                        );
                      }, childCount: duas.length + 1),
                    ),
            ],
          );
        },
      ),
    );
  }
}

// Screen header: back button + title + subtitle + search
class _ScreenHeader extends StatelessWidget {
  final VoidCallback? onBack;
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;
  final VoidCallback onClear;

  const _ScreenHeader({
    required this.onBack,
    required this.searchController,
    required this.onSearch,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button row (only when onBack is provided)
          if (onBack != null) ...[
            GestureDetector(
              onTap: onBack,
              child: Container(
                padding: EdgeInsets.all(9.r),
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
            SizedBox(height: 14.h),
          ],

          // Title
          HeaderText(text: "Duas & Supplications"),
          SizedBox(height: 6.h),

          // Subtitle
          Text(
            'A curated collection of prophetic prayers for\nevery moment of the believer\'s journey.',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          SizedBox(height: 18.h),

          // Search bar
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 6.r,
                  offset: Offset(0, 2.h),
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              onChanged: onSearch,
              style: TextStyle(fontSize: 13.sp, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search by theme or keyword...',
                hintStyle: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textMuted,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: AppColors.textMuted,
                  size: 20.sp,
                ),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear_rounded,
                          color: AppColors.textMuted,
                          size: 18.sp,
                        ),
                        onPressed: onClear,
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
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
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

// Featured Categories 2×2 grid

class _FeaturedCategoriesSection extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategoryTap;

  const _FeaturedCategoriesSection({
    required this.selectedCategory,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section label
          Row(
            children: [
              Container(
                width: 3.w,
                height: 16.h,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'Featured Categories',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // 2×2 grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _featuredCategories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 1.55,
            ),
            itemBuilder: (context, i) {
              final cat = _featuredCategories[i];
              final isSelected = selectedCategory == cat.categoryKey;
              return _CategoryCard(
                category: cat,
                isSelected: isSelected,
                onTap: () => onCategoryTap(cat.categoryKey),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final _FeaturedCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: category.bgColor,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: category.bgColor == AppColors.primary
                  ? AppColors.primary.withValues(alpha: 0.25)
                  : category.bgColor == AppColors.accent
                  ? AppColors.accent.withValues(alpha: 0.25)
                  : AppColors.shadow,
              blurRadius: 8.r,
              offset: Offset(0, 3.h),
            ),
          ],
          border: isSelected
              ? Border.all(color: AppColors.accent, width: 2)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(category.icon, color: category.iconColor, size: 22.sp),
            Text(
              category.label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color:
                    (category.bgColor == AppColors.primary ||
                        category.bgColor == AppColors.accent)
                    ? Colors.white
                    : AppColors.textPrimary,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dua Card
class _DuaCard extends StatelessWidget {
  final DuaModel dua;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const _DuaCard({
    required this.dua,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(
      ClipboardData(
        text: '${dua.arabicText}\n\n${dua.translation}\n\n— ${dua.reference}',
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Text('Copied "${dua.title}"'),
      ),
    );
  }

  void _shareSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Text('Sharing "${dua.title}"...'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top accent stripe with category tag + bookmark
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.04),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.r),
                topRight: Radius.circular(18.r),
              ),
              border: Border(
                bottom: BorderSide(color: AppColors.divider, width: 0.8),
              ),
            ),
            child: Row(
              children: [
                // Category tag
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: AppColors.accentLight.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    dua.category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF7A5C00),
                      letterSpacing: 0.7,
                    ),
                  ),
                ),
                const Spacer(),
                // Bookmark
                GestureDetector(
                  onTap: onToggleFavorite,
                  child: Icon(
                    isFavorite ? Icons.bookmark : Icons.bookmark_border,
                    size: 19.sp,
                    color: isFavorite ? AppColors.primary : AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  dua.title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 16.h),

                // Arabic text
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    dua.arabicText,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Amiri',
                      color: AppColors.textPrimary,
                      height: 2.0,
                    ),
                  ),
                ),

                // Transliteration
                if (dua.transliteration.isNotEmpty) ...[
                  SizedBox(height: 10.h),
                  Text(
                    dua.transliteration,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
                SizedBox(height: 12.h),

                // Translation
                Text(
                  dua.translation,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textPrimary.withValues(alpha: 0.85),
                    height: 1.55,
                  ),
                ),
                SizedBox(height: 14.h),

                // Divider
                Divider(color: AppColors.divider, height: 1),
                SizedBox(height: 12.h),

                // Reference + actions
                Row(
                  children: [
                    // Reference
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            'Source: ',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textMuted,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              dua.reference,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),

                    // Share button
                    _ActionButton(
                      icon: Icons.share_outlined,
                      label: 'Share',
                      onTap: () => _shareSnackbar(context),
                    ),
                    SizedBox(width: 8.w),

                    // Copy button
                    _ActionButton(
                      icon: Icons.copy_rounded,
                      label: 'Copy',
                      onTap: () => _copyToClipboard(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 14.sp, color: AppColors.textSecondary),
          SizedBox(width: 3.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// Featured Collection Banner (bottom card)
class _FeaturedCollectionBanner extends StatelessWidget {
  const _FeaturedCollectionBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 160.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        image: const DecorationImage(
          image: AssetImage(Appconstants.featuredImage),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.1),
              AppColors.primaryDark.withValues(alpha: 0.88),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Label tag
            Container(
              padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                'FEATURED COLLECTION',
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.7,
                ),
              ),
            ),
            SizedBox(height: 8.h),

            // Title
            Text(
              'Healing &\nRestoration',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.2,
              ),
            ),
            SizedBox(height: 4.h),

            // Subtitle
            Text(
              'Prophetic supplications that provide hope and spiritual wellbeing during trials.',
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.white.withValues(alpha: 0.8),
                height: 1.4,
              ),
            ),
            SizedBox(height: 12.h),

            // CTA button
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text(
                      'This feature will be available in the next update!',
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Explore Collection',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 13.sp,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
