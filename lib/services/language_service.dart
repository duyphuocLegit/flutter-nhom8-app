import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LanguageService extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;

  // Supported locales
  static const List<Locale> supportedLocales = [Locale('en'), Locale('vi')];

  // Language display names
  static const Map<String, String> languageNames = {
    'en': 'English',
    'vi': 'Tiếng Việt',
  };

  LanguageService() {
    _loadLanguage();
  }

  /// Load language from SharedPreferences and Firebase
  Future<void> _loadLanguage() async {
    try {
      // First, try to load from SharedPreferences (faster)
      final prefs = await SharedPreferences.getInstance();
      final localLanguageCode = prefs.getString(_languageKey);

      if (localLanguageCode != null) {
        _currentLocale = Locale(localLanguageCode);
        notifyListeners();
      }

      // Then, try to sync with Firebase if user is logged in
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _syncWithFirebase(user.uid);
      }
    } catch (e) {
      debugPrint('Error loading language: $e');
    }
  }

  /// Sync language preference with Firebase
  Future<void> _syncWithFirebase(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (doc.exists) {
        final data = doc.data();
        final firebaseLanguageCode = data?['preferredLanguage'] as String?;

        if (firebaseLanguageCode != null &&
            firebaseLanguageCode != _currentLocale.languageCode) {
          _currentLocale = Locale(firebaseLanguageCode);

          // Update local storage to match Firebase
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_languageKey, firebaseLanguageCode);

          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error syncing language with Firebase: $e');
    }
  }

  /// Change the app language
  Future<void> setLanguage(String languageCode) async {
    if (!supportedLocales.any(
      (locale) => locale.languageCode == languageCode,
    )) {
      debugPrint('Unsupported language code: $languageCode');
      return;
    }

    _currentLocale = Locale(languageCode);
    notifyListeners();

    // Save to SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
    } catch (e) {
      debugPrint('Error saving language to SharedPreferences: $e');
    }

    // Save to Firebase if user is logged in
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'preferredLanguage': languageCode,
        }, SetOptions(merge: true));
      } catch (e) {
        debugPrint('Error saving language to Firebase: $e');
      }
    }
  }

  /// Initialize language service when user logs in
  Future<void> onUserLogin(String userId) async {
    await _syncWithFirebase(userId);
  }

  /// Get display name for a language code
  static String getLanguageName(String languageCode) {
    return languageNames[languageCode] ?? languageCode;
  }

  /// Check if a language is supported
  static bool isLanguageSupported(String languageCode) {
    return supportedLocales.any(
      (locale) => locale.languageCode == languageCode,
    );
  }
}
