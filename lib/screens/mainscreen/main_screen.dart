import 'package:flutter/material.dart';
import 'package:islamic_app/screens/home/home_screen.dart';
import 'package:islamic_app/screens/more/more_screens.dart';
import 'package:islamic_app/screens/prayers/prayers_screen.dart';
import 'package:islamic_app/screens/quran/quran_screen.dart';
import 'package:islamic_app/widgets/bottomnav.dart';
import 'package:islamic_app/widgets/custom_pop_scope.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  bool _prayerShowQibla = false;
  bool _quranShowDuas = false;
  bool _homeShowCalendar = false;

  // Key to control the More tab's own internal Navigator (if it has nested pushes)
  final GlobalKey<NavigatorState> _moreNavigatorKey =
      GlobalKey<NavigatorState>();

  void _goToTab(int index) {
    if (index < 0 || index > 3) return;
    setState(() => _currentIndex = index);
  }

  void _openCalendarOnHomeTab() {
    setState(() {
      _currentIndex = 0;
      _homeShowCalendar = true;
    });
  }

  void _openQiblaOnPrayerTab() {
    setState(() {
      _currentIndex = 2;
      _prayerShowQibla = true;
    });
  }

  void _openDuasOnQuranTab() {
    setState(() {
      _currentIndex = 1;
      _quranShowDuas = true;
    });
  }

  void _openMoreTab() {
    setState(() => _currentIndex = 3);
  }

  void _closeCalendar() => setState(() => _homeShowCalendar = false);
  void _closeQibla() => setState(() => _prayerShowQibla = false);
  void _closeDuas() => setState(() => _quranShowDuas = false);

  /// Returns true if this back press was "consumed" here
  /// (i.e. we handled it and the exit dialog should NOT show).
  bool _onBackPressed() {
    // 1. A nested sub-view is open on the current tab -> close just that.
    if (_homeShowCalendar) {
      _closeCalendar();
      return true;
    }
    if (_prayerShowQibla) {
      _closeQibla();
      return true;
    }
    if (_quranShowDuas) {
      _closeDuas();
      return true;
    }

    // 2. More tab has its own pushed nested screen -> pop just that.
    if (_currentIndex == 3 &&
        (_moreNavigatorKey.currentState?.canPop() ?? false)) {
      _moreNavigatorKey.currentState!.pop();
      return true;
    }

    // 3. We're on a non-home tab with nothing nested open -> jump to Home.
    if (_currentIndex != 0) {
      _goToTab(0);
      return true;
    }

    // 4. We're on Home tab, nothing open -> let CustomPopScope show exit dialog.
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(
        showCalendar: _homeShowCalendar,
        onCloseCalendar: _closeCalendar,
        onNavigateToTab: _goToTab,
        onOpenCalendar: _openCalendarOnHomeTab,
        onOpenQibla: _openQiblaOnPrayerTab,
        onOpenDuas: _openDuasOnQuranTab,
        onOpenMore: _openMoreTab,
      ),
      QuranScreen(showDuas: _quranShowDuas, onCloseDuas: _closeDuas),
      PrayersScreen(
        showQibla: _prayerShowQibla,
        onOpenQibla: _openQiblaOnPrayerTab,
        onCloseQibla: _closeQibla,
      ),
      MoreScreen(navigatorKey: _moreNavigatorKey), // see note below
    ];

    return CustomPopScope(
      isRoot: true,
      onBackPressed: _onBackPressed,
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: screens),
        bottomNavigationBar: BottomNav(
          currentIndex: _currentIndex,
          onTap: _goToTab,
        ),
      ),
    );
  }
}
