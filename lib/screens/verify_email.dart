import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/email_verification_service.dart';
import 'home.dart';
import 'authentication.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;
  const VerifyEmailScreen({super.key, required this.email});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _sending = false;
  bool _checking = false;
  int _cooldown = 0;
  Timer? _cooldownTimer;
  Timer? _pollTimer;
  StreamSubscription<User?>? _authSubscription;

  @override
  void initState() {
    super.initState();
    // Listen to auth state changes for immediate verification detection
    _authSubscription = EmailVerificationService.authStateChanges.listen((
      user,
    ) {
      if (user != null && user.emailVerified && mounted) {
        _authSubscription?.cancel();
        _pollTimer?.cancel();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const MyHomePage()),
          (_) => false,
        );
      }
    });

    // Fallback polling every 3 seconds
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      final ok = await EmailVerificationService.reloadAndIsVerified();
      if (!mounted) return;
      if (ok) {
        _authSubscription?.cancel();
        _pollTimer?.cancel();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const MyHomePage()),
          (_) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _pollTimer?.cancel();
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> _resend() async {
    if (_cooldown > 0) return;
    setState(() {
      _sending = true;
      _cooldown = 30;
    });
    try {
      await EmailVerificationService.sendVerificationEmail();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã gửi lại email xác thực.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi gửi mail: $e')));
    } finally {
      if (!mounted) return;
      setState(() => _sending = false);
      _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (!mounted) {
          t.cancel();
          return;
        }
        setState(() {
          _cooldown--;
          if (_cooldown <= 0) {
            _cooldown = 0;
            t.cancel();
          }
        });
      });
    }
  }

  Future<void> _manualCheck() async {
    setState(() => _checking = true);
    try {
      final ok = await EmailVerificationService.reloadAndIsVerified();
      if (!mounted) return;
      if (ok) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const MyHomePage()),
          (_) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email chưa được xác thực.')),
        );
      }
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  Future<void> _signOut() async {
    await EmailVerificationService.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AuthScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.email;
    return Scaffold(
      appBar: AppBar(title: const Text('Xác thực email')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.mark_email_unread, size: 64),
                const SizedBox(height: 12),
                Text(
                  'Đã gửi liên kết xác thực tới:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  email,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Hãy mở email và click vào đường link để kích hoạt tài khoản.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sau khi xác thực, quay lại ứng dụng và nhấn "Kiểm tra lại". Nếu không hoạt động, hãy khởi động lại ứng dụng.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _checking ? null : _manualCheck,
                  child: _checking
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Tôi đã xác thực – Kiểm tra lại'),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: (_sending || _cooldown > 0) ? null : _resend,
                  child: _sending
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          _cooldown > 0
                              ? 'Gửi lại sau ${_cooldown}s'
                              : 'Gửi lại email xác thực',
                        ),
                ),
                const SizedBox(height: 8),
                TextButton(onPressed: _signOut, child: const Text('Đăng xuất')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
