import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/subscription.dart';
import 'database_service.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Initialize timezone
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const WindowsInitializationSettings initializationSettingsWindows =
    WindowsInitializationSettings(appName: 'Subscription Guardian', appUserModelId: 'SG.SubscriptionGuardian', guid: 'a4d1a6a8-8328-4a1a-88b7-89459e3263e1');

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      windows: initializationSettingsWindows,
    );

    await _notifications.initialize(initializationSettings);

    // Request permissions for iOS
    await _notifications
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Request permissions for Android 13+
    await _notifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> scheduleRenewalReminder(Subscription subscription) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'renewal_reminders',
      'Renewal Reminders',
      channelDescription: 'Notifications for upcoming subscription renewals',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
    DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    final renewalDate = subscription.getNextRenewalDate();

    // Schedule 3 daily notifications
    for (int i = 1; i <= 3; i++) {
      final reminderDate = renewalDate.subtract(Duration(days: i));
      if (reminderDate.isAfter(DateTime.now())) {
        await _notifications.zonedSchedule(
          subscription.id.hashCode + i, // Unique ID for each notification
          'Subscription Reminder',
          '${subscription.serviceName} renews in $i day(s)!',
          tz.TZDateTime.from(reminderDate, tz.local),
          platformChannelSpecifics,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      }
    }
  }

  static Future<void> cancelNotification(String subscriptionId) async {
    // Cancel all 3 scheduled notifications
    for (int i = 1; i <= 3; i++) {
      await _notifications.cancel(subscriptionId.hashCode + i);
    }
  }

  static Future<void> scheduleAllReminderNotifications() async {
    // Cancel all existing notifications first
    await _notifications.cancelAll();

    // Schedule notifications for all active subscriptions
    final subscriptions = DatabaseService.getAllSubscriptions();
    for (final subscription in subscriptions) {
      await scheduleRenewalReminder(subscription);
    }
  }

  static Future<void> showInstantNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'instant_notifications',
      'Instant Notifications',
      channelDescription: 'General notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
    DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _notifications.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}