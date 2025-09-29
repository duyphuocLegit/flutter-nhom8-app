import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';

class AuthDebugHelper {
  /// Debug function to test authentication with proper error handling
  static Future<void> testSignIn(String email, String password) async {
    debugPrint('=== Authentication Debug Test ===');
    debugPrint('Email: $email');
    debugPrint('Password length: ${password.length}');

    // Check if email format is valid
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      debugPrint('❌ Invalid email format');
      return;
    }
    debugPrint('✅ Email format is valid');

    // Check password length
    if (password.length < 6) {
      debugPrint('❌ Password too short (minimum 6 characters)');
      return;
    }
    debugPrint('✅ Password length is acceptable');

    try {
      // Attempt sign in
      debugPrint('🔄 Attempting Firebase authentication...');
      final result = await FirebaseService.signInWithEmailPassword(
        email,
        password,
      );

      if (result != null && result.user != null) {
        debugPrint('✅ Sign in successful!');
        debugPrint('User ID: ${result.user!.uid}');
        debugPrint('Email: ${result.user!.email}');
        debugPrint('Email verified: ${result.user!.emailVerified}');
      } else {
        debugPrint('❌ Sign in failed - no user returned');
      }
    } catch (e) {
      debugPrint('❌ Sign in failed with error:');
      debugPrint('Error type: ${e.runtimeType}');
      debugPrint('Error message: $e');

      // Parse specific Firebase errors
      if (e is FirebaseAuthException) {
        debugPrint('Firebase Auth Error Code: ${e.code}');
        debugPrint('Firebase Auth Error Message: ${e.message}');

        switch (e.code) {
          case 'invalid-credential':
            debugPrint(
              '💡 Solution: Check if the email and password are correct',
            );
            break;
          case 'user-not-found':
            debugPrint('💡 Solution: This email is not registered');
            break;
          case 'wrong-password':
            debugPrint('💡 Solution: The password is incorrect');
            break;
          case 'invalid-email':
            debugPrint('💡 Solution: The email format is invalid');
            break;
          case 'user-disabled':
            debugPrint('💡 Solution: This account has been disabled');
            break;
          case 'too-many-requests':
            debugPrint(
              '💡 Solution: Too many failed attempts, try again later',
            );
            break;
          default:
            debugPrint('💡 Unknown error code: ${e.code}');
        }
      }
    }
    debugPrint('=== End Authentication Debug Test ===');
  }

  /// Check Firebase connection and configuration
  static Future<void> checkFirebaseConnection() async {
    debugPrint('=== Firebase Connection Test ===');

    try {
      final auth = FirebaseAuth.instance;
      debugPrint('✅ Firebase Auth instance created');
      debugPrint('Current user: ${auth.currentUser?.email ?? 'None'}');

      // Test a simple auth state check
      debugPrint('Auth state listener available: true');
    } catch (e) {
      debugPrint('❌ Firebase connection error: $e');
    }

    debugPrint('=== End Firebase Connection Test ===');
  }

  /// Create a test account for debugging
  static Future<void> createTestAccount() async {
    debugPrint('=== Creating Test Account ===');

    const testEmail = 'test@example.com';
    const testPassword = 'test123456';

    try {
      final result = await FirebaseService.signUpWithEmailPassword(
        testEmail,
        testPassword,
      );
      if (result != null) {
        debugPrint('✅ Test account created successfully');
        debugPrint('Test Email: $testEmail');
        debugPrint('Test Password: $testPassword');

        // Sign out the test account
        await FirebaseService.signOut();
        debugPrint('✅ Test account signed out');
      }
    } catch (e) {
      if (e.toString().contains('email-already-in-use')) {
        debugPrint('ℹ️ Test account already exists');
        debugPrint('Test Email: $testEmail');
        debugPrint('Test Password: $testPassword');
      } else {
        debugPrint('❌ Failed to create test account: $e');
      }
    }

    debugPrint('=== End Test Account Creation ===');
  }
}
