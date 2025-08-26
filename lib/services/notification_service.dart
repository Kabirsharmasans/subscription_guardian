import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import '../models/subscription.dart';
import 'database_service.dart';
import 'package:subscription_guardian/services/settings_service.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Initialize timezone data
    tz.initializeTimeZones();

    // Get the local timezone from the platform and set the local location
    try {
      final String timeZoneName =
      await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      // Fallback to UTC if platform call fails
      // ignore: avoid_print
      print('Could not get the local timezone, falling back to UTC: $e');
      tz.setLocalLocation(tz.UTC);
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const WindowsInitializationSettings initializationSettingsWindows =
    WindowsInitializationSettings(
        appName: 'Subscription Guardian',
        appUserModelId: 'SG.SubscriptionGuardian',
        guid: 'a4d1a6a8-8328-4a1a-88b7-89459e3263e1');

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
    final reminderDaysList = SettingsService.reminderDaysList;

    // Cancel existing notifications for this subscription before rescheduling
    for (int i = 0; i < reminderDaysList.length; i++) {
      await _notifications.cancel(subscription.id.hashCode + i);
    }

    for (int i = 0; i < reminderDaysList.length; i++) {
      final reminderDuration = _parseReminderString(reminderDaysList[i]);
      final reminderDate = renewalDate.subtract(reminderDuration);

      if (reminderDate.isAfter(DateTime.now())) {
        await _notifications.zonedSchedule(
          subscription.id.hashCode + i, // Unique ID for each notification
          'Subscription Reminder',
          '${subscription.serviceName} renews in ${reminderDaysList[i]}!',
          tz.TZDateTime.from(reminderDate, tz.local),
          platformChannelSpecifics,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      }
    }
  }

  static Duration _parseReminderString(String reminderString) {
    final parts = reminderString.split(' ');
    final value = int.parse(parts[0]);
    final unit = parts[1];

    switch (unit) {
      case 'days':
        return Duration(days: value);
      case 'day':
        return Duration(days: value);
      case 'week':
        return Duration(days: value * 7);
      case 'weeks':
        return Duration(days: value * 7);
      case 'hours':
        return Duration(hours: value);
      case 'hour':
        return Duration(hours: value);
      default:
        return const Duration(days: 3); // Default to 3 days if parsing fails
    }
  }

  static Future<void> cancelNotification(String subscriptionId) async {
    // Cancel all scheduled notifications for this subscription
    final reminderDaysList = SettingsService.reminderDaysList;
    for (int i = 0; i < reminderDaysList.length; i++) {
      await _notifications.cancel(subscriptionId.hashCode + i);
    }
  }

  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  static Future<void> scheduleAllReminderNotifications() async {
    if (!SettingsService.notificationsEnabled) return;
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