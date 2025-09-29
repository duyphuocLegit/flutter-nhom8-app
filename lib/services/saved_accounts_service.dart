import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'firebase_service.dart';

class SavedAccount {
  final String email;
  final String displayName;
  final DateTime lastLogin;
  final String? uid; // Add Firebase UID for syncing

  SavedAccount({
    required this.email,
    required this.displayName,
    required this.lastLogin,
    this.uid,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'lastLogin': lastLogin.toIso8601String(),
      'uid': uid,
    };
  }

  factory SavedAccount.fromMap(Map<String, dynamic> map) {
    return SavedAccount(
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      lastLogin: DateTime.parse(map['lastLogin']),
      uid: map['uid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SavedAccount.fromJson(String source) =>
      SavedAccount.fromMap(json.decode(source));
}

class SavedAccountsService {
  static const String _keySavedAccounts = 'saved_accounts';
  static const String _keyRememberMe = 'remember_me_enabled';
  static const String _keyLastUsedEmail = 'last_used_email';
  static const int _maxSavedAccounts = 5; // Limit to 5 saved accounts

  static SharedPreferences? _prefs;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> _ensureInit() async {
    if (_prefs == null) {
      await init();
    }
  }

  // Get all saved accounts
  static Future<List<SavedAccount>> getSavedAccounts() async {
    await _ensureInit();
    final accountsJson = _prefs?.getStringList(_keySavedAccounts) ?? [];

    return accountsJson.map((json) => SavedAccount.fromJson(json)).toList()
      ..sort(
        (a, b) => b.lastLogin.compareTo(a.lastLogin),
      ); // Sort by most recent
  }

  // Save an account
  static Future<void> saveAccount(String email, String displayName) async {
    await _ensureInit();

    final savedAccounts = await getSavedAccounts();

    // Remove existing account with same email if it exists
    savedAccounts.removeWhere((account) => account.email == email);

    // Add the new/updated account at the beginning
    savedAccounts.insert(
      0,
      SavedAccount(
        email: email,
        displayName: displayName,
        lastLogin: DateTime.now(),
      ),
    );

    // Keep only the most recent accounts (limit to _maxSavedAccounts)
    if (savedAccounts.length > _maxSavedAccounts) {
      savedAccounts.removeRange(_maxSavedAccounts, savedAccounts.length);
    }

    // Save to preferences
    final accountsJson = savedAccounts
        .map((account) => account.toJson())
        .toList();
    await _prefs?.setStringList(_keySavedAccounts, accountsJson);

    // Update last used email
    await setLastUsedEmail(email);
  }

  // Remove a saved account
  static Future<void> removeSavedAccount(String email) async {
    await _ensureInit();

    final savedAccounts = await getSavedAccounts();
    savedAccounts.removeWhere((account) => account.email == email);

    final accountsJson = savedAccounts
        .map((account) => account.toJson())
        .toList();
    await _prefs?.setStringList(_keySavedAccounts, accountsJson);

    // If this was the last used email, clear it
    final lastUsed = await getLastUsedEmail();
    if (lastUsed == email) {
      await clearLastUsedEmail();
    }
  }

  // Clear all saved accounts
  static Future<void> clearAllSavedAccounts() async {
    await _ensureInit();
    await _prefs?.remove(_keySavedAccounts);
    await clearLastUsedEmail();
  }

  // Check if remember me is enabled
  static Future<bool> isRememberMeEnabled() async {
    await _ensureInit();
    return _prefs?.getBool(_keyRememberMe) ?? false;
  }

  // Set remember me preference
  static Future<void> setRememberMe(bool enabled) async {
    await _ensureInit();
    await _prefs?.setBool(_keyRememberMe, enabled);

    // If disabled, clear saved accounts
    if (!enabled) {
      await clearAllSavedAccounts();
    }
  }

  // Get last used email
  static Future<String?> getLastUsedEmail() async {
    await _ensureInit();
    return _prefs?.getString(_keyLastUsedEmail);
  }

  // Set last used email
  static Future<void> setLastUsedEmail(String email) async {
    await _ensureInit();
    await _prefs?.setString(_keyLastUsedEmail, email);
  }

  // Clear last used email
  static Future<void> clearLastUsedEmail() async {
    await _ensureInit();
    await _prefs?.remove(_keyLastUsedEmail);
  }

  // Check if an email is saved
  static Future<bool> isEmailSaved(String email) async {
    final savedAccounts = await getSavedAccounts();
    return savedAccounts.any((account) => account.email == email);
  }

  // Get saved account by email
  static Future<SavedAccount?> getSavedAccountByEmail(String email) async {
    final savedAccounts = await getSavedAccounts();
    try {
      return savedAccounts.firstWhere((account) => account.email == email);
    } catch (e) {
      return null;
    }
  }

  // Track first-time app usage
  static const String _keyFirstTimeUser = 'first_time_user';

  // Check if this is a first-time user
  static Future<bool> isFirstTimeUser() async {
    await _ensureInit();
    // If the key doesn't exist, it's a first-time user
    return _prefs?.getBool(_keyFirstTimeUser) ?? true;
  }

  // Mark user as no longer first-time (call this after first successful sign-up)
  static Future<void> markUserAsReturning() async {
    await _ensureInit();
    await _prefs?.setBool(_keyFirstTimeUser, false);
  }

  // Reset first-time user status (for testing purposes)
  static Future<void> resetFirstTimeStatus() async {
    await _ensureInit();
    await _prefs?.remove(_keyFirstTimeUser);
  }

  // Sync saved account with Firebase data
  static Future<void> syncAccountWithFirebase(String email, String uid) async {
    try {
      // Get user profile from Firebase
      final userProfile = await FirebaseService.getUserProfile(uid);

      if (userProfile != null) {
        // Update saved account with fresh Firebase data
        await saveAccountWithUid(
          email,
          userProfile.displayName.isEmpty ? 'User' : userProfile.displayName,
          uid,
        );
      }
    } catch (e) {
      print('Error syncing account with Firebase: $e');
    }
  }

  // Save account with UID for Firebase syncing
  static Future<void> saveAccountWithUid(
    String email,
    String displayName,
    String uid,
  ) async {
    await _ensureInit();

    final savedAccounts = await getSavedAccounts();

    // Remove existing account with same email if it exists
    savedAccounts.removeWhere((account) => account.email == email);

    // Add the new/updated account at the beginning
    savedAccounts.insert(
      0,
      SavedAccount(
        email: email,
        displayName: displayName,
        lastLogin: DateTime.now(),
        uid: uid,
      ),
    );

    // Keep only the most recent accounts (limit to _maxSavedAccounts)
    if (savedAccounts.length > _maxSavedAccounts) {
      savedAccounts.removeRange(_maxSavedAccounts, savedAccounts.length);
    }

    // Save to preferences
    final accountsJson = savedAccounts
        .map((account) => account.toJson())
        .toList();
    await _prefs?.setStringList(_keySavedAccounts, accountsJson);

    // Update last used email
    await setLastUsedEmail(email);
  }

  // Get fresh account data from Firebase
  static Future<List<SavedAccount>> getSavedAccountsWithFirebaseSync() async {
    final savedAccounts = await getSavedAccounts();
    final syncedAccounts = <SavedAccount>[];

    for (final account in savedAccounts) {
      if (account.uid != null) {
        try {
          // Try to get fresh data from Firebase
          final userProfile = await FirebaseService.getUserProfile(
            account.uid!,
          );

          if (userProfile != null) {
            // Use fresh Firebase data
            syncedAccounts.add(
              SavedAccount(
                email: account.email,
                displayName: userProfile.displayName.isEmpty
                    ? account.displayName
                    : userProfile.displayName,
                lastLogin: account.lastLogin,
                uid: account.uid,
              ),
            );
          } else {
            // Keep original if Firebase data not available
            syncedAccounts.add(account);
          }
        } catch (e) {
          print('Error syncing account ${account.email}: $e');
          // Keep original if sync fails
          syncedAccounts.add(account);
        }
      } else {
        // Keep accounts without UID as-is
        syncedAccounts.add(account);
      }
    }

    return syncedAccounts;
  }

  // Validate and clean up inconsistent data
  static Future<void> cleanupInconsistentData() async {
    try {
      final lastUsedEmail = await getLastUsedEmail();

      if (lastUsedEmail != null) {
        // Check if the last used email still exists in saved accounts
        final savedAccounts = await getSavedAccounts();
        final emailExists = savedAccounts.any(
          (account) => account.email == lastUsedEmail,
        );

        if (!emailExists) {
          // Clear the last used email if it doesn't exist in saved accounts
          await clearLastUsedEmail();
          print('Cleaned up orphaned last used email: $lastUsedEmail');
        }
      }
    } catch (e) {
      print('Error during cleanup: $e');
    }
  }
}
