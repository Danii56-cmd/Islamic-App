import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:islamic_app/screens/home/home_screen.dart';
import 'package:islamic_app/screens/more/more_screens.dart';
import 'package:islamic_app/screens/prayers/prayers_screen.dart';
import 'package:islamic_app/screens/quran/quran_screen.dart';
import 'package:islamic_app/providers/location_provider.dart';
import 'package:islamic_app/providers/qibla_provider.dart';
import 'package:islamic_app/widgets/bottomnav.dart';
import 'package:islamic_app/widgets/custom_pop_scope.dart';
import 'package:provider/provider.dart';

/// Global callback used by the common AppBar
VoidCallback? openMoreTab;

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

  // Key to control More tab's internal Navigator
  final GlobalKey<NavigatorState> _moreNavigatorKey =
      GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLocationOnStartup();
    });
  }

  Future<void> _checkLocationOnStartup() async {
    try {
      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        if (!mounted) return;
        context.read<LocationProvider>().fetchLocation();
        context.read<QiblaProvider>().checkAndFetchLocation();
      }
    } catch (_) {}
  }




  void _goToTab(int index) {
    if (index < 0 || index > 3) return;

    setState(() {
      _currentIndex = index;
    });
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
    setState(() {
      _currentIndex = 3;
    });
  }

  void _closeCalendar() {
    setState(() {
      _homeShowCalendar = false;
    });
  }

  void _closeQibla() {
    setState(() {
      _prayerShowQibla = false;
    });
  }

  void _closeDuas() {
    setState(() {
      _quranShowDuas = false;
    });
  }

  bool _onBackPressed() {
    // 1. Close nested Home view
    if (_homeShowCalendar) {
      _closeCalendar();
      return true;
    }

    // 2. Close nested Qibla view
    if (_prayerShowQibla) {
      _closeQibla();
      return true;
    }

    // 3. Close nested Duas view
    if (_quranShowDuas) {
      _closeDuas();
      return true;
    }

    // 4. Pop More's nested screen
    if (_currentIndex == 3 &&
        (_moreNavigatorKey.currentState?.canPop() ?? false)) {
      _moreNavigatorKey.currentState!.pop();
      return true;
    }

    // 5. Go back to Home
    if (_currentIndex != 0) {
      _goToTab(0);
      return true;
    }

    // 6. Let CustomPopScope handle exit
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // Register the AppBar's Settings action
    openMoreTab = _openMoreTab;

    final List<Widget> screens = [
      HomeScreen(
        showCalendar: _homeShowCalendar,
        onCloseCalendar: _closeCalendar,
        onNavigateToTab: _goToTab,
        onOpenCalendar: _openCalendarOnHomeTab,
        onOpenQibla: _openQiblaOnPrayerTab,
        onOpenDuas: _openDuasOnQuranTab,
      ),

      QuranScreen(showDuas: _quranShowDuas, onCloseDuas: _closeDuas),

      PrayersScreen(
        showQibla: _prayerShowQibla,
        onOpenQibla: _openQiblaOnPrayerTab,
        onCloseQibla: _closeQibla,
      ),

      MoreScreen(navigatorKey: _moreNavigatorKey),
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
