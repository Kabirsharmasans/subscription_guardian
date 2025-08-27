import 'package:shared_preferences/shared_preferences.dart';


class SettingsService {
  static SharedPreferences? _prefs;

  // Settings keys
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _reminderDaysListKey = 'reminder_days_list'; // Changed from _reminderDaysKey
  static const String _defaultCurrencyKey = 'default_currency';
  static const String _themeModeKey = 'theme_mode';
  static const String _firstLaunchKey = 'first_launch';
  static const String _showMonthlyTotalKey = 'show_monthly_total';
  static const String _defaultSortKey = 'default_sort';

  // Initialize the service
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception(
          'SettingsService not initialized. Call SettingsService.init() first.');
    }
    return _prefs!;
  }

  // Notification Settings
  static bool get notificationsEnabled =>
      prefs.getBool(_notificationsEnabledKey) ?? true;
  static set notificationsEnabled(bool value) =>
      prefs.setBool(_notificationsEnabledKey, value);

  // New reminderDaysList getter/setter
  static List<String> get reminderDaysList =>
      prefs.getStringList(_reminderDaysListKey) ?? ['3 days', '1 week'];
  static set reminderDaysList(List<String> value) =>
      prefs.setStringList(_reminderDaysListKey, value);

  // Currency Settings
  static String get defaultCurrency =>
      prefs.getString(_defaultCurrencyKey) ?? 'USD';
  static set defaultCurrency(String value) =>
      prefs.setString(_defaultCurrencyKey, value);

  // Theme Settings
  // New themeModeString getter/setter
  static String get themeModeString =>
      prefs.getString(_themeModeKey) ?? 'system';
  static set themeModeString(String value) =>
      prefs.setString(_themeModeKey, value);

  // App State Settings
  static bool get isFirstLaunch => prefs.getBool(_firstLaunchKey) ?? true;
  static set isFirstLaunch(bool value) => prefs.setBool(_firstLaunchKey, value);

  static bool get showMonthlyTotal =>
      prefs.getBool(_showMonthlyTotalKey) ?? true;
  static set showMonthlyTotal(bool value) =>
      prefs.setBool(_showMonthlyTotalKey, value);

  // Sorting Settings
  static String get defaultSort =>
      prefs.getString(_defaultSortKey) ?? 'renewalDate';
  static set defaultSort(String value) =>
      prefs.setString(_defaultSortKey, value);

  // Utility methods
  static Future<void> resetAllSettings() async {
    await prefs.clear();
  }

  static Map<String, dynamic> exportSettings() {
    return {
      'notifications_enabled': notificationsEnabled,
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