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

  static Future<void> close() async {
    await _subscriptionsBox?.close();
    await _categoriesBox?.close();
  }
}
