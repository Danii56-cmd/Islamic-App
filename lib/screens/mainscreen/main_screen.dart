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
  bool _prayerShowQibla = false;
  bool _quranShowDuas = false;
  bool _homeShowCalendar = false;

  void _goToTab(int index) {
    if (index < 0 || index > 3) return;
    setState(() => _currentIndex = index);
  }

  // Jump straight to the Calendar, inside the Home tab (index 0).
  void _openCalendarOnHomeTab() {
    setState(() {
      _currentIndex = 0;
      _homeShowCalendar = true;
    });
  }

  // Jump straight to the Qibla compass, inside the Prayer tab (index 2).
  void _openQiblaOnPrayerTab() {
    setState(() {
      _currentIndex = 2;
      _prayerShowQibla = true;
    });
  }

  // Jump straight to Duas, inside the Quran tab (index 1).
  void _openDuasOnQuranTab() {
    setState(() {
      _currentIndex = 1;
      _quranShowDuas = true;
    });
  }

  // Jump straight to the More tab (index 3). No sub-view involved here —

  void _openMoreTab() {
    setState(() {
      _currentIndex = 3;
    });
  }

  void _closeCalendar() {
    setState(() {
      _homeShowCalendar = false;
    });
  }

  void _closeQibla() => setState(() => _prayerShowQibla = false);
  void _closeDuas() => setState(() => _quranShowDuas = false);

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
