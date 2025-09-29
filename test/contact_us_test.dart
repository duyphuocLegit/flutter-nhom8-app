import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:nhom10/screens/contact_us.dart';

void main() {
  group('ContactUsScreen Tests', () {
    testWidgets('should display contact us screen correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: ContactUsScreen()));

      expect(find.text('Contact Us'), findsOneWidget);
      expect(find.text('Get in Touch'), findsOneWidget);
      expect(find.text('Send Message'), findsOneWidget);
    });

    testWidgets(
      'should show message dialog when send message button is tapped',
      (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: ContactUsScreen()));

        // Scroll to make the button visible
        await tester.scrollUntilVisible(find.text('Send Message'), 500.0);

        // Tap the send message button
        await tester.tap(find.text('Send Message'));
        await tester.pumpAndSettle();

        // Check if dialog is shown with form fields
        expect(find.text('Name *'), findsOneWidget);
        expect(find.text('Email *'), findsOneWidget);
        expect(find.text('Message *'), findsOneWidget);
      },
    );

    testWidgets('should show validation errors for empty fields', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: ContactUsScreen()));

      // Scroll to make the button visible and open dialog
      await tester.scrollUntilVisible(find.text('Send Message'), 500.0);
      await tester.tap(find.text('Send Message'));
      await tester.pumpAndSettle();

      // Find the Send button in the dialog (not the screen button)
      final sendButtonFinder = find.descendant(
        of: find.byType(AlertDialog),
        matching: find.widgetWithText(ElevatedButton, 'Send'),
      );

      // Try to send without filling fields
      await tester.tap(sendButtonFinder);
      await tester.pumpAndSettle();

      // Check for validation errors
      expect(find.text('Please enter your name'), findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your message'), findsOneWidget);
    });

    testWidgets('should show email validation error for invalid email', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: ContactUsScreen()));

      // Scroll to make the button visible and open dialog
      await tester.scrollUntilVisible(find.text('Send Message'), 500.0);
      await tester.tap(find.text('Send Message'));
      await tester.pumpAndSettle();

      // Fill name and invalid email
      final nameField = find.widgetWithText(TextFormField, 'Enter your name');
      final emailField = find.widgetWithText(TextFormField, 'Enter your email');

      await tester.enterText(nameField, 'Test Name');
      await tester.enterText(emailField, 'invalid-email');

      // Find the Send button in the dialog
      final sendButtonFinder = find.descendant(
        of: find.byType(AlertDialog),
        matching: find.widgetWithText(ElevatedButton, 'Send'),
      );

      await tester.tap(sendButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('should clear form when cancel is pressed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: ContactUsScreen()));

      // Open dialog
      await tester.scrollUntilVisible(find.text('Send Message'), 500.0);
      await tester.tap(find.text('Send Message'));
      await tester.pumpAndSettle();

      // Fill some fields
      final nameField = find.widgetWithText(TextFormField, 'Enter your name');
      await tester.enterText(nameField, 'Test Name');

      // Cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Open dialog again and check fields are empty
      await tester.tap(find.text('Send Message'));
      await tester.pumpAndSettle();

      final nameFieldWidget = tester.widget<TextFormField>(nameField);
      expect(nameFieldWidget.controller?.text, isEmpty);
    });
  });
}
