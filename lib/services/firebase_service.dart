import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../models/task_model.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Current user
  static User? get currentUser => _auth.currentUser;
  static String? get currentUserId => _auth.currentUser?.uid;

  // Authentication Methods
  static Future<UserCredential?> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      // Validate input
      if (email.trim().isEmpty) {
        throw Exception('Email cannot be empty');
      }
      if (password.isEmpty) {
        throw Exception('Password cannot be empty');
      }

      final result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Ensure user is properly loaded
      await result.user?.reload();
      return result;
    } catch (e) {
      print('Sign in error: $e');
      throw e; // Re-throw to handle in UI
    }
  }

  static Future<UserCredential?> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Ensure user is properly loaded
      await result.user?.reload();
      return result;
    } catch (e) {
      print('Sign up error: $e');
      throw e; // Re-throw to handle in UI
    }
  }

  static Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Sign out error: $e');
      throw e;
    }
  }

  // User Profile Methods
  static Future<void> createUserProfile(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toMap());
    } catch (e) {
      print('Create user profile error: $e');
      throw e; // Re-throw to handle in UI
    }
  }

  static Future<UserModel?> getUserProfile(String uid) async {
    try {
      if (uid.isEmpty) return null;

      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Get user profile error: $e');
    }
    return null;
  }

  static Future<void> updateUserProfile(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).update(user.toMap());
    } catch (e) {
      print('Update user profile error: $e');
      throw e;
    }
  }

  // Task Methods
  static Future<String?> addTask(TaskItemModel task) async {
    try {
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      DocumentReference docRef = await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('tasks')
          .add(task.toMap());
      return docRef.id;
    } catch (e) {
      print('Add task error: $e');
      return null;
    }
  }

  static Future<List<TaskItemModel>> getUserTasks() async {
    try {
      if (currentUserId == null) {
        return [];
      }

      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('tasks')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return TaskItemModel.fromMap(data);
      }).toList();
    } catch (e) {
      print('Get tasks error: $e');
      return [];
    }
  }

  static Future<void> updateTask(TaskItemModel task) async {
    try {
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('tasks')
          .doc(task.id)
          .update(task.toMap());
    } catch (e) {
      print('Update task error: $e');
      throw e;
    }
  }

  static Future<void> deleteTask(String taskId) async {
    try {
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('tasks')
          .doc(taskId)
          .delete();
    } catch (e) {
      print('Delete task error: $e');
      throw e;
    }
  }

  // Task Statistics
  static Future<Map<String, int>> getTaskStats() async {
    try {
      if (currentUserId == null) {
        return {'completed': 0, 'pending': 0, 'total': 0};
      }

      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('tasks')
          .get();

      int completed = 0;
      int pending = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          TaskItemModel task = TaskItemModel.fromMap(data);
          if (task.isCompleted) {
            completed++;
          } else {
            pending++;
          }
        }
      }

      return {
        'completed': completed,
        'pending': pending,
        'total': snapshot.docs.length,
      };
    } catch (e) {
      print('Get task stats error: $e');
      return {'completed': 0, 'pending': 0, 'total': 0};
    }
  }

  // Get recent tasks
  static Future<List<TaskItemModel>> getRecentTasks(int limit) async {
    try {
      if (currentUserId == null) {
        return [];
      }

      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('tasks')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return TaskItemModel.fromMap(data);
      }).toList();
    } catch (e) {
      print('Get recent tasks error: $e');
      return [];
    }
  }

  // Re-authenticate user with password for sensitive operations
  static Future<void> reauthenticateUser(String password) async {
    try {
      final user = currentUser;
      if (user == null || user.email == null) {
        throw Exception('No user to re-authenticate');
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
      print('User re-authenticated successfully');
    } catch (e) {
      print('Re-authentication error: $e');
      throw e;
    }
  }

  // Delete user account and all associated data
  static Future<void> deleteUserAccount() async {
    try {
      final user = currentUser;
      if (user == null) {
        throw Exception('No user to delete');
      }

      final userId = user.uid;
      print('Starting account deletion for user: $userId');

      // Step 1: Delete all user tasks
      print('Deleting user tasks...');
      final tasksQuery = await _firestore
          .collection('users')
          .doc(userId)
          .collection('tasks')
          .get();

      final batch = _firestore.batch();
      for (var doc in tasksQuery.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      print('Deleted ${tasksQuery.docs.length} tasks');

      // Step 2: Delete user profile and settings
      print('Deleting user profile...');
      await _firestore.collection('users').doc(userId).delete();

      // Step 3: Delete Firebase Auth user (this must be done last)
      print('Deleting Firebase Auth user...');
      await user.delete();

      print('Account deletion completed successfully');
    } catch (e) {
      print('Delete user account error: $e');
      rethrow;
    }
  }
}
