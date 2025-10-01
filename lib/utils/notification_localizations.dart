import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../l10n/app_localizations_en.dart';
import '../l10n/app_localizations_vi.dart';

/// Utility class for getting localized strings without BuildContext
/// Used by services that run in the background (like notifications)
class NotificationLocalizations {
  static const String _languageKey = 'selected_language';

  /// Get the current AppLocalizations instance based on stored locale
  static Future<AppLocalizations> _getLocalizations() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey) ?? 'en';

    switch (languageCode) {
      case 'vi':
        return AppLocalizationsVi();
      case 'en':
      default:
        return AppLocalizationsEn();
    }
  }

  /// Get task reminder title
  static Future<String> get taskReminderTitle async {
    final localizations = await _getLocalizations();
    return localizations.taskReminderTitle;
  }

  /// Get task reminder body
  static Future<String> taskReminderBody(String title) async {
    final localizations = await _getLocalizations();
    return localizations.taskReminderBody(title);
  }

  /// Get tasks due today title
  static Future<String> get tasksDueTodayTitle async {
    final localizations = await _getLocalizations();
    return localizations.tasksDueTodayTitle;
  }

  /// Get task completed title
  static Future<String> get taskCompletedTitle async {
    final localizations = await _getLocalizations();
    return localizations.taskCompletedTitle;
  }

  /// Get task completed body
  static Future<String> taskCompletedBody(String title) async {
    final localizations = await _getLocalizations();
    return localizations.taskCompletedBody(title);
  }

  /// Get daily summary title
  static Future<String> get dailySummaryTitle async {
    final localizations = await _getLocalizations();
    return localizations.dailySummaryTitle;
  }

  /// Get daily summary body when all tasks completed
  static Future<String> dailySummaryAllCompleted(int totalTasks) async {
    final localizations = await _getLocalizations();
    return localizations.dailySummaryAllCompleted(totalTasks);
  }

  /// Get daily summary body when some tasks completed
  static Future<String> dailySummaryPartial(
    int completedTasks,
    int totalTasks,
  ) async {
    final localizations = await _getLocalizations();
    return localizations.dailySummaryPartial(completedTasks, totalTasks);
  }
}
