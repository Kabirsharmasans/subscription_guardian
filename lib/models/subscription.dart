import 'package:hive/hive.dart';

part 'subscription.g.dart';

@HiveType(typeId: 0)
class Subscription extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String serviceName;

  @HiveField(2)
  double monthlyCost;

  @HiveField(3)
  DateTime renewalDate;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  bool isActive;

  @HiveField(6)
  String currency;

  @HiveField(7)
  String? categoryId;

  Subscription({
    required this.id,
    required this.serviceName,
    required this.monthlyCost,
    required this.renewalDate,
    required this.createdAt,
    this.isActive = true,
    required this.currency,
    this.categoryId,
  });

  // Get next renewal date from current date
  DateTime getNextRenewalDate() {
    final now = DateTime.now();
    final renewalDay = renewalDate.day;

    // Start with current month
    DateTime nextRenewal;

    try {
      nextRenewal = DateTime(now.year, now.month, renewalDay);
    } catch (e) {
      // Handle case where renewal day doesn't exist in current month (e.g., Feb 31)
      // Fall back to last day of month
      nextRenewal = DateTime(now.year, now.month + 1, 0);
    }

    // If the renewal date this month has already passed, move to next month
    if (nextRenewal.isBefore(now) || nextRenewal.isAtSameMomentAs(now)) {
      try {
        nextRenewal = DateTime(now.year, now.month + 1, renewalDay);
      } catch (e) {
        // Handle case where renewal day doesn't exist in next month
        nextRenewal = DateTime(now.year, now.month + 2, 0);
      }
    }

    return nextRenewal;
  }

  // Calculate days until next renewal
  int getDaysUntilRenewal() {
    final nextRenewal = getNextRenewalDate();
    final now = DateTime.now();
    return nextRenewal.difference(now).inDays;
  }

  @override
  String toString() {
    return 'Subscription{serviceName: $serviceName, cost: $currency$monthlyCost, renewalDate: $renewalDate}';
  }
}
