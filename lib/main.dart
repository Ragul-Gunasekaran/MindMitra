import 'package:flutter/material.dart';
import 'widget/bottom_nav.dart';
import 'core/theme/app_theme.dart';
import 'screens/home_dashboard.dart';
import 'screens/games_dashboard.dart';
import 'screens/wellness_dashboard.dart';
import 'screens/routine_dashboard.dart';

import 'screens/profile_dashboard.dart';
import 'services/storage_service.dart';

void main() {
  runApp(const MyApp());
}

import 'core/config/accessibility.dart';
import 'services/sync_manager.dart';
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AccessibilityConfig(),
      builder: (context, child) {
        return MaterialApp(
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(AccessibilityConfig().textScaleFactor),
                boldText: AccessibilityConfig().highContrast,
              ),
              child: child!,
            );
          },
      title: 'MindMitra',
      debugShowCheckedModeBanner: false,
      theme: AccessibilityConfig().highContrast ? AppTheme.highContrastTheme : AppTheme.lightTheme,
      home: const MyHomePage(title: 'MindMitra'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
  List<Widget> widgetOptions = [
    const HomeDashboard(),
    const GamesDashboard(),
    const RoutineDashboard(),
    const WellnessDashboard(),
    const ProfileDashboard(),
  ];

  @override
  void initState() {
    super.initState();
    
    AccessibilityConfig().init();
    StorageService().init();
    import('services/sync_manager.dart').then((m) => m.SyncManager().init());

  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: false,
      ),
      body: widgetOptions.elementAt(selectedIndex),
      bottomNavigationBar: BottomNav(
        colorBackground: AppTheme.primaryOrange,
        colorSelectedItem: Colors.black,
        colorUnselectedItem: Colors.white,
        function: (int index) => _onItemTapped(index),
        selectedIndex: selectedIndex,
      ),
    );
  }
}
