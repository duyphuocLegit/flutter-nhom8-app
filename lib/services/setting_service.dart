import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_service.dart';
import 'notification_service.dart';

class SettingsService {
  static const String _keyDarkMode = 'dark_mode';
  static const String _keyThemeMode = 'theme_mode'; // New theme mode key
  static const String _keyDefaultPriority = 'default_priority';
  static const String _keyTaskReminders = 'task_reminders';
  static const String _keyCompletionNotifications = 'completion_notifications';
  static const String _keyDailySummary = 'daily_summary';
  static const String _keyWeeklyReport = 'weekly_report';
  static const String _keyLockContactInfo =
      'lock_contact_info'; // Lock name/email in contact forms

  static SharedPreferences? _prefs;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // App Preferences
  static Future<bool> getDarkMode() async {
    await _ensureInit();
    return _prefs?.getBool(_keyDarkMode) ?? false;
  }

  static Future<void> setDarkMode(bool value) async {
    await _ensureInit();
    await _prefs?.setBool(_keyDarkMode, value);
    await _syncToCloud();
  }

  // New theme mode methods
  static Future<ThemeMode> getThemeMode() async {
    await _ensureInit();
    final themeString = _prefs?.getString(_keyThemeMode) ?? 'system';
    switch (themeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static Future<void> setThemeMode(ThemeMode value) async {
    await _ensureInit();
    String themeString;
    switch (value) {
      case ThemeMode.light:
        themeString = 'light';
        break;
      case ThemeMode.dark:
        themeString = 'dark';
        break;
      default:
        themeString = 'system';
    }
    await _prefs?.setString(_keyThemeMode, themeString);
    await _syncToCloud();
  }

  static Future<String> getDefaultPriority() async {
    await _ensureInit();
    return _prefs?.getString(_keyDefaultPriority) ?? 'medium';
  }

  static Future<void> setDefaultPriority(String value) async {
    await _ensureInit();
    await _prefs?.setString(_keyDefaultPriority, value);
    await _syncToCloud();
  }

  // Notification Settings
  static Future<bool> getTaskReminders() async {
    await _ensureInit();
    return _prefs?.getBool(_keyTaskReminders) ?? true;
  }

  static Future<void> setTaskReminders(bool value) async {
    await _ensureInit();
    await _prefs?.setBool(_keyTaskReminders, value);

    // Initialize notification service when enabling notifications
    if (value) {
      await NotificationService.initialize();
      await NotificationService.requestPermissions();
    } else {
      // Cancel all notifications when disabling
      await NotificationService.cancelAllNotifications();
    }

    await _syncToCloud();
  }

  static Future<bool> getCompletionNotifications() async {
    await _ensureInit();
    return _prefs?.getBool(_keyCompletionNotifications) ?? true;
  }

  static Future<void> setCompletionNotifications(bool value) async {
    await _ensureInit();
    await _prefs?.setBool(_keyCompletionNotifications, value);
    await _syncToCloud();
  }

  static Future<bool> getDailySummary() async {
    await _ensureInit();
    return _prefs?.getBool(_keyDailySummary) ?? false;
  }

  static Future<void> setDailySummary(bool value) async {
    await _ensureInit();
    await _prefs?.setBool(_keyDailySummary, value);
    await _syncToCloud();
  }

  static Future<bool> getWeeklyReport() async {
    await _ensureInit();
    return _prefs?.getBool(_keyWeeklyReport) ?? true;
  }

  static Future<void> setWeeklyReport(bool value) async {
    await _ensureInit();
    await _prefs?.setBool(_keyWeeklyReport, value);
    await _syncToCloud();
  }

  // Contact form settings
  static Future<bool> getLockContactInfo() async {
    await _ensureInit();
    return _prefs?.getBool(_keyLockContactInfo) ??
        true; // Default to true (locked)
  }

  static Future<void> setLockContactInfo(bool value) async {
    await _ensureInit();
    await _prefs?.setBool(_keyLockContactInfo, value);
    await _syncToCloud();
  }

  // Load all settings at once
  static Future<Map<String, dynamic>> getAllSettings() async {
    return {
      'darkMode': await getDarkMode(),
      'defaultPriority': await getDefaultPriority(),
      'taskReminders': await getTaskReminders(),
      'completionNotifications': await getCompletionNotifications(),
      'dailySummary': await getDailySummary(),
      'weeklyReport': await getWeeklyReport(),
      'lockContactInfo': await getLockContactInfo(),
    };
  }

  // Reset all settings to defaults
  static Future<void> resetAllSettings() async {
    await _ensureInit();
    await _prefs?.clear();
    await _syncToCloud();
  }

  // Clear app cache
  static Future<double> clearAppCache() async {
    // In a real implementation, you would clear actual cache files
    // For now, we'll simulate clearing cache and return freed space in MB
    await Future.delayed(const Duration(seconds: 2));
    return 12.5; // Simulated freed space in MB
  }

  // Task Categories Management
  static Future<List<Map<String, dynamic>>> getTaskCategories() async {
    try {
      if (FirebaseService.currentUserId != null) {
        DocumentSnapshot doc = await _firestore
            .collection('users')
            .doc(FirebaseService.currentUserId)
            .collection('settings')
            .doc('categories')
            .get();

        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>?;
          return List<Map<String, dynamic>>.from(data?['categories'] ?? []);
        }
      }
    } catch (e) {
      print('Error getting categories: $e');
    }

    // Return default categories
    return [
      {'name': 'Personal', 'icon': 'person', 'color': 0xFF2196F3},
      {'name': 'Work', 'icon': 'work', 'color': 0xFFFF9800},
      {'name': 'Study', 'icon': 'school', 'color': 0xFF4CAF50},
      {'name': 'Health', 'icon': 'health_and_safety', 'color': 0xFFF44336},
      {'name': 'Shopping', 'icon': 'shopping_cart', 'color': 0xFF9C27B0},
    ];
  }

  static Future<void> saveTaskCategories(
    List<Map<String, dynamic>> categories,
  ) async {
    try {
      if (FirebaseService.currentUserId != null) {
        await _firestore
            .collection('users')
            .doc(FirebaseService.currentUserId)
            .collection('settings')
            .doc('categories')
            .set({'categories': categories});
      }
    } catch (e) {
      print('Error saving categories: $e');
    }
  }

  static Future<void> addTaskCategory(Map<String, dynamic> category) async {
    final categories = await getTaskCategories();
    categories.add(category);
    await saveTaskCategories(categories);
  }

  static Future<void> updateTaskCategory(
    int index,
    Map<String, dynamic> category,
  ) async {
    final categories = await getTaskCategories();
    if (index < categories.length) {
      categories[index] = category;
      await saveTaskCategories(categories);
    }
  }

  static Future<void> deleteTaskCategory(int index) async {
    final categories = await getTaskCategories();
    if (index < categories.length) {
      categories.removeAt(index);
      await saveTaskCategories(categories);
    }
  }

  // Sync settings to cloud (Firebase)
  static Future<void> _syncToCloud() async {
    try {
      if (FirebaseService.currentUserId != null) {
        final settings = await getAllSettings();
        await _firestore
            .collection('users')
            .doc(FirebaseService.currentUserId)
            .collection('settings')
            .doc('preferences')
            .set({...settings, 'lastUpdated': FieldValue.serverTimestamp()});
      }
    } catch (e) {
      print('Error syncing settings to cloud: $e');
    }
  }

  // Load settings from cloud
  static Future<void> loadFromCloud() async {
    try {
      if (FirebaseService.currentUserId != null) {
        DocumentSnapshot doc = await _firestore
            .collection('users')
            .doc(FirebaseService.currentUserId)
            .collection('settings')
            .doc('preferences')
            .get();

        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          await _ensureInit();

          // Update local preferences with cloud data
          await _prefs?.setBool(_keyDarkMode, data['darkMode'] ?? false);
          await _prefs?.setString(
            _keyDefaultPriority,
            data['defaultPriority'] ?? 'medium',
          );
          await _prefs?.setBool(
            _keyTaskReminders,
            data['taskReminders'] ?? true,
          );
          await _prefs?.setBool(
            _keyCompletionNotifications,
            data['completionNotifications'] ?? true,
          );
          await _prefs?.setBool(
            _keyDailySummary,
            data['dailySummary'] ?? false,
          );
          await _prefs?.setBool(_keyWeeklyReport, data['weeklyReport'] ?? true);
          await _prefs?.setBool(
            _keyLockContactInfo,
            data['lockContactInfo'] ?? true,
          );
        }
      }
    } catch (e) {
      print('Error loading settings from cloud: $e');
    }
  }

  // Auto-archive completed tasks older than specified days
  static Future<int> autoArchiveCompletedTasks({int daysOld = 30}) async {
    try {
      if (FirebaseService.currentUserId == null) return 0;

      final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));

      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(FirebaseService.currentUserId)
          .collection('tasks')
          .where('isCompleted', isEqualTo: true)
          .where('completedAt', isLessThan: Timestamp.fromDate(cutoffDate))
          .get();

      int archivedCount = 0;
      WriteBatch batch = _firestore.batch();

      for (QueryDocumentSnapshot doc in snapshot.docs) {
        // Move to archived collection
        batch.set(
          _firestore
              .collection('users')
              .doc(FirebaseService.currentUserId)
              .collection('archived_tasks')
              .doc(doc.id),
          {
            ...doc.data() as Map<String, dynamic>,
            'archivedAt': FieldValue.serverTimestamp(),
          },
        );

        // Delete from tasks collection
        batch.delete(doc.reference);
        archivedCount++;
      }

      if (archivedCount > 0) {
        await batch.commit();
      }

      return archivedCount;
    } catch (e) {
      print('Error auto-archiving tasks: $e');
      return 0;
    }
  }

  // Helper method to ensure SharedPreferences is initialized
  static Future<void> _ensureInit() async {
    if (_prefs == null) {
      await init();
    }
  }

  // Get app storage usage
  static Future<Map<String, dynamic>> getStorageInfo() async {
    try {
      if (FirebaseService.currentUserId == null) {
        return {'used': 0.0, 'total': 100.0, 'details': {}};
      }

      // Get task count
      QuerySnapshot tasksSnapshot = await _firestore
          .collection('users')
          .doc(FirebaseService.currentUserId)
          .collection('tasks')
          .get();

      // Get archived tasks count
      QuerySnapshot archivedSnapshot = await _firestore
          .collection('users')
          .doc(FirebaseService.currentUserId)
          .collection('archived_tasks')
          .get();

      // Calculate estimated storage usage
      double tasksStorage =
          tasksSnapshot.docs.length * 0.01; // 0.01 MB per task
      double archivedStorage = archivedSnapshot.docs.length * 0.01;
      double userDataStorage = 0.1; // Base user data
      double settingsStorage = 0.05; // Settings data

      double totalUsed =
          tasksStorage + archivedStorage + userDataStorage + settingsStorage;

      return {
        'used': double.parse(totalUsed.toStringAsFixed(2)),
        'total': 100.0,
        'details': {
          'activeTasks': tasksSnapshot.docs.length,
          'archivedTasks': archivedSnapshot.docs.length,
          'tasksStorage': double.parse(tasksStorage.toStringAsFixed(2)),
          'archivedStorage': double.parse(archivedStorage.toStringAsFixed(2)),
          'userDataStorage': userDataStorage,
          'settingsStorage': settingsStorage,
        },
      };
    } catch (e) {
      print('Error getting storage info: $e');
      return {'used': 0.0, 'total': 100.0, 'details': {}};
    }
  }
}
