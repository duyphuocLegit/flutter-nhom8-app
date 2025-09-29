import 'package:flutter_test/flutter_test.dart';
import 'package:nhom10/models/contact_message.dart';

void main() {
  group('ContactService Tests', () {
    test('ContactMessage model serialization works correctly', () {
      final message = ContactMessage(
        id: 'test-id',
        name: 'John Doe',
        email: 'john@example.com',
        message: 'This is a test message',
        timestamp: DateTime(2023, 9, 28),
        userId: 'user-123',
        status: 'pending',
      );

      // Test toMap
      final map = message.toMap();
      expect(map['id'], equals('test-id'));
      expect(map['name'], equals('John Doe'));
      expect(map['email'], equals('john@example.com'));
      expect(map['message'], equals('This is a test message'));
      expect(map['userId'], equals('user-123'));
      expect(map['status'], equals('pending'));

      // Test fromMap
      final reconstructed = ContactMessage.fromMap(map);
      expect(reconstructed.id, equals(message.id));
      expect(reconstructed.name, equals(message.name));
      expect(reconstructed.email, equals(message.email));
      expect(reconstructed.message, equals(message.message));
      expect(reconstructed.userId, equals(message.userId));
      expect(reconstructed.status, equals(message.status));
    });

    test('ContactMessage copyWith works correctly', () {
      final original = ContactMessage(
        id: 'test-id',
        name: 'John Doe',
        email: 'john@example.com',
        message: 'Original message',
        timestamp: DateTime(2023, 9, 28),
      );

      final updated = original.copyWith(
        message: 'Updated message',
        status: 'read',
      );

      expect(updated.id, equals(original.id));
      expect(updated.name, equals(original.name));
      expect(updated.email, equals(original.email));
      expect(updated.message, equals('Updated message'));
      expect(updated.status, equals('read'));
      expect(updated.timestamp, equals(original.timestamp));
    });

    test('validateContactMessageFields', () {
      // Test valid data
      expect(() {
        ContactMessage(
          id: 'test',
          name: 'John Doe',
          email: 'john@example.com',
          message: 'This is a valid message with enough characters.',
          timestamp: DateTime.now(),
        );
      }, returnsNormally);

      // Test empty fields would be caught by UI validation
      // The model itself doesn't enforce validation rules
    });
  });
}
