import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

// class EmailVerificationService {
//   static final _auth = FirebaseAuth.instance;

//   /// Gửi email xác thực cho user hiện tại (nếu chưa xác thực)
//   static Future<void> sendVerificationEmail() async {
//     final user = _auth.currentUser;
//     if (user == null) {
//       throw Exception('No signed-in user to send verification email to.');
//     }
//     if (user.emailVerified) return; // đã xác thực thì khỏi gửi
//     await user.sendEmailVerification();
//   }

//   /// Reload user và trả về trạng thái đã xác thực chưa
//   static Future<bool> reloadAndIsVerified() async {
//     await _auth.currentUser?.reload();
//     return _auth.currentUser?.emailVerified ?? false;
//   }

//   static User? get currentUser => _auth.currentUser;
//   static Future<void> signOut() => _auth.signOut();
// }

class EmailVerificationService {
  static final _auth = FirebaseAuth.instance;

  static Future<void> sendVerificationEmail() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No signed-in user.');
    if (user.emailVerified) return;
    await _auth.setLanguageCode('vi'); // email tiếng Việt
    await user.sendEmailVerification(); // dùng template Firebase (có nút)
    debugPrint('Verification email sent to: ${user.email}');
  }

  static Future<bool> reloadAndIsVerified() async {
    await _auth.currentUser?.reload();
    final isVerified = _auth.currentUser?.emailVerified ?? false;
    debugPrint(
      'Email verification status: $isVerified for user: ${_auth.currentUser?.email}',
    );
    return isVerified;
  }

  /// Listen to auth state changes for more reliable verification detection
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  static Future<void> signOut() => _auth.signOut();
}
