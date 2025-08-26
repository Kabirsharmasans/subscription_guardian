import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static late SharedPreferences prefs;

  static const String _notificationsEnabledKey = 'notificationsEnabled';
  static const String _reminderDaysKey = 'reminderDays';
  static const String _reminderDaysListKey = 'reminderDaysList';
  static const String _defaultCurrencyKey = 'defaultCurrency';
  static const String _themeModeKey = 'themeMode';
  static const String _firstLaunchKey = 'isFirstLaunch';
  static const String _showMonthlyTotalKey = 'showMonthlyTotal';
  static const String _defaultSortKey = 'defaultSort';

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  // Notification Settings
  static bool get notificationsEnabled => prefs.getBool(_notificationsEnabledKey) ?? true;
  static set notificationsEnabled(bool value) => prefs.setBool(_notificationsEnabledKey, value);

  static int get reminderDays => prefs.getInt(_reminderDaysKey) ?? 3;
  static set reminderDays(int value) => prefs.setInt(_reminderDaysKey, value);

  static List<String> get reminderDaysList => prefs.getStringList(_reminderDaysListKey) ?? ['3 days'];
  static set reminderDaysList(List<String> value) => prefs.setStringList(_reminderDaysListKey, value);

  // Currency Settings
  static String get defaultCurrency => prefs.getString(_defaultCurrencyKey) ?? 'USD';
  static set defaultCurrency(String value) => prefs.setString(_defaultCurrencyKey, value);

  // Theme Settings
  static String get themeModeString {
    final storedMode = prefs.getString(_themeModeKey) ?? 'system';
    if (storedMode == 'custom') {
      return 'system'; // Fallback if custom theme is no longer supported
    }
    return storedMode;
  }
  static set themeModeString(String mode) => prefs.setString(_themeModeKey, mode);

  // App State Settings
  static bool get isFirstLaunch => prefs.getBool(_firstLaunchKey) ?? true;
  static set isFirstLaunch(bool value) => prefs.setBool(_firstLaunchKey, value);

  static bool get showMonthlyTotal => prefs.getBool(_showMonthlyTotalKey) ?? true;
  static set showMonthlyTotal(bool value) => prefs.setBool(_showMonthlyTotalKey, value);

  // Sorting Settings
  static String get defaultSort => prefs.getString(_defaultSortKey) ?? 'renewalDate';
  static set defaultSort(String value) => prefs.setString(_defaultSortKey, value);

  // Utility methods
  static Future<void> resetAllSettings() async {
    await prefs.clear();
  }

  static Map<String, dynamic> exportSettings() {
    return {
      'notifications_enabled': notificationsEnabled,
      'reminder_days': reminderDays,
      'reminder_days_list': reminderDaysList,
      'default_currency': defaultCurrency,
      'theme_mode': themeModeString,
      'show_monthly_total': showMonthlyTotal,
      'default_sort': defaultSort,
    };
  }

  static Future<void> importSettings(Map<String, dynamic> settings) async {
    if (settings.containsKey('notifications_enabled')) {
      notificationsEnabled = settings['notifications_enabled'] as bool;
    }
    if (settings.containsKey('reminder_days')) {
      reminderDays = settings['reminder_days'] as int;
    }
    if (settings.containsKey('reminder_days_list')) {
      reminderDaysList = List<String>.from(settings['reminder_days_list']);
    }
    if (settings.containsKey('default_currency')) {
      defaultCurrency = settings['default_currency'] as String;
    }
    if (settings.containsKey('theme_mode')) {
      themeModeString = settings['theme_mode'] as String;
    }
    if (settings.containsKey('show_monthly_total')) {
      showMonthlyTotal = settings['show_monthly_total'] as bool;
    }
    if (settings.containsKey('default_sort')) {
      defaultSort = settings['default_sort'] as String;
    }
  }
}
