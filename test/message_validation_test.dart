import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:nhom10/screens/contact_us.dart';

void main() {
  group('Message Validation Tests', () {
    testWidgets('should show enhanced message validation errors', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: ContactUsScreen()));

      // Open the contact dialog
      await tester.scrollUntilVisible(find.text('Send Message'), 500.0);
      await tester.tap(find.text('Send Message'));
      await tester.pumpAndSettle();

      // Test 1: Empty message
      final sendButtonFinder = find.descendant(
        of: find.byType(AlertDialog),
        matching: find.widgetWithText(ElevatedButton, 'Send'),
      );

      await tester.tap(sendButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Please enter your message'), findsOneWidget);

      // Test 2: Message too short (less than 10 characters)
      final messageField = find.widgetWithText(
        TextFormField,
        'Type your message here...',
      );
      await tester.enterText(messageField, 'Short');
      await tester.tap(sendButtonFinder);
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Message must be at least 10 characters'),
        findsOneWidget,
      );
      expect(find.textContaining('currently 5'), findsOneWidget);

      // Test 3: Repeated characters
      await tester.enterText(messageField, 'aaaaaaaaaa');
      await tester.tap(sendButtonFinder);
      await tester.pumpAndSettle();

      expect(
        find.text(
          'Please enter a meaningful message (avoid repeated characters)',
        ),
        findsOneWidget,
      );

      // Test 4: Only special characters
      await tester.enterText(messageField, '!@#\$%^&*()');
      await tester.tap(sendButtonFinder);
      await tester.pumpAndSettle();

      expect(
        find.text('Message must contain letters or numbers'),
        findsOneWidget,
      );

      // Test 5: Valid message (should pass validation)
      await tester.enterText(
        messageField,
        'This is a valid message with enough characters',
      );
      await tester.tap(sendButtonFinder);
      await tester.pumpAndSettle();

      // Should not show any validation errors for this valid message
      expect(find.text('Please enter your message'), findsNothing);
      expect(
        find.textContaining('Message must be at least 10 characters'),
        findsNothing,
      );
      expect(
        find.text(
          'Please enter a meaningful message (avoid repeated characters)',
        ),
        findsNothing,
      );
      expect(
        find.text('Message must contain letters or numbers'),
        findsNothing,
      );
    });

    testWidgets('should show character count in validation message', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: ContactUsScreen()));

      await tester.scrollUntilVisible(find.text('Send Message'), 500.0);
      await tester.tap(find.text('Send Message'));
      await tester.pumpAndSettle();

      final messageField = find.widgetWithText(
        TextFormField,
        'Type your message here...',
      );
      final sendButtonFinder = find.descendant(
        of: find.byType(AlertDialog),
        matching: find.widgetWithText(ElevatedButton, 'Send'),
      );

      // Test different message lengths
      await tester.enterText(messageField, 'Hi'); // 2 characters
      await tester.tap(sendButtonFinder);
      await tester.pumpAndSettle();
      expect(find.textContaining('currently 2'), findsOneWidget);

      await tester.enterText(messageField, 'Hello'); // 5 characters
      await tester.tap(sendButtonFinder);
      await tester.pumpAndSettle();
      expect(find.textContaining('currently 5'), findsOneWidget);

      await tester.enterText(messageField, 'Almost'); // 6 characters
      await tester.tap(sendButtonFinder);
      await tester.pumpAndSettle();
      expect(find.textContaining('currently 6'), findsOneWidget);
    });
  });
}
