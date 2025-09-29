// Simple test to demonstrate message validation working
// Run with: flutter test test/validation_demo.dart

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Message Validation Demo', () {
    // This simulates the _validateMessage function from contact_us.dart
    String? validateMessage(String? value) {
      try {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your message';
        }

        final trimmedValue = value.trim();

        // Minimum length check
        if (trimmedValue.length < 10) {
          return 'Message must be at least 10 characters (currently ${trimmedValue.length})';
        }

        // Maximum length check (additional safety)
        if (trimmedValue.length > 500) {
          return 'Message is too long (maximum 500 characters)';
        }

        // Check for meaningful content (not just repeated characters)
        final uniquePattern = trimmedValue.replaceAll(RegExp(r'(.)\1*'), '\$1');
        if (uniquePattern.length < 5) {
          return 'Please enter a meaningful message (avoid repeated characters)';
        }

        // Check for basic content quality (at least some letters or numbers)
        if (!RegExp(r'[a-zA-Z0-9]').hasMatch(trimmedValue)) {
          return 'Message must contain letters or numbers';
        }

        return null; // Valid message
      } catch (e) {
        // Handle any unexpected errors in validation
        return 'Invalid message format. Please try again.';
      }
    }

    test('DEMO: Empty message validation', () {
      final result = validateMessage('');
      print('❌ Empty message: "$result"');
      expect(result, equals('Please enter your message'));
    });

    test('DEMO: Short message validation (5 characters)', () {
      final result = validateMessage('Hello');
      print('❌ Short message (5 chars): "$result"');
      expect(
        result,
        equals('Message must be at least 10 characters (currently 5)'),
      );
    });

    test('DEMO: Short message validation (7 characters)', () {
      final result = validateMessage('Hi there');
      print('❌ Short message (8 chars): "$result"');
      expect(
        result,
        equals('Message must be at least 10 characters (currently 8)'),
      );
    });

    test('DEMO: Repeated characters validation', () {
      final result = validateMessage('aaaaaaaaaa');
      print('❌ Repeated chars: "$result"');
      expect(
        result,
        equals('Please enter a meaningful message (avoid repeated characters)'),
      );
    });

    test('DEMO: Only special characters validation', () {
      final result = validateMessage('!@#\$%^&*()!@#');
      print('❌ Only special chars: "$result"');
      expect(result, equals('Message must contain letters or numbers'));
    });

    test('DEMO: Valid message passes validation', () {
      final result = validateMessage(
        'This is a proper message with enough characters',
      );
      print('✅ Valid message: passes validation (returns null)');
      expect(result, isNull);
    });

    test('DEMO: Another valid message', () {
      final result = validateMessage(
        'Hello, I need help with my account settings please',
      );
      print('✅ Another valid message: passes validation (returns null)');
      expect(result, isNull);
    });

    test('DEMO: Message with numbers is valid', () {
      final result = validateMessage(
        'I have 5 items in my cart and need assistance',
      );
      print('✅ Message with numbers: passes validation (returns null)');
      expect(result, isNull);
    });
  });
}
