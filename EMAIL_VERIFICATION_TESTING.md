<!-- @format -->

# Email Verification Testing Guide

## Test Email: duyyphuoc2@gmail.com

This guide provides steps to manually test the email verification feature using the email `duyyphuoc2@gmail.com`.

## Prerequisites

- Flutter app is running on device/emulator
- Firebase project is configured
- Test account exists or can be created

## Test Scenarios

### Scenario 1: New User Registration

1. Open the app
2. Switch to "Sign Up" mode
3. Enter email: `duyyphuoc2@gmail.com`
4. Enter a password (e.g., `testpassword123`)
5. Enter name (e.g., `Test User`)
6. Click "Sign Up"
7. **Expected**: App navigates to email verification screen
8. Check email `duyyphuoc2@gmail.com` for verification link
9. Click the verification link in email
10. Return to app
11. Click "Tôi đã xác thực – Kiểm tra lại"
12. **Expected**: App navigates to home screen

### Scenario 2: Existing Unverified User Login

1. Open the app
2. Ensure in "Login" mode
3. Enter email: `duyyphuoc2@gmail.com`
4. Enter the password used during registration
5. Click "Login"
6. **Expected**: App navigates to email verification screen (not home screen)
7. Check email for verification link
8. Complete verification as in Scenario 1

### Scenario 3: Already Verified User Login

1. Complete verification for `duyyphuoc2@gmail.com` first
2. Restart the app or logout/login again
3. Enter email: `duyyphuoc2@gmail.com`
4. Enter password
5. Click "Login"
6. **Expected**: App navigates directly to home screen (no verification screen)

## Testing Features

### Email Verification Screen

- ✅ Displays correct email address
- ✅ Shows Vietnamese instructions
- ✅ Manual check button works
- ✅ Resend button has 30-second cooldown
- ✅ Sign out button works

### Authentication Flow

- ✅ Verified users skip verification screen
- ✅ Unverified users see verification screen
- ✅ No duplicate verification emails sent

### Error Handling

- ✅ Invalid email format rejected
- ✅ Network errors handled gracefully
- ✅ Firebase errors displayed properly

## Automated Tests

Run the automated tests:

```bash
flutter test test/email_verification_test.dart
```

## Notes

- The app uses `userChanges()` stream for better responsiveness to verification status changes
- Verification emails are sent in Vietnamese
- Polling checks verification status every 3 seconds
- Already verified users don't receive duplicate emails
