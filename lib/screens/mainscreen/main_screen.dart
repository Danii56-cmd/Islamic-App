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

  final List<Widget> _screens = const [
    HomeScreen(),
    QuranScreen(),
    PrayersScreen(), // Index 2: Prayer Screen
    MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
