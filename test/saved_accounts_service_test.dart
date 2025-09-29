import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nhom10/services/saved_accounts_service.dart';

void main() {
  group('SavedAccountsService Tests', () {
    setUp(() async {
      // Initialize shared preferences for testing
      SharedPreferences.setMockInitialValues({});
      await SavedAccountsService.init();
    });

    test('should save and retrieve accounts', () async {
      // Test saving an account
      await SavedAccountsService.saveAccount('test@example.com', 'Test User');

      // Test retrieving accounts
      final accounts = await SavedAccountsService.getSavedAccounts();
      expect(accounts.length, 1);
      expect(accounts.first.email, 'test@example.com');
      expect(accounts.first.displayName, 'Test User');
    });

    test('should handle remember me preference', () async {
      // Test initial state
      expect(await SavedAccountsService.isRememberMeEnabled(), false);

      // Test setting remember me
      await SavedAccountsService.setRememberMe(true);
      expect(await SavedAccountsService.isRememberMeEnabled(), true);

      // Test clearing when disabled
      await SavedAccountsService.saveAccount('test@example.com', 'Test User');
      await SavedAccountsService.setRememberMe(false);

      final accounts = await SavedAccountsService.getSavedAccounts();
      expect(accounts.length, 0);
    });

    test('should limit saved accounts', () async {
      // Save more than the limit
      for (int i = 0; i < 10; i++) {
        await SavedAccountsService.saveAccount('test$i@example.com', 'User $i');
      }

      final accounts = await SavedAccountsService.getSavedAccounts();
      expect(accounts.length, 5); // Should be limited to 5
    });

    test('should remove saved accounts', () async {
      // Clear any existing accounts first
      await SavedAccountsService.clearAllSavedAccounts();

      await SavedAccountsService.saveAccount('test1@example.com', 'User 1');
      await SavedAccountsService.saveAccount('test2@example.com', 'User 2');

      // Verify we have 2 accounts
      var accounts = await SavedAccountsService.getSavedAccounts();
      expect(accounts.length, 2);

      await SavedAccountsService.removeSavedAccount('test1@example.com');

      accounts = await SavedAccountsService.getSavedAccounts();
      expect(accounts.length, 1);
      expect(accounts.first.email, 'test2@example.com');
    });

    test('should track last used email', () async {
      await SavedAccountsService.saveAccount('test@example.com', 'Test User');

      final lastUsed = await SavedAccountsService.getLastUsedEmail();
      expect(lastUsed, 'test@example.com');
    });
  });
}
