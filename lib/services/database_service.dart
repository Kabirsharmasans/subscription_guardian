import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/subscription.dart';
import '../models/category.dart';

class DatabaseService {
  static const String _subscriptionsBoxName = 'subscriptions';
  static const String _categoriesBoxName = 'categories';
  static Box<Subscription>? _subscriptionsBox;
  static Box<Category>? _categoriesBox;

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(SubscriptionAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(CategoryAdapter());
    }

    // Open boxes
    _subscriptionsBox = await Hive.openBox<Subscription>(_subscriptionsBoxName);
    _categoriesBox = await Hive.openBox<Category>(_categoriesBoxName);
    _seedInitialCategories();
  }

  static Box<Subscription> get subscriptionsBox {
    if (_subscriptionsBox == null) {
      throw Exception(
          'Database not initialized. Call DatabaseService.init() first.');
    }
    return _subscriptionsBox!;
  }

  static Box<Category> get categoriesBox {
    if (_categoriesBox == null) {
      throw Exception(
          'Database not initialized. Call DatabaseService.init() first.');
    }
    return _categoriesBox!;
  }

  static void _seedInitialCategories() {
    if (categoriesBox.isEmpty) {
      final initialCategories = [
        Category(id: 'entertainment', name: 'Entertainment'),
        Category(id: 'work', name: 'Work'),
        Category(id: 'utilities', name: 'Utilities'),
        Category(id: 'music', name: 'Music'),
        Category(id: 'other', name: 'Other'),
      ];
      for (var category in initialCategories) {
        categoriesBox.put(category.id, category);
      }
    }
  }

  // Category operations
  static Future<void> addCategory(Category category) async {
    await categoriesBox.put(category.id, category);
  }

  static Future<void> updateCategory(Category category) async {
    await categoriesBox.put(category.id, category);
  }

  static Future<void> deleteCategory(String id) async {
    await categoriesBox.delete(id);
  }

  // Subscription operations
  static Future<void> addSubscription(Subscription subscription) async {
    await subscriptionsBox.put(subscription.id, subscription);
  }

  static Future<void> updateSubscription(Subscription subscription) async {
    await subscriptionsBox.put(subscription.id, subscription);
  }

  static Future<void> deleteSubscription(String id) async {
    await subscriptionsBox.delete(id);
  }

  static List<Subscription> getAllSubscriptions() {
    return subscriptionsBox.values.where((sub) => sub.isActive).toList();
  }

  static List<Category> getAllCategories() {
    return categoriesBox.values.toList();
  }

  static Subscription? getSubscription(String id) {
    return subscriptionsBox.get(id);
  }

  static List<Subscription> getUpcomingRenewals(int daysAhead) {
    final subscriptions = getAllSubscriptions();
    return subscriptions
        .where((sub) => sub.getDaysUntilRenewal() <= daysAhead)
        .toList();
  }

  // Brand colors map - comprehensive list of streaming service brand colors
  static Map<String, Color> getBrandColors() {
    return {
      // Global / Cross-Region
      'netflix': const Color(0xFFE50914),
      'amazon prime video': const Color(0xFF00A8E1),
      'disney+': const Color(0xFF1139AB),
      'apple tv+': const Color(0xFF000000),
      'max': const Color(0xFF6633FF),
      'hulu': const Color(0xFF1CE783),
      'paramount+': const Color(0xFF0064FF),
      'peacock': const Color(0xFF000000),
      'youtube premium': const Color(0xFFFF0000),
      'youtube tv': const Color(0xFFFF0000),
      'sling tv': const Color(0xFFF26B3A),
      'fubo': const Color(0xFFF7941D),
      'philo': const Color(0xFFDA002A),
      'directv stream': const Color(0xFF00A6D6),
      'espn+': const Color(0xFFCD0001),
      'starz': const Color(0xFFD92128),
      'mgm+': const Color(0xFFB7A667),
      'amc+': const Color(0xFFD81E28),
      'shudder': const Color(0xFFE53935),
      'curiosity stream': const Color(0xFFF26522),
      'discovery+': const Color(0xFF0A1F3C),
      'britbox': const Color(0xFF002244),
      'acorn tv': const Color(0xFF7A9A01),
      'the criterion channel': const Color(0xFF000000),
      'mubi': const Color(0xFF244A9A),
      'kanopy': const Color(0xFFD50032),
      'hoopla': const Color(0xFF4A90E2),
      'plex': const Color(0xFFE5A00D),
      'pluto tv': const Color(0xFFF9D423),
      'tubi': const Color(0xFFE21A23),
      'freevee': const Color(0xFF14B4A5),
      'vudu/fandango at home': const Color(0xFF333333),
      'crunchyroll': const Color(0xFFF47521),
      'hidive': const Color(0xFF00AEEF),
      'wwe network': const Color(0xFF000000),
      'dazn': const Color(0xFFF8F8F8),
      'ufc fight pass': const Color(0xFFD20A0A),
      'nba league pass': const Color(0xFF002B5C),
      'nfl+': const Color(0xFF013369),
      'f1 tv': const Color(0xFFE10600),

      // Music Services
      'spotify': const Color(0xFF1ED760),
      'apple music': const Color(0xFFFC3C44),
      'amazon music': const Color(0xFF00A8E1),
      'youtube music': const Color(0xFFFF0000),
      'tidal': const Color(0xFF000000),
      'deezer': const Color(0xFFFF6600),
      'pandora': const Color(0xFF0074E4),
      'soundcloud': const Color(0xFFFF8800),

      // Gaming Services
      'xbox game pass': const Color(0xFF107C10),
      'playstation plus': const Color(0xFF0070D1),
      'nintendo switch online': const Color(0xFFE60012),
      'steam': const Color(0xFF171A21),
      'epic games store': const Color(0xFF0078F2),

      // Cloud Storage
      'icloud': const Color(0xFF007AFF),
      'google drive': const Color(0xFF4285F4),
      'dropbox': const Color(0xFF0061FF),
      'onedrive': const Color(0xFF0078D4),

      // Work/Productivity
      'microsoft 365': const Color(0xFF0078D4),
      'google workspace': const Color(0xFF4285F4),
      'adobe creative cloud': const Color(0xFFDA1F26),
      'canva': const Color(0xFF00C4CC),
      'notion': const Color(0xFF000000),
      'slack': const Color(0xFF4A154B),
      'zoom': const Color(0xFF2D8CFF),

      // News/Reading
      'new york times': const Color(0xFF000000),
      'washington post': const Color(0xFF000000),
      'wall street journal': const Color(0xFF0274B6),
      'medium': const Color(0xFF000000),
      'kindle unlimited': const Color(0xFF232F3E),
      'audible': const Color(0xFFFF9500),

      // Add more services as needed...
    };
  }

  // Get logo path for a service
  static String? getLogoPath(String serviceName) {
    // This function converts the service name into a filename-friendly format.
    final formattedName = serviceName
        .toLowerCase()
        .replaceAll(' ', '')
        .replaceAll('+', 'plus')
        .replaceAll('.', '')
        .replaceAll('&', 'and')
        .replaceAll('/', ''); // Added to handle Vudu/Fandango
    return 'assets/logos/$formattedName.png';
  }

  static Future<void> close() async {
    await _subscriptionsBox?.close();
    await _categoriesBox?.close();
  }
}
