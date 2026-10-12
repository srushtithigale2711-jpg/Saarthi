import 'package:flutter/material.dart';

import 'explore_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'saved_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState
    extends State<MainNavigationScreen> {
  int currentIndex = 0;

  late final List<Widget> screens = [
    const HomePage(),
    const ExploreScreen(),

    // Saved screen with Explore navigation callback
    SavedScreen(
      onExploreDestinations: () {
        setState(() {
          currentIndex = 1;
        });
      },
    ),

    const ProfileScreen(),
  ];

  void onNavigationTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FE),

      // ========================================================
      // MAIN CONTENT
      // ========================================================

      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),

      // ========================================================
      // SINGLE BOTTOM NAVIGATION
      // ========================================================

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onNavigationTap,

        selectedItemColor: const Color(0xFF1565C0),
        unselectedItemColor: Colors.grey,

        type: BottomNavigationBarType.fixed,

        backgroundColor: Colors.white,
        elevation: 8,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Explore',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Saved',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}