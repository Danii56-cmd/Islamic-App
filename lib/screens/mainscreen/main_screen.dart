import 'package:flutter/material.dart';
import 'package:islamic_app/screens/home/home_screen.dart';
import 'package:islamic_app/screens/more/more_screens.dart';
import 'package:islamic_app/screens/prayers/prayers_screen.dart';
import 'package:islamic_app/screens/quran/quran_screen.dart';
import 'package:islamic_app/widgets/bottomnav.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Which "sub-view" is showing inside the Prayer tab (index 2) and the
  // Quran tab (index 1). These live here, not inside PrayersScreen /
  // QuranScreen, so that HomeScreen can also control them -- that's what
  // lets tapping a Home container land on the right sub-view *and* the
  // right bottom-nav tab at the same time.
  bool _prayerShowQibla = false;
  bool _quranShowDuas = false;

  /// Plain tab switch -- used by BottomNav and by Home containers that map
  /// 1:1 to a tab with no sub-view (e.g. the Quran container).
  void _goToTab(int index) {
    setState(() => _currentIndex = index);
  }

  /// Jump straight to the Qibla compass, inside the Prayer tab (index 2).
  void _openQiblaOnPrayerTab() {
    setState(() {
      _currentIndex = 2;
      _prayerShowQibla = true;
    });
  }

  /// Jump straight to Duas, inside the Quran tab (index 1).
  void _openDuasOnQuranTab() {
    setState(() {
      _currentIndex = 1;
      _quranShowDuas = true;
    });
  }

  void _closeQibla() => setState(() => _prayerShowQibla = false);

  void _closeDuas() => setState(() => _quranShowDuas = false);

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(
        onNavigateToTab: _goToTab,
        onOpenQibla: _openQiblaOnPrayerTab,
        onOpenDuas: _openDuasOnQuranTab,
      ),
      QuranScreen(showDuas: _quranShowDuas, onCloseDuas: _closeDuas),
      PrayersScreen(
        showQibla: _prayerShowQibla,
        onOpenQibla: _openQiblaOnPrayerTab,
        onCloseQibla: _closeQibla,
      ), // Index 2: Prayer Screen
      const MoreScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: _goToTab,
      ),
    );
  }
}
