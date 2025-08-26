import 'package:flutter/material.dart';
import 'services/database_service.dart';
import 'services/notification_service.dart';
import 'services/settings_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services in order
  await SettingsService.init(); // Initialize first
  await DatabaseService.init();
  await NotificationService.init();
  await NotificationService.scheduleAllReminderNotifications();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _updateThemeMode(SettingsService.themeModeString);
  }

  void _updateThemeMode(String modeString) {
    print('Updating theme mode: $modeString');
    setState(() {
      switch (modeString) {
        case 'light':
          _themeMode = ThemeMode.light;
          break;
        case 'dark':
          _themeMode = ThemeMode.dark;
          break;
        case 'amoled':
          _themeMode = ThemeMode.dark; // AMOLED is a dark theme
          break;
        default:
          _themeMode = ThemeMode.system;
          break;
      }
    });
  }

  void _changeTheme(String newThemeString) {
    SettingsService.themeModeString = newThemeString;
    _updateThemeMode(newThemeString);
  }

  @override
  Widget build(BuildContext context) {
    final isAmoled = SettingsService.themeModeString == 'amoled';

    return MaterialApp(
      title: 'Subscription Guardian',
      themeMode: _themeMode,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: isAmoled
          ? ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
              ).copyWith(background: Colors.black),
              scaffoldBackgroundColor: Colors.black,
            )
          : ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
              ),
            ),
      home: HomeScreen(onThemeChanged: _changeTheme),
      debugShowCheckedModeBanner: false,
    );
  }
}