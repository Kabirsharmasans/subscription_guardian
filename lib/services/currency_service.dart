import 'package:hive_flutter/hive_flutter.dart';

class CurrencyService {
  static const String _settingsBoxName = 'settings';
  static Box? _settingsBox;

  static Future<void> init() async {
    _settingsBox = await Hive.openBox(_settingsBoxName);
  }

  static Box get _box {
    if (_settingsBox == null) {
      throw Exception('CurrencyService not initialized.');
    }
    return _settingsBox!;
  }

  // --- Primary Currency ---
  static String getPrimaryCurrency() {
    return _box.get('primaryCurrency', defaultValue: 'USD');
  }

  static Future<void> setPrimaryCurrency(String currencyCode) async {
    await _box.put('primaryCurrency', currencyCode);
  }

  // --- Conversion Rates ---
  static Map<String, double> getConversionRates() {
    final rates = _box.get(
      'conversionRates',
      defaultValue: <String, dynamic>{},
    );
    // Ensure the values are doubles
    return Map<String, double>.from(
      rates.map((key, value) => MapEntry(key, (value as num).toDouble())),
    );
  }

  static Future<void> setConversionRate(
    String currencyCode,
    double rate,
  ) async {
    final rates = getConversionRates();
    rates[currencyCode] = rate;
    await _box.put('conversionRates', rates);
  }

  static Future<void> removeConversionRate(String currencyCode) async {
    final rates = getConversionRates();
    rates.remove(currencyCode);
    await _box.put('conversionRates', rates);
  }

  // --- Conversion Logic ---
  static double convert(double amount, String fromCurrency) {
    final primary = getPrimaryCurrency();
    if (fromCurrency == primary) {
      return amount;
    }

    final rates = getConversionRates();
    final rate = rates[fromCurrency];

    if (rate == null) {
      // If no rate is set, assume a 1:1 conversion
      return amount;
    }

    return amount * rate;
  }
}
