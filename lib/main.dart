import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:system_tray/system_tray.dart';
import 'package:window_manager/window_manager.dart';
import 'services/database_service.dart';
import 'services/notification_service.dart';
import 'services/settings_service.dart';
import 'services/home_widget_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(800, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  await _initializeServices();
  await HomeWidgetService.updateWidget();
  await _setupPlatformSpecifics();

  runApp(const MyApp());
}

Future<void> _initializeServices() async {
  await SettingsService.init();
  await DatabaseService.init();
  await NotificationService.init();
}

Future<void> _setupPlatformSpecifics() async {
  if (kIsWeb) return;

  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    final SystemTray systemTray = SystemTray();
    final Menu menu = Menu();

    await systemTray.initSystemTray(
      iconPath: 'assets/icon/icon.ico',
      toolTip: "Subscription Guardian",
    );

    await menu.buildFrom([
      MenuItemLabel(label: 'Show', onClicked: (menuItem) => windowManager.show()),
      MenuItemLabel(label: 'Hide', onClicked: (menuItem) => windowManager.hide()),
      MenuItemLabel(label: 'Exit', onClicked: (menuItem) => windowManager.close()),
    ]);

    await systemTray.setContextMenu(menu);

    systemTray.registerSystemTrayEventHandler((eventName) {
      if (eventName == kSystemTrayEventClick) {
        windowManager.show();
      } else if (eventName == kSystemTrayEventRightClick) {
        systemTray.popUpContextMenu();
      }
    });
  } else {
    await NotificationService.scheduleAllReminderNotifications();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WindowListener {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _updateThemeMode(SettingsService.themeModeString);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
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

  @override
  void onWindowClose() {
    windowManager.hide();
  }
}