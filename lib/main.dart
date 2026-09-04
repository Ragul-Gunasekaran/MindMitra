import 'package:flutter/material.dart';
import 'widget/bottom_nav.dart';
import 'core/theme/app_theme.dart';
import 'core/config/accessibility.dart';
import 'screens/home_dashboard.dart';
import 'screens/games_dashboard.dart';
import 'screens/wellness_dashboard.dart';
import 'screens/routine_dashboard.dart';
import 'screens/profile_dashboard.dart';
import 'screens/auth/login_screen.dart';
import 'services/storage_service.dart';
import 'services/sync_manager.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AccessibilityConfig(),
      builder: (context, child) {
        return MaterialApp(
          title: 'MindMitra',
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(AccessibilityConfig().textScaleFactor),
                boldText: AccessibilityConfig().highContrast,
              ),
              child: child!,
            );
          },
          theme: AccessibilityConfig().highContrast ? AppTheme.highContrastTheme : AppTheme.lightTheme,
          home: const AuthWrapper(),
        );
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  void _initApp() async {
    AccessibilityConfig().init();
    final auth = AuthService();
    final success = await auth.tryAutoLogin();
    if (success) {
      StorageService().init();
      SyncManager().init();
    }
    setState(() {
      _isAuthenticated = success;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return _isAuthenticated ? const MyHomePage(title: 'MindMitra') : const LoginScreen();
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
