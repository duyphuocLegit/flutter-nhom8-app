<!-- @format -->

# Save Account Feature Implementation

## Overview

The save account feature allows users to remember their login credentials for faster authentication in future sessions. This feature has been implemented with security best practices and user-friendly functionality.

## Features Implemented

### 1. **Remember Me Checkbox**

- Appears only on the login screen
- When checked, saves the account information after successful login
- Persists user preference across app restarts

### 2. **Saved Accounts Dropdown**

- Displays on login screen when saved accounts exist
- Shows up to 5 most recently used accounts
- Each account displays:
  - User's display name or email prefix
  - Full email address
  - Profile avatar (first letter of name/email)

### 3. **Account Management**

- **Auto-save**: Accounts are automatically saved when "Remember Me" is enabled
- **Account Limit**: Maximum of 5 saved accounts (oldest are automatically removed)
- **Remove Accounts**: Long-press on any saved account to remove it
- **Last Used Tracking**: The most recently used account is pre-selected

### 4. **Security Considerations**

- **No Password Storage**: Only email and display name are stored locally
- **Encrypted Storage**: Uses SharedPreferences with device-level encryption
- **Easy Clear**: Disabling "Remember Me" clears all saved accounts
- **Session Management**: Passwords must still be entered for each login

## Implementation Details

### Files Created/Modified

#### New Service: `SavedAccountsService`

**Location**: `lib/services/saved_accounts_service.dart`

**Key Methods**:

```dart
// Save an account after successful login
SavedAccountsService.saveAccount(email, displayName)

// Get all saved accounts (up to 5, sorted by last login)
SavedAccountsService.getSavedAccounts()

// Remove a specific account
SavedAccountsService.removeSavedAccount(email)

// Check/set remember me preference
SavedAccountsService.isRememberMeEnabled()
SavedAccountsService.setRememberMe(enabled)

// Track last used email
SavedAccountsService.getLastUsedEmail()
SavedAccountsService.setLastUsedEmail(email)
```

#### Updated Authentication Screen

**Location**: `lib/screens/authentication.dart`

**New Features**:

- Saved accounts dropdown with user-friendly display
- Remember me checkbox with proper state management
- Account selection and removal functionality
- Integration with Firebase authentication flow

#### Localization Support

**Files**: `lib/l10n/app_en.arb`, `lib/l10n/app_vi.arb`

**New Translations**:

- `rememberMe`: "Remember me" / "Ghi nhớ tôi"
- `savedAccounts`: "Saved Accounts" / "Tài Khoản Đã Lưu"
- `accountSaved`: "Account saved successfully" / "Tài khoản đã được lưu thành công"
- `accountRemoved`: "Account removed successfully" / "Tài khoản đã được xóa thành công"
- `selectSavedAccount`: "Select a saved account" / "Chọn tài khoản đã lưu"
- `noSavedAccounts`: "No saved accounts found" / "Không tìm thấy tài khoản đã lưu"

#### Service Initialization

**Location**: `lib/main.dart`

- Added `SavedAccountsService.init()` to app startup

### Data Storage Structure

#### SavedAccount Model

```dart
class SavedAccount {
  final String email;
  final String displayName;
  final DateTime lastLogin;
}
```

#### SharedPreferences Keys

- `saved_accounts`: List of JSON-encoded SavedAccount objects
- `remember_me_enabled`: Boolean preference for remember me feature
- `last_used_email`: String of the most recently used email

## User Experience

### First Time Login

1. User sees standard login form
2. "Remember me" checkbox available (unchecked by default)
3. User can optionally check "Remember me" before signing in

### Subsequent Logins (with saved accounts)

1. Login screen shows saved accounts dropdown
2. User can select from previously saved accounts
3. Email field auto-populates when account is selected
4. Password still required for security
5. New successful logins update the saved account's last login time

### Account Management

1. **View Saved Accounts**: Dropdown shows all saved accounts with avatars
2. **Remove Account**: Long-press any saved account to remove it
3. **Clear All**: Disable "Remember me" to clear all saved accounts
4. **Automatic Cleanup**: Only 5 most recent accounts are kept

## Security Features

### What Is Stored

- ✅ Email address
- ✅ Display name
- ✅ Last login timestamp
- ✅ Remember me preference

### What Is NOT Stored

- ❌ Passwords
- ❌ Authentication tokens
- ❌ Firebase credentials
- ❌ Personal data beyond display name

### Protection Measures

1. **Local Storage Only**: Data stays on the user's device
2. **No Network Transmission**: Saved account data never leaves the device
3. **SharedPreferences Encryption**: Uses Android/iOS system encryption
4. **Easy Reset**: Users can clear all data by disabling the feature
5. **Automatic Limits**: Prevents unlimited account accumulation

## Testing

### Unit Tests

**Location**: `test/saved_accounts_service_test.dart`

**Coverage**:

- Account saving and retrieval
- Remember me preference management
- Account limit enforcement (5 accounts max)
- Account removal functionality
- Last used email tracking

### Test Results

```
✅ Should save and retrieve accounts
✅ Should handle remember me preference
✅ Should limit saved accounts
✅ Should remove saved accounts
✅ Should track last used email
```

## Usage Example

### For Developers

```dart
// Check if remember me is enabled
final rememberMe = await SavedAccountsService.isRememberMeEnabled();

// Save an account after successful login
if (rememberMe) {
  await SavedAccountsService.saveAccount(email, displayName);
}

// Load saved accounts for UI
final savedAccounts = await SavedAccountsService.getSavedAccounts();

// Get last used email for pre-population
final lastEmail = await SavedAccountsService.getLastUsedEmail();
```

### For Users

1. **Enable**: Check "Remember me" during login
2. **Select**: Use dropdown to choose from saved accounts
3. **Remove**: Long-press any account in dropdown to remove
4. **Disable**: Uncheck "Remember me" to clear all saved accounts

## Future Enhancements

### Possible Improvements

- **Biometric Authentication**: Add fingerprint/face unlock for saved accounts
- **Account Categories**: Organize accounts by type (work, personal, etc.)
- **Account Sync**: Optional cloud sync of saved accounts (with encryption)
- **Quick Switch**: Add account switcher in app header
- **Account Profiles**: Save additional preferences per account

### Performance Optimizations

- **Lazy Loading**: Load saved accounts only when needed
- **Caching**: Cache frequently accessed account data
- **Background Cleanup**: Periodic cleanup of old unused accounts

## Migration Guide

### For Existing Users

- No migration needed - feature is opt-in
- Existing users will see the new "Remember me" option on next login
- No impact on current authentication flow

### For Developers

- Import the new service: `import '../services/saved_accounts_service.dart'`
- Initialize in main(): `await SavedAccountsService.init()`
- Use in authentication flow as shown in `authentication.dart`

## Troubleshooting

### Common Issues

1. **Accounts not saving**: Ensure "Remember me" is checked before login
2. **Dropdown not showing**: Verify accounts exist and user is on login screen
3. **Cannot remove accounts**: Use long-press gesture on account items
4. **Too many accounts**: Service automatically limits to 5 most recent

### Debug Information

- Check SharedPreferences for `saved_accounts` key
- Verify `remember_me_enabled` boolean value
- Monitor `last_used_email` for proper tracking

## Conclusion

The save account feature enhances user experience while maintaining security best practices. It provides convenient access to frequently used accounts without compromising password security, making the app more user-friendly for regular users.
