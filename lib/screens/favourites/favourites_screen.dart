import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/theme_extensions.dart';
import 'package:islamic_app/models/favourites_model.dart';
import 'package:islamic_app/providers/favourites_provider.dart';
import 'package:islamic_app/widgets/header_text.dart';
import 'package:provider/provider.dart';

class FavouritesScreen extends StatefulWidget {
  final int initialTabIndex;

  const FavouritesScreen({super.key, this.initialTabIndex = 0});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _copyAyah(BuildContext context, FavoriteAyah ayah) {
    Clipboard.setData(
      ClipboardData(
        text:
            '${ayah.arabic}\n\n'
            '${ayah.translation}\n\n'
            '— Surah ${ayah.surahName}, Ayah ${ayah.ayahNumber}',
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(
          'Copied Surah ${ayah.surahName} [${ayah.ayahNumber}] to clipboard',
        ),
      ),
    );
  }

  void _copyDua(BuildContext context, FavoriteDua dua) {
    Clipboard.setData(
      ClipboardData(
        text:
            '${dua.title}\n\n'
            '${dua.arabic}\n\n'
            '${dua.translation}'
            '${dua.reference.isNotEmpty ? '\n\n— ${dua.reference}' : ''}',
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text('Copied "${dua.title}" to clipboard'),
      ),
    );
  }

  void _shareItem(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Text('Sharing "$title"...'),
      ),
    );
  }

  void _confirmClear(
    BuildContext context,
    FavoritesProvider provider,
    bool isAyahTab,
  ) {
    final title = isAyahTab ? 'Clear Saved Verses?' : 'Clear Saved Duas?';
    final content = isAyahTab
        ? 'Are you sure you want to remove all saved verses from your favourites?'
        : 'Are you sure you want to remove all saved supplications from your favourites?';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.r),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: context.textPrimary,
          ),
        ),
        content: Text(
          content,
          style: TextStyle(
            fontSize: 13.sp,
            color: context.textSecondary,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: context.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            onPressed: () {
              if (isAyahTab) {
                provider.clearAyahs();
              } else {
                provider.clearDuas();
              }
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 2),
                  content: Text(
                    isAyahTab
                        ? 'All saved verses cleared.'
                        : 'All saved duas cleared.',
                  ),
                ),
              );
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    final isAyahTab = _tabController.index == 0;
    final hasItemsInCurrentTab = isAyahTab
        ? favorites.favoriteAyahs.isNotEmpty
        : favorites.favoriteDuas.isNotEmpty;

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        backgroundColor: context.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18.sp,
            color: context.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Saved Favourites',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: context.textPrimary,
          ),
        ),
        actions: [
          if (hasItemsInCurrentTab)
            IconButton(
              icon: Icon(
                Icons.delete_sweep_outlined,
                color: context.textMuted,
                size: 22.sp,
              ),
              tooltip: isAyahTab ? 'Clear Verses' : 'Clear Duas',
              onPressed: () => _confirmClear(context, favorites, isAyahTab),
            ),
          SizedBox(width: 8.w),
        ],
      ),
      body: Column(
        children: [
          // HEADER SUMMARY & SEARCH
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const HeaderText(text: 'My Collection'),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: context.accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        '${favorites.totalFavoritesCount} Total',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: context.accent,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  'Quick access to all your bookmarked verses and prayers.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: context.textSecondary,
                  ),
                ),
                SizedBox(height: 14.h),

                // SEARCH BAR
                Container(
                  decoration: BoxDecoration(
                    color: context.card,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: context.shadow,
                        blurRadius: 6.r,
                        offset: Offset(0, 2.h),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val.trim().toLowerCase();
                      });
                    },
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: context.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search saved items...',
                      hintStyle: TextStyle(
                        fontSize: 13.sp,
                        color: context.textMuted,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: context.textMuted,
                        size: 20.sp,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear_rounded,
                                color: context.textMuted,
                                size: 18.sp,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: context.card,
                      contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 14.h),

                // CUSTOM SEGMENTED TAB BAR
                Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    color: context.textMuted.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: context.primary,
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: [
                        BoxShadow(
                          color: context.primary.withValues(alpha: 0.3),
                          blurRadius: 6.r,
                          offset: Offset(0, 2.h),
                        ),
                      ],
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: context.textSecondary,
                    labelStyle: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.menu_book_rounded, size: 16),
                            SizedBox(width: 6.w),
                            Text('Ayahs (${favorites.favoriteAyahs.length})'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.volunteer_activism_outlined,
                              size: 16,
                            ),
                            SizedBox(width: 6.w),
                            Text('Duas (${favorites.favoriteDuas.length})'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // TAB CONTENT
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _AyahsTabView(
                  searchQuery: _searchQuery,
                  onCopy: (ayah) => _copyAyah(context, ayah),
                  onShare: (ayah) => _shareItem(
                    context,
                    'Surah ${ayah.surahName} [${ayah.ayahNumber}]',
                  ),
                ),
                _DuasTabView(
                  searchQuery: _searchQuery,
                  onCopy: (dua) => _copyDua(context, dua),
                  onShare: (dua) => _shareItem(context, dua.title),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// AYAHS TAB VIEW
class _AyahsTabView extends StatelessWidget {
  final String searchQuery;
  final ValueChanged<FavoriteAyah> onCopy;
  final ValueChanged<FavoriteAyah> onShare;

  const _AyahsTabView({
    required this.searchQuery,
    required this.onCopy,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    final allAyahs = favorites.favoriteAyahs;

    final ayahs = searchQuery.isEmpty
        ? allAyahs
        : allAyahs.where((ayah) {
            return ayah.surahName.toLowerCase().contains(searchQuery) ||
                ayah.translation.toLowerCase().contains(searchQuery) ||
                ayah.arabic.contains(searchQuery) ||
                '${ayah.ayahNumber}'.contains(searchQuery);
          }).toList();

    if (allAyahs.isEmpty) {
      return _EmptyStateView(
        icon: Icons.bookmark_border_rounded,
        title: 'No Saved Verses',
        subtitle:
            'Tap the bookmark icon on any Quran verse to save it for quick reference and reflection.',
        buttonLabel: 'Explore Holy Quran',
        onButtonTap: () => Navigator.pop(context),
      );
    }

    if (ayahs.isEmpty) {
      return Center(
        child: Text(
          'No saved verses match "$searchQuery"',
          style: TextStyle(fontSize: 14.sp, color: context.textSecondary),
        ),
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 30.h),
      itemCount: ayahs.length,
      separatorBuilder: (_, __) => SizedBox(height: 14.h),
      itemBuilder: (context, index) {
        final ayah = ayahs[index];
        return _FavoriteAyahCard(
          ayah: ayah,
          onCopy: () => onCopy(ayah),
          onShare: () => onShare(ayah),
          onRemove: () => favorites.removeAyah(ayah),
        );
      },
    );
  }
}

// DUAS TAB VIEW
class _DuasTabView extends StatelessWidget {
  final String searchQuery;
  final ValueChanged<FavoriteDua> onCopy;
  final ValueChanged<FavoriteDua> onShare;

  const _DuasTabView({
    required this.searchQuery,
    required this.onCopy,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    final allDuas = favorites.favoriteDuas;

    final duas = searchQuery.isEmpty
        ? allDuas
        : allDuas.where((dua) {
            return dua.title.toLowerCase().contains(searchQuery) ||
                dua.translation.toLowerCase().contains(searchQuery) ||
                dua.category.toLowerCase().contains(searchQuery) ||
                dua.arabic.contains(searchQuery);
          }).toList();

    if (allDuas.isEmpty) {
      return _EmptyStateView(
        icon: Icons.volunteer_activism_outlined,
        title: 'No Saved Duas',
        subtitle:
            'Bookmark your beloved supplications to easily recite and remember them anytime.',
        buttonLabel: 'Browse Duas',
        onButtonTap: () => Navigator.pop(context),
      );
    }

    if (duas.isEmpty) {
      return Center(
        child: Text(
          'No saved duas match "$searchQuery"',
          style: TextStyle(fontSize: 14.sp, color: context.textSecondary),
        ),
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 30.h),
      itemCount: duas.length,
      separatorBuilder: (_, __) => SizedBox(height: 14.h),
      itemBuilder: (context, index) {
        final dua = duas[index];
        return _FavoriteDuaCard(
          dua: dua,
          onCopy: () => onCopy(dua),
          onShare: () => onShare(dua),
          onRemove: () => favorites.removeDua(dua),
        );
      },
    );
  }
}

// FAVORITE AYAH CARD
class _FavoriteAyahCard extends StatelessWidget {
  final FavoriteAyah ayah;
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final VoidCallback onRemove;

  const _FavoriteAyahCard({
    required this.ayah,
    required this.onCopy,
    required this.onShare,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: context.shadow,
            blurRadius: 8.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // CARD HEADER
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: context.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.r),
                topRight: Radius.circular(18.r),
              ),
              border: Border(
                bottom: BorderSide(color: context.divider, width: 0.8),
              ),
            ),
            child: Row(
              children: [
                // SURAH BADGE
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: context.accent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Surah ${ayah.surahName} • Ayah ${ayah.ayahNumber}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: context.isDark
                          ? const Color(0xFFE7C96F)
                          : const Color(0xFF7A5C00),
                    ),
                  ),
                ),
                const Spacer(),
                // REMOVE BUTTON
                GestureDetector(
                  onTap: onRemove,
                  child: Icon(
                    Icons.bookmark,
                    size: 20.sp,
                    color: context.primary,
                  ),
                ),
              ],
            ),
          ),

          // CARD BODY
          Padding(
            padding: EdgeInsets.fromLTRB(18.w, 14.h, 18.w, 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ARABIC TEXT
                Text(
                  ayah.arabic,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Amiri',
                    color: context.textPrimary,
                    height: 2.0,
                  ),
                ),
                SizedBox(height: 12.h),

                // TRANSLATION
                Text(
                  ayah.translation,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: context.textSecondary,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 14.h),
                Divider(color: context.divider, height: 1),
                SizedBox(height: 10.h),

                // ACTION BAR
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _CardActionButton(
                      icon: Icons.share_outlined,
                      label: 'Share',
                      onTap: onShare,
                    ),
                    SizedBox(width: 14.w),
                    _CardActionButton(
                      icon: Icons.copy_rounded,
                      label: 'Copy',
                      onTap: onCopy,
                    ),
                    SizedBox(width: 14.w),
                    _CardActionButton(
                      icon: Icons.delete_outline_rounded,
                      label: 'Remove',
                      color: Colors.red.shade400,
                      onTap: onRemove,
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

// FAVORITE DUA CARD
class _FavoriteDuaCard extends StatelessWidget {
  final FavoriteDua dua;
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final VoidCallback onRemove;

  const _FavoriteDuaCard({
    required this.dua,
    required this.onCopy,
    required this.onShare,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: context.shadow,
            blurRadius: 8.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // CARD HEADER
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: context.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.r),
                topRight: Radius.circular(18.r),
              ),
              border: Border(
                bottom: BorderSide(color: context.divider, width: 0.8),
              ),
            ),
            child: Row(
              children: [
                if (dua.category.isNotEmpty) ...[
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: context.accentLight.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      dua.category.toUpperCase(),
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w800,
                        color: context.isDark
                            ? const Color(0xFFE7C96F)
                            : const Color(0xFF7A5C00),
                        letterSpacing: 0.7,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                ],
                Expanded(
                  child: Text(
                    dua.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: context.textPrimary,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onRemove,
                  child: Icon(
                    Icons.bookmark,
                    size: 20.sp,
                    color: context.primary,
                  ),
                ),
              ],
            ),
          ),

          // CARD BODY
          Padding(
            padding: EdgeInsets.fromLTRB(18.w, 14.h, 18.w, 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ARABIC TEXT
                Text(
                  dua.arabic,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Amiri',
                    color: context.textPrimary,
                    height: 2.0,
                  ),
                ),
                SizedBox(height: 12.h),

                // TRANSLATION
                Text(
                  dua.translation,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: context.textSecondary,
                    height: 1.5,
                  ),
                ),

                if (dua.reference.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Text(
                    '— ${dua.reference}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontStyle: FontStyle.italic,
                      color: context.textMuted,
                    ),
                  ),
                ],

                SizedBox(height: 14.h),
                Divider(color: context.divider, height: 1),
                SizedBox(height: 10.h),

                // ACTION BAR
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _CardActionButton(
                      icon: Icons.share_outlined,
                      label: 'Share',
                      onTap: onShare,
                    ),
                    SizedBox(width: 14.w),
                    _CardActionButton(
                      icon: Icons.copy_rounded,
                      label: 'Copy',
                      onTap: onCopy,
                    ),
                    SizedBox(width: 14.w),
                    _CardActionButton(
                      icon: Icons.delete_outline_rounded,
                      label: 'Remove',
                      color: Colors.red.shade400,
                      onTap: onRemove,
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

// CARD ACTION BUTTON
class _CardActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _CardActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final clr = color ?? context.textSecondary;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: clr),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: clr,
            ),
          ),
        ],
      ),
    );
  }
}

// EMPTY STATE VIEW
class _EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onButtonTap;

  const _EmptyStateView({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 20.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72.r,
              height: 72.r,
              decoration: BoxDecoration(
                color: context.textMuted.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 36.sp, color: context.primary),
            ),
            SizedBox(height: 18.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: context.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5.sp,
                color: context.textSecondary,
                height: 1.5,
              ),
            ),
            SizedBox(height: 22.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                elevation: 2,
              ),
              onPressed: onButtonTap,
              child: Text(
                buttonLabel,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
