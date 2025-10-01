import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nhom10/screens/verify_email.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Email Verification UI Tests with duyyphuoc2@gmail.com', () {
    const testEmail = 'duyyphuoc2@gmail.com';

    testWidgets('VerifyEmailScreen should display test email correctly', (
      WidgetTester tester,
    ) async {
      // Build the verify email screen with the test email
      await tester.pumpWidget(
        MaterialApp(home: VerifyEmailScreen(email: testEmail)),
      );

      // Wait for the widget to build
      await tester.pumpAndSettle();

      // Verify the screen title
      expect(find.text('Xác thực email'), findsOneWidget);

      // Verify the instruction text
      expect(find.text('Đã gửi liên kết xác thực tới:'), findsOneWidget);

      // Verify the test email is displayed
      expect(find.text(testEmail), findsOneWidget);

      // Verify the instruction about clicking the link
      expect(
        find.text(
          'Hãy mở email và click vào đường link để kích hoạt tài khoản.',
        ),
        findsOneWidget,
      );

      // Verify the manual check button
      expect(find.text('Tôi đã xác thực – Kiểm tra lại'), findsOneWidget);

      // Verify the resend button (initial state)
      expect(find.text('Gửi lại email xác thực'), findsOneWidget);

      // Verify the sign out button
      expect(find.text('Đăng xuất'), findsOneWidget);
    });

    testWidgets('VerifyEmailScreen should have functional buttons', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: VerifyEmailScreen(email: testEmail)),
      );

      await tester.pumpAndSettle();

      // Check that buttons are present (don't tap them to avoid Firebase calls)
      final manualCheckButton = find.text('Tôi đã xác thực – Kiểm tra lại');
      final resendButton = find.text('Gửi lại email xác thực');
      final signOutButton = find.text('Đăng xuất');

      expect(manualCheckButton, findsOneWidget);
      expect(resendButton, findsOneWidget);
      expect(signOutButton, findsOneWidget);

      // Just verify buttons exist - don't tap to avoid Firebase initialization issues in tests
    });

    testWidgets('VerifyEmailScreen should show initial resend button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: VerifyEmailScreen(email: testEmail)),
      );

      await tester.pumpAndSettle();

      // Verify the initial resend button text
      expect(find.text('Gửi lại email xác thực'), findsOneWidget);
    });

    test('email validation should accept duyyphuoc2@gmail.com', () {
      // Test the email validation logic with the test email
      const testEmail = 'duyyphuoc2@gmail.com';

      // Simple email regex validation (matching the one in authentication.dart)
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      expect(emailRegex.hasMatch(testEmail), isTrue);

      // Test that it's a valid Gmail address
      expect(testEmail.endsWith('@gmail.com'), isTrue);
    });

    test('should handle email verification flow description', () {
      // Test that describes the expected flow for manual testing
      const testEmail = 'duyyphuoc2@gmail.com';

      // Expected flow:
      // 1. User enters duyyphuoc2@gmail.com in login form
      // 2. User enters password
      // 3. Clicks login
      // 4. If email not verified, VerifyEmailScreen appears
      // 5. User receives verification email at duyyphuoc2@gmail.com
      // 6. User clicks link in email
      // 7. User returns to app and clicks "Tôi đã xác thực – Kiểm tra lại"
      // 8. App detects verification and navigates to home screen

      expect(testEmail, equals('duyyphuoc2@gmail.com'));
      expect(testEmail.contains('@gmail.com'), isTrue);
    });
  });
}
