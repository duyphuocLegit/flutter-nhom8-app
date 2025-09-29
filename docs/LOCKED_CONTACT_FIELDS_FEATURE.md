<!-- @format -->

# Locked Contact Fields Feature

## Overview

This feature ensures that authenticated users have their name and email fields automatically locked in the contact form, preventing them from changing their identity when submitting contact messages. This improves security and ensures consistency in user identity.

## Implementation Details

### Core Changes Made

#### 1. Contact Form Field Locking (`lib/screens/contact_us.dart`)

**Changes:**

- Name and email fields are now automatically locked (`readOnly: true`) for authenticated users
- Fields show a lock icon to indicate they are protected
- Hint text changes to "Locked to current user" for authenticated users
- Added defensive programming to handle cases where Firebase isn't available (like in tests)
- **Enhanced message validation** with robust error handling and quality checks

**Key Features:**

- **Auto-population**: User's name and email are automatically filled from their profile
- **Field Locking**: Authenticated users cannot edit name/email fields
- **Visual Indicators**: Lock icons and specialized hint text show field status
- **Fallback Handling**: Graceful handling when Firebase is unavailable
- **Better Validation**: Custom error messages for locked fields

#### 2. Enhanced Settings Service (`lib/services/setting_service.dart`)

**New Setting Added:**

- `lockContactInfo`: Boolean setting to control contact field locking behavior
- Defaults to `true` (always lock for authenticated users)
- Syncs to cloud for cross-device consistency
- Can be used for future admin controls

#### 3. Improved User Data Loading

**Robust Data Fetching:**

- Tries Firestore user profile first
- Falls back to Firebase Auth user data
- Handles errors gracefully
- Prevents crashes in test environments

#### 4. Enhanced Message Validation

**Comprehensive Message Validation:**

- **Minimum Length**: Enforces at least 10 characters with character count feedback
- **Maximum Length**: Validates against 500 character limit
- **Content Quality**: Prevents messages with only repeated characters
- **Basic Content**: Ensures messages contain letters or numbers
- **Exception Handling**: Robust error handling for validation failures
- **Double Validation**: Client-side and pre-submission validation layers

### Technical Implementation

#### Authentication Check Method

```dart
bool _isUserAuthenticated() {
  try {
    return FirebaseService.currentUser != null;
  } catch (e) {
    // If Firebase is not initialized or there's any error, return false
    return false;
  }
}
```

#### Field Locking Logic

```dart
TextFormField(
  controller: _nameController,
  enabled: !_isLoading,
  readOnly: _isUserAuthenticated(), // Lock if user is authenticated
  decoration: InputDecoration(
    labelText: 'Name *',
    hintText: _isUserAuthenticated()
        ? 'Locked to current user'
        : 'Enter your name',
    suffixIcon: _isUserAuthenticated()
        ? Icon(Icons.lock, color: Colors.grey.shade600)
        : null,
  ),
)
```

#### Form Clearing Behavior

```dart
void _clearForm() {
  // Only clear name and email if user is not authenticated
  if (!_isUserAuthenticated()) {
    _nameController.clear();
    _emailController.clear();
  }
  _messageController.clear(); // Always clear message
}
```

#### Enhanced Message Validation

```dart
String? _validateMessage(String? value) {
  try {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your message';
    }

    final trimmedValue = value.trim();

    // Minimum length check with character count
    if (trimmedValue.length < 10) {
      return 'Message must be at least 10 characters (currently ${trimmedValue.length})';
    }

    // Check for meaningful content (not just repeated characters)
    final uniquePattern = trimmedValue.replaceAll(RegExp(r'(.)\1*'), '\$1');
    if (uniquePattern.length < 5) {
      return 'Please enter a meaningful message (avoid repeated characters)';
    }

    // Ensure basic content quality
    if (!RegExp(r'[a-zA-Z0-9]').hasMatch(trimmedValue)) {
      return 'Message must contain letters or numbers';
    }

    return null; // Valid message
  } catch (e) {
    return 'Invalid message format. Please try again.';
  }
}
```

### User Experience

#### For Authenticated Users:

1. **Automatic Population**: Name and email auto-fill from account
2. **Visual Lock Indicators**: Lock icons show fields are protected
3. **Clear Messaging**: Info banner explains field locking
4. **Consistent Identity**: Cannot send messages with different identity
5. **Security**: Prevents impersonation or accidental identity changes

#### For Guest Users:

1. **Full Control**: Can enter any name and email
2. **Standard Validation**: Normal form validation applies
3. **No Restrictions**: Complete freedom to fill form fields

### Security Benefits

1. **Identity Consistency**: Authenticated users cannot impersonate others
2. **Audit Trail**: All contact messages have consistent user identity
3. **Admin Trust**: Admins can trust the sender identity for authenticated users
4. **Data Integrity**: Reduces possibility of user error or malicious impersonation

### Settings Integration

The feature includes a new setting `lockContactInfo` that:

- Defaults to `true` (always lock fields)
- Can be configured per user
- Syncs across devices via Firebase
- Enables future admin controls if needed

### Error Handling

1. **Firebase Unavailable**: Gracefully handles when Firebase isn't initialized
2. **User Data Missing**: Falls back to Firebase Auth data if Firestore profile is empty
3. **Network Issues**: Continues to work with cached user data
4. **Test Environment**: Safe to use in unit tests without Firebase setup

### Testing Considerations

The implementation is test-friendly:

- Doesn't crash when Firebase isn't available
- Uses defensive programming patterns
- Helper method `_isUserAuthenticated()` handles all edge cases
- Maintains functionality in test environments

## Usage

### For Users

1. **Logged In**: Name/email automatically filled and locked
2. **Guest**: Can enter any name/email freely
3. **Clear Indication**: Visual cues show when fields are locked

### For Developers

1. **Easy Testing**: Works in test environments without Firebase
2. **Configurable**: Setting can control behavior if needed
3. **Maintainable**: Clean separation of concerns
4. **Extensible**: Can be extended for other forms easily

## Future Enhancements

1. **Admin Override**: Allow admins to bypass field locking
2. **Temporary Unlock**: Provide option for users to unlock fields temporarily
3. **Organization Contacts**: Support for organization-level contact identities
4. **Multi-Profile**: Support for users with multiple contact profiles
5. **Audit Logging**: Track when fields are locked/unlocked

## Files Modified

1. `lib/screens/contact_us.dart` - Main contact form implementation
2. `lib/services/setting_service.dart` - Added contact locking settings
3. `docs/LOCKED_CONTACT_FIELDS_FEATURE.md` - This documentation

## Backward Compatibility

- Existing functionality remains unchanged for guest users
- Authenticated users get enhanced security automatically
- No breaking changes to existing APIs
- Settings default to secure behavior
