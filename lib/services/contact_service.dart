import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/contact_message.dart';
import '../services/firebase_service.dart';

class ContactService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'contact_messages';

  /// Save a contact message to Firebase Firestore
  /// Option 1: Save to separate collection (current approach - RECOMMENDED)
  static Future<bool> saveContactMessage({
    required String name,
    required String email,
    required String message,
  }) async {
    try {
      // Generate a unique ID for the message
      final docRef = _firestore.collection(_collection).doc();

      final contactMessage = ContactMessage(
        id: docRef.id,
        name: name.trim(),
        email: email.trim().toLowerCase(),
        message: message.trim(),
        timestamp: DateTime.now(),
        userId: FirebaseService.currentUserId, // Include if user is logged in
      );

      await docRef.set(contactMessage.toMap());

      print('Contact message saved successfully with ID: ${docRef.id}');
      return true;
    } catch (e) {
      print('Error saving contact message: $e');
      return false;
    }
  }

  /// Option 2: Save under user document (alternative approach)
  static Future<bool> saveContactMessageUnderUser({
    required String name,
    required String email,
    required String message,
  }) async {
    try {
      final userId = FirebaseService.currentUserId;
      if (userId == null) {
        throw Exception(
          'User must be authenticated to save message under user',
        );
      }

      // Generate a unique ID for the message
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('contact_messages')
          .doc();

      final contactMessage = ContactMessage(
        id: docRef.id,
        name: name.trim(),
        email: email.trim().toLowerCase(),
        message: message.trim(),
        timestamp: DateTime.now(),
        userId: userId,
      );

      await docRef.set(contactMessage.toMap());

      print('Contact message saved under user with ID: ${docRef.id}');
      return true;
    } catch (e) {
      print('Error saving contact message under user: $e');
      return false;
    }
  }

  /// Get all contact messages (admin functionality)
  static Future<List<ContactMessage>> getAllContactMessages() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ContactMessage.fromMap(data);
      }).toList();
    } catch (e) {
      print('Error getting contact messages: $e');
      return [];
    }
  }

  /// Get contact messages for current user (from separate collection)
  static Future<List<ContactMessage>> getUserContactMessages() async {
    try {
      final userId = FirebaseService.currentUserId;
      if (userId == null) return [];

      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ContactMessage.fromMap(data);
      }).toList();
    } catch (e) {
      print('Error getting user contact messages: $e');
      return [];
    }
  }

  /// Get contact messages for current user (from under user document)
  static Future<List<ContactMessage>>
  getUserContactMessagesFromUserDoc() async {
    try {
      final userId = FirebaseService.currentUserId;
      if (userId == null) return [];

      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('contact_messages')
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ContactMessage.fromMap(data);
      }).toList();
    } catch (e) {
      print('Error getting user contact messages from user doc: $e');
      return [];
    }
  }

  /// Get all contact messages from all users (requires collection group query)
  static Future<List<ContactMessage>>
  getAllContactMessagesFromUserDocs() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collectionGroup('contact_messages') // Collection group query
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ContactMessage.fromMap(data);
      }).toList();
    } catch (e) {
      print('Error getting all contact messages from user docs: $e');
      return [];
    }
  }

  /// Update message status (for admin)
  static Future<bool> updateMessageStatus(
    String messageId,
    String status,
  ) async {
    try {
      await _firestore.collection(_collection).doc(messageId).update({
        'status': status,
      });
      return true;
    } catch (e) {
      print('Error updating message status: $e');
      return false;
    }
  }

  /// Delete a contact message
  static Future<bool> deleteContactMessage(String messageId) async {
    try {
      await _firestore.collection(_collection).doc(messageId).delete();
      return true;
    } catch (e) {
      print('Error deleting contact message: $e');
      return false;
    }
  }

  /// Get unread messages count (for admin)
  static Future<int> getUnreadMessagesCount() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('status', isEqualTo: 'pending')
          .get();

      return snapshot.docs.length;
    } catch (e) {
      print('Error getting unread messages count: $e');
      return 0;
    }
  }

  /// Stream for real-time updates (for admin dashboard)
  static Stream<List<ContactMessage>> getContactMessagesStream() {
    return _firestore
        .collection(_collection)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ContactMessage.fromMap(doc.data());
          }).toList();
        });
  }
}
