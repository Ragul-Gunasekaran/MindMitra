import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  final Color? colorBackground;
  final Color? colorUnselectedItem;
  final Color? colorSelectedItem;
  final Function(int)? function;
  final int selectedIndex;
  
  const BottomNav({
      super.key,
      required this.colorBackground,
      required this.colorUnselectedItem,
      required this.colorSelectedItem,
      required this.function,
      required this.selectedIndex});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: widget.colorBackground,
      unselectedItemColor: widget.colorUnselectedItem,
      selectedItemColor: widget.colorSelectedItem,
      selectedFontSize: 16,
      unselectedFontSize: 13,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 30),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.videogame_asset, size: 30),
          label: 'Games',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart, size: 30),
          label: 'Progress',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event_note, size: 30),
          label: 'Memory',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, size: 30),
          label: 'Profile',
        ),
      ],
      currentIndex: widget.selectedIndex,
      onTap: (int index) => widget.function!(index),
    );
  }
}
