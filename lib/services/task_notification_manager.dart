import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/notification_service.dart';
import '../services/setting_service.dart';
import '../services/firebase_service.dart';

class TaskNotificationManager {
  /// Handle task creation notifications
  static Future<void> onTaskCreated(TaskItemModel task) async {
    // Schedule reminder notification if task has a due date
    if (task.dueDate != null) {
      // Schedule notification 30 minutes before due date
      final reminderTime = task.dueDate!.subtract(const Duration(minutes: 30));

      // Only schedule if reminder time is in the future
      if (reminderTime.isAfter(DateTime.now())) {
        await NotificationService.scheduleTaskReminder(task, reminderTime);
      }
    }

    // Show immediate notification if task is due today
    if (task.dueDate != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final taskDueDate = DateTime(
        task.dueDate!.year,
        task.dueDate!.month,
        task.dueDate!.day,
      );
      if (taskDueDate.isAtSameMomentAs(today)) {
        await NotificationService.showTaskReminder(task);
      }
    }

    // Provide haptic feedback for task creation
    await NotificationService.performHapticFeedback();
  }

  /// Handle task completion notifications
  static Future<void> onTaskCompleted(TaskItemModel task) async {
    // Show completion notification if enabled
    if (await SettingsService.getCompletionNotifications()) {
      await NotificationService.showTaskCompletionNotification(task);
    }

    // Clear any scheduled reminders for this task
    if (task.id != null) {
      await NotificationService.clearTaskNotifications(task.id!);
    }

    // Provide success haptic feedback
    await NotificationService.performHapticFeedback();
  }

  /// Handle task update notifications
  static Future<void> onTaskUpdated(
    TaskItemModel oldTask,
    TaskItemModel newTask,
  ) async {
    // Clear old notifications
    if (oldTask.id != null) {
      await NotificationService.clearTaskNotifications(oldTask.id!);
    }

    // Schedule new notifications if due date changed
    if (newTask.dueDate != null && !newTask.isCompleted) {
      final reminderTime = newTask.dueDate!.subtract(
        const Duration(minutes: 30),
      );

      if (reminderTime.isAfter(DateTime.now())) {
        await NotificationService.scheduleTaskReminder(newTask, reminderTime);
      }
    }

    // Provide subtle haptic feedback for updates
    await NotificationService.performHapticFeedback();
  }

  /// Handle task deletion notifications
  static Future<void> onTaskDeleted(TaskItemModel task) async {
    // Clear any scheduled notifications for this task
    if (task.id != null) {
      await NotificationService.clearTaskNotifications(task.id!);
    }

    // Provide haptic feedback
    await NotificationService.performHapticFeedback();
  }

  /// Show daily summary notification
  static Future<void> showDailySummary(List<TaskItemModel> todayTasks) async {
    if (await SettingsService.getDailySummary()) {
      final completedTasks = todayTasks
          .where((task) => task.isCompleted)
          .length;
      final totalTasks = todayTasks.length;

      if (totalTasks > 0) {
        await NotificationService.showDailySummary(completedTasks, totalTasks);
      }
    }
  }

  /// Handle overdue task notifications
  static Future<void> checkOverdueTasks(List<TaskItemModel> tasks) async {
    if (!await SettingsService.getTaskReminders()) return;

    final now = DateTime.now();
    final overdueTasks = tasks
        .where(
          (task) =>
              !task.isCompleted &&
              task.dueDate != null &&
              task.dueDate!.isBefore(now),
        )
        .toList();

    for (final task in overdueTasks) {
      await NotificationService.showTaskReminder(task);
    }
  }

  /// Setup weekly report notification
  static Future<void> scheduleWeeklyReport() async {
    if (await SettingsService.getWeeklyReport()) {
      // This would typically schedule a weekly notification
      // For now, we'll just prepare the framework
      debugPrint('Weekly report scheduled');
    }
  }

  /// Handle priority change feedback
  static Future<void> onPriorityChanged(String newPriority) async {
    // Different haptic feedback based on priority
    switch (newPriority.toLowerCase()) {
      case 'high':
        // Stronger vibration for high priority
        await NotificationService.performHapticFeedback();
        break;
      case 'medium':
        // Medium vibration
        await NotificationService.performHapticFeedback();
        break;
      case 'low':
        // Light vibration
        await NotificationService.performHapticFeedback();
        break;
    }
  }

  /// Initialize notification manager
  static Future<void> initialize() async {
    try {
      await NotificationService.initialize();

      // Request permissions on first launch
      final hasPermissions = await NotificationService.requestPermissions();
      if (!hasPermissions) {
        debugPrint('Notification permissions not granted');
      } else {
        debugPrint('TaskNotificationManager initialized successfully');
      }
    } catch (e) {
      debugPrint('Error initializing TaskNotificationManager: $e');
      // Continue app execution even if notifications fail
    }
  }

  /// Test notification system - shows tasks due today
  static Future<void> testNotification() async {
    try {
      // Get all user tasks
      final allTasks = await FirebaseService.getUserTasks();

      // Filter tasks due today (not completed)
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final tasksDueToday = allTasks.where((task) {
        if (task.isCompleted || task.dueDate == null) return false;

        final taskDueDate = DateTime(
          task.dueDate!.year,
          task.dueDate!.month,
          task.dueDate!.day,
        );

        return taskDueDate.isAtSameMomentAs(today);
      }).toList();

      // Create a dummy task with appropriate message
      final testTask = TaskItemModel(
        id: 'test_due_today_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Tasks Due Today',
        description: _getTasksDueTodayMessage(tasksDueToday),
        isCompleted: false,
        priority: 'high',
        category: 'Reminder',
        createdAt: DateTime.now(),
        dueDate: DateTime.now().add(const Duration(minutes: 1)),
      );

      await NotificationService.showTaskReminder(testTask);
    } catch (e) {
      // Fallback to simple test notification if something goes wrong
      final testTask = TaskItemModel(
        id: 'test_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Test Notification',
        description: 'This is a test notification to verify the system works.',
        isCompleted: false,
        priority: 'medium',
        category: 'Personal',
        createdAt: DateTime.now(),
        dueDate: DateTime.now().add(const Duration(minutes: 1)),
      );

      await NotificationService.showTaskReminder(testTask);
    }
  }

  /// Helper method to create message for tasks due today
  static String _getTasksDueTodayMessage(List<TaskItemModel> tasksDueToday) {
    if (tasksDueToday.isEmpty) {
      return 'You have no tasks due today. Great job staying on top of things!';
    }

    final taskCount = tasksDueToday.length;
    final taskTitles = tasksDueToday
        .take(3)
        .map((task) => task.title)
        .join(', ');
    final remainingCount = taskCount - 3;

    if (taskCount == 1) {
      return 'You have 1 task due today: ${tasksDueToday.first.title}';
    } else if (taskCount <= 3) {
      return 'You have $taskCount tasks due today: $taskTitles';
    } else {
      return 'You have $taskCount tasks due today: $taskTitles and $remainingCount more';
    }
  }
}
