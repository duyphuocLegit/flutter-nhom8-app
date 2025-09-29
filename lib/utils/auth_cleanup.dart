import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthCleanup {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Completely reset authentication state - use this for debugging only
  static Future<void> completeAuthReset() async {
    try {
      print('Starting complete auth reset...');

      // Sign out current user if any
      if (_auth.currentUser != null) {
        await _auth.signOut();
        print('Signed out current user');
      }

      // Clear any cached credentials
      await Future.delayed(const Duration(milliseconds: 500));

      print('Auth reset complete');
    } catch (e) {
      print('Auth reset error: $e');
    }
  }

  /// Check if an email exists
  static Future<Map<String, dynamic>> debugEmailStatus(String email) async {
    try {
      final methods = await _auth.fetchSignInMethodsForEmail(email);
      return {
        'exists': methods.isNotEmpty,
        'methods': methods,
        'timestamp': DateTime.now().toString(),
      };
    } catch (e) {
      return {'error': e.toString(), 'timestamp': DateTime.now().toString()};
    }
  }

  /// Force clean up a specific email (for development only)
  static Future<String> forceCleanupEmail(String email, String password) async {
    try {
      print('Attempting force cleanup for: $email');

      // Try to sign in and delete
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        final user = credential.user!;
        await user.reload();

        print('User status - UID: ${user.uid}');

        // Delete Firestore data first
        try {
          await _firestore.collection('users').doc(user.uid).delete();
          print('Deleted Firestore user profile');
        } catch (e) {
          print('No Firestore profile to delete: $e');
        }

        // Delete all user tasks
        try {
          final tasksQuery = await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('tasks')
              .get();

          for (var doc in tasksQuery.docs) {
            await doc.reference.delete();
          }
          print('Deleted ${tasksQuery.docs.length} user tasks');
        } catch (e) {
          print('No tasks to delete: $e');
        }

        // Delete the user account
        await user.delete();
        print('Successfully deleted user account');

        return 'success';
      }

      return 'no_user';
    } catch (e) {
      print('Force cleanup error: $e');
      if (e.toString().contains('wrong-password')) {
        return 'wrong_password';
      } else if (e.toString().contains('user-not-found')) {
        return 'user_not_found';
      } else {
        return 'error: $e';
      }
    }
  }
}
