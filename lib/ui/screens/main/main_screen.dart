import 'package:flutter/material.dart';
import '../home_tab.dart';
import '../live_tab.dart';
import '../search_screen.dart';
import '../setting_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;
  final _pages = [
    const HomeTab(),
    const SearchTab(),
    LiveTab(),
    SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_index]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: 'Live'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
