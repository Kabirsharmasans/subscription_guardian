import 'package:flutter/material.dart';
import 'subcriptions_screen.dart';
import 'cancellation_guide_screen.dart';
import 'about_screen.dart';
import 'settings_screen.dart';
import 'dashboard_screen.dart';
import '../services/notification_service.dart';
import '../widgets/title_bar.dart';

class HomeScreen extends StatefulWidget {
  final Function(String)? onThemeChanged;

  const HomeScreen({super.key, this.onThemeChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const SubscriptionsScreen(),
      const DashboardScreen(),
      const CancellationGuideScreen(),
      const AboutScreen(),
      SettingsScreen(onThemeChanged: widget.onThemeChanged), // Add the SettingsScreen to the list
    ];
    _requestPermissionsAndScheduleNotifications();
  }

  Future<void> _requestPermissionsAndScheduleNotifications() async {
    try {
      // Request the exact alarm permission on Android
      await NotificationService.requestExactAlarmsPermission();
      // Schedule all notifications after the permission request
      await NotificationService.scheduleAllReminderNotifications();
    } catch (e) {
      print('Error scheduling notifications: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TitleBar(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.subscriptions_outlined),
            selectedIcon: Icon(Icons.subscriptions),
            label: 'Subscriptions',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.cancel_outlined),
            selectedIcon: Icon(Icons.cancel),
            label: 'Freedom Guide',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outlined),
            selectedIcon: Icon(Icons.info),
            label: 'About & Support',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}