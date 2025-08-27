import 'package:home_widget/home_widget.dart';
import 'package:subscription_guardian/services/database_service.dart';
// Subscription model is referenced via DatabaseService so no direct import needed

class WidgetService {
  /// Updates the Android home widget with a compact summary string under
  /// the key 'upcoming_renewals' (the Android provider reads this key).
  static Future<void> updateWidget({int daysAhead = 30}) async {
    try {
      final subscriptions = DatabaseService.getAllSubscriptions();

      final upcoming =
          subscriptions
              .where((s) => s.isActive && s.getDaysUntilRenewal() <= daysAhead)
              .toList()
            ..sort(
              (a, b) =>
                  a.getDaysUntilRenewal().compareTo(b.getDaysUntilRenewal()),
            );

      String message;
      if (upcoming.isEmpty) {
        message = 'No upcoming renewals.';
      } else {
        final lines = upcoming.take(3).map((s) {
          final days = s.getDaysUntilRenewal();
          final when = days == 0
              ? 'Renews today'
              : 'Renews in $days day${days == 1 ? '' : 's'}';
          return '${s.serviceName} - $when';
        }).toList();
        if (upcoming.length > 3) {
          lines.add('+ ${upcoming.length - 3} more');
        }
        message = lines.join('\n');
      }

      await HomeWidget.saveWidgetData<String>('upcoming_renewals', message);
      await HomeWidget.updateWidget(androidName: 'HomeWidgetProvider');
    } catch (_) {
      // ignore errors to avoid breaking callers; consider logging in production
    }
  }
}
