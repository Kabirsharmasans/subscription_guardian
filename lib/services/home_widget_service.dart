import 'package:home_widget/home_widget.dart';
import 'package:subscription_guardian/services/database_service.dart';

class HomeWidgetService {
  static Future<void> updateWidget() async {
    final subscriptions = DatabaseService.getUpcomingRenewals(7);
    final List<String> upcomingRenewals = [];
    for (final sub in subscriptions) {
      upcomingRenewals.add('${sub.serviceName} - ${sub.getDaysUntilRenewal()} days');
    }

    await HomeWidget.saveWidgetData<String>('upcoming_renewals', upcomingRenewals.join('\n'));
    await HomeWidget.updateWidget(name: 'HomeWidgetProvider', iOSName: 'HomeWidgetProvider');
  }
}