import 'package:flutter/material.dart';

import '../theme.dart';
import 'calc_screen.dart';
import 'diary_screen.dart';
import 'home_screen.dart';
import 'placeholder_screen.dart';

/// Нижня навігація з п’яти вкладок (замінює TabNavigator).
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  void _go(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(onNavigate: _go),
          const DiaryScreen(),
          const PlaceholderScreen(title: 'Статистика'),
          const CalcScreen(),
          const PlaceholderScreen(title: 'Релакс'),
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: BottomNavigationBar(
          currentIndex: _index,
          onTap: _go,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.bg,
          selectedItemColor: AppColors.accent,
          unselectedItemColor: AppColors.muted,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Головна'),
            BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Щоденник'),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Статистика'),
            BottomNavigationBarItem(icon: Icon(Icons.access_time_filled), label: 'Розрахунок'),
            BottomNavigationBarItem(icon: Icon(Icons.nightlight_round), label: 'Релакс'),
          ],
        ),
      ),
    );
  }
}
