import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/task_model.dart';
import '../utils/notification_localizations.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static bool _isInitialized = false;

  // Notification channel details
  static const String _channelId = 'task_notifications';
  static const String _channelName = 'Task Notifications';
  static const String _channelDescription =
      'Notifications for task reminders and updates';

  /// Initialize the notification service
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize notifications
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Create notification channel for Android
      await _createNotificationChannel();

      _isInitialized = true;
      debugPrint('NotificationService initialized successfully');
    } catch (e) {
      debugPrint('Error initializing NotificationService: $e');
      // Don't set _isInitialized to true if there was an error
      rethrow;
    }
  }

  /// Create notification channel for Android
  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
      playSound: false,
      enableVibration: false,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  /// Handle notification tap
  static Future<void> _onNotificationTapped(
    NotificationResponse response,
  ) async {
    // Handle navigation based on notification payload
    final payload = response.payload;
    if (payload != null) {
      // Parse payload and navigate accordingly
      debugPrint('Notification tapped with payload: $payload');
    }
  }

  /// Request notification permissions
  static Future<bool> requestPermissions() async {
    await initialize();

    // Request permissions for iOS
    final iosPlatform = _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    if (iosPlatform != null) {
      final granted = await iosPlatform.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    // For Android 13+ (API level 33+), request POST_NOTIFICATIONS permission
    final androidPlatform = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlatform != null) {
      final granted = await androidPlatform.requestNotificationsPermission();
      return granted ?? true; // Default to true for older Android versions
    }

    return true;
  }

  /// Show task reminder notification
  static Future<void> showTaskReminder(TaskItemModel task) async {
    if (!await _shouldShowNotifications()) return;

    await initialize();

    final shouldPlaySound = await _shouldPlaySound();
    final shouldVibrate = await _shouldVibrate();

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
          icon: '@mipmap/ic_launcher',
          largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
          playSound: shouldPlaySound,
          enableVibration: shouldVibrate,
        );

    final DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: shouldPlaySound,
    );

    final NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final title = task.title == 'Tasks Due Today'
        ? await NotificationLocalizations.tasksDueTodayTitle
        : await NotificationLocalizations.taskReminderTitle;
    final body = task.title == 'Tasks Due Today'
        ? task.description
        : await NotificationLocalizations.taskReminderBody(task.title);

    await _notifications.show(
      task.id?.hashCode ?? 0,
      title,
      body,
      platformDetails,
      payload: 'task_reminder_${task.id ?? ''}',
    );
  }

  /// Show task completion notification
  static Future<void> showTaskCompletionNotification(TaskItemModel task) async {
    if (!await _shouldShowCompletionNotifications()) return;

    await initialize();

    final shouldPlaySound = await _shouldPlaySound();
    final shouldVibrate = await _shouldVibrate();

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          showWhen: true,
          icon: '@mipmap/ic_launcher',
          playSound: shouldPlaySound,
          enableVibration: shouldVibrate,
        );

    final DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: shouldPlaySound,
    );

    final NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      (task.id?.hashCode ?? 0) + 1000, // Offset to avoid ID conflicts
      await NotificationLocalizations.taskCompletedTitle,
      await NotificationLocalizations.taskCompletedBody(task.title),
      platformDetails,
      payload: 'task_completed_${task.id ?? ''}',
    );

    // Play success sound and light vibration if enabled
    if (await _shouldPlaySound()) {
      await _playSuccessSound();
    }
    if (await _shouldVibrate()) {
      await _performLightVibration();
    }
  }

  /// Show daily summary notification
  static Future<void> showDailySummary(
    int completedTasks,
    int totalTasks,
  ) async {
    if (!await _shouldShowDailySummary()) return;

    await initialize();

    final String message = completedTasks == totalTasks
        ? await NotificationLocalizations.dailySummaryAllCompleted(totalTasks)
        : await NotificationLocalizations.dailySummaryPartial(
            completedTasks,
            totalTasks,
          );

    final shouldPlaySound = await _shouldPlaySound();
    final shouldVibrate = await _shouldVibrate();

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          showWhen: true,
          icon: '@mipmap/ic_launcher',
          playSound: shouldPlaySound,
          enableVibration: shouldVibrate,
        );

    final DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: shouldPlaySound,
    );

    final NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      999, // Fixed ID for daily summary
      await NotificationLocalizations.dailySummaryTitle,
      message,
      platformDetails,
      payload: 'daily_summary',
    );
  }

  /// Schedule task reminder notification
  static Future<void> scheduleTaskReminder(
    TaskItemModel task,
    DateTime reminderTime,
  ) async {
    if (!await _shouldShowNotifications()) return;

    await initialize();

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
          icon: '@mipmap/ic_launcher',
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      task.id?.hashCode ?? 0,
      await NotificationLocalizations.taskReminderTitle,
      await NotificationLocalizations.taskReminderBody(task.title),
      tz.TZDateTime.from(reminderTime, tz.local),
      platformDetails,
      payload: 'scheduled_reminder_${task.id ?? ''}',
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Cancel specific notification
  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Play success sound
  static Future<void> _playSuccessSound() async {
    if (!await _shouldPlaySound()) return;

    try {
      // Play a different sound for success
      await SystemSound.play(SystemSoundType.click);
    } catch (e) {
      debugPrint('Error playing success sound: $e');
    }
  }

  /// Perform light vibration for success feedback (disabled)
  static Future<void> _performLightVibration() async {
    // Vibration functionality disabled
    return;
  }

  /// Perform haptic feedback (disabled)
  static Future<void> performHapticFeedback() async {
    // Haptic feedback functionality disabled
    return;
  }

  /// Check if notifications should be shown
  static Future<bool> _shouldShowNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('task_reminders') ?? true;
  }

  /// Check if completion notifications should be shown
  static Future<bool> _shouldShowCompletionNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('completion_notifications') ?? true;
  }

  /// Check if daily summary should be shown
  static Future<bool> _shouldShowDailySummary() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('daily_summary') ?? false;
  }

  /// Check if sound should be played
  static Future<bool> _shouldPlaySound() async {
    return false; // Sound disabled
  }

  /// Check if vibration should be performed
  static Future<bool> _shouldVibrate() async {
    return false; // Vibration disabled
  }

  /// Get pending notifications count
  static Future<int> getPendingNotificationsCount() async {
    final pendingNotifications = await _notifications
        .pendingNotificationRequests();
    return pendingNotifications.length;
  }

  /// Clear all scheduled notifications for a specific task
  static Future<void> clearTaskNotifications(String taskId) async {
    final pendingNotifications = await _notifications
        .pendingNotificationRequests();

    for (final notification in pendingNotifications) {
      if (notification.payload?.contains(taskId) == true) {
        await _notifications.cancel(notification.id);
      }
    }
  }
}
