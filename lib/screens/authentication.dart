import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../services/saved_accounts_service.dart';
import '../models/user_model.dart';
import '../utils/responsive_utils.dart';
import 'home.dart';
import '../services/email_verification_service.dart';
import 'verify_email.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;
  bool _rememberMe = false;
  List<SavedAccount> _savedAccounts = [];
  SavedAccount? _selectedAccount;

  // Add this helper method for email validation
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  void initState() {
    super.initState();
    _initializeAuthScreen();
  }

  Future<void> _initializeAuthScreen() async {
    // Clean up any inconsistent data first
    await SavedAccountsService.cleanupInconsistentData();

    // Then load accounts and settings
    await _loadSavedAccounts();
    await _loadRememberMeSettings();
  }

  Future<void> _loadSavedAccounts() async {
    try {
      // Use Firebase-synced saved accounts for fresh data
      final savedAccounts =
          await SavedAccountsService.getSavedAccountsWithFirebaseSync();
      final lastUsedEmail = await SavedAccountsService.getLastUsedEmail();

      if (mounted) {
        setState(() {
          _savedAccounts = savedAccounts;

          // Only auto-fill if the last used email still exists in saved accounts
          if (lastUsedEmail != null && savedAccounts.isNotEmpty) {
            _selectedAccount = savedAccounts
                .where((account) => account.email == lastUsedEmail)
                .firstOrNull;

            // Only set email if the account still exists in saved accounts
            if (_selectedAccount != null) {
              _emailController.text = _selectedAccount!.email;
            } else {
              // Clear last used email if the account no longer exists
              SavedAccountsService.clearLastUsedEmail();
              _emailController.clear();
            }
          } else if (lastUsedEmail != null && savedAccounts.isEmpty) {
            // If no saved accounts exist but there's a last used email, clear it
            SavedAccountsService.clearLastUsedEmail();
            _emailController.clear();
          }
        });
      }
    } catch (e) {
      debugPrint('Error loading saved accounts: $e');
    }
  }

  Future<void> _loadRememberMeSettings() async {
    try {
      final rememberMe = await SavedAccountsService.isRememberMeEnabled();
      if (mounted) {
        setState(() {
          _rememberMe = rememberMe;
        });
      }
    } catch (e) {
      debugPrint('Error loading remember me settings: $e');
    }
  }

  void _selectSavedAccount(SavedAccount? account) {
    setState(() {
      _selectedAccount = account;
      if (account != null) {
        _emailController.text = account.email;
        _passwordController.clear(); // Clear password for security
      } else {
        _emailController.clear();
        _passwordController.clear();
      }
    });
  }

  Future<void> _removeSavedAccount(SavedAccount account) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Account'),
          content: Text('Remove ${account.email} from saved accounts?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await SavedAccountsService.removeSavedAccount(account.email);
        await _loadSavedAccounts();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account removed'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error removing account: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = ResponsiveUtils.isVerySmallScreen(context);
    final horizontalPadding = ResponsiveUtils.getHorizontalPadding(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(horizontalPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: isSmallScreen ? 20 : 50),

                // Logo/Header
                Center(
                  child: Container(
                    padding: EdgeInsets.all(isSmallScreen ? 12 : 20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
                      ),
                      borderRadius: BorderRadius.circular(
                        isSmallScreen ? 16 : 20,
                      ),
                    ),
                    child: Icon(
                      Icons.task_alt_rounded,
                      size: isSmallScreen ? 36 : 50,
                      color: Colors.white,
                    ),
                  ),
                ),

                SizedBox(height: isSmallScreen ? 16 : 30),

                Center(
                  child: Text(
                    _isLogin ? 'Welcome Back' : 'Create Account',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 20 : 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: isSmallScreen ? 6 : 10),

                Center(
                  child: Text(
                    _isLogin ? 'Sign in to continue' : 'Sign up to start',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: isSmallScreen ? 24 : 40),

                // Saved accounts dropdown (only for login and when accounts exist)
                if (_isLogin && _savedAccounts.isNotEmpty) ...[
                  Container(
                    margin: EdgeInsets.only(bottom: isSmallScreen ? 12 : 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        isSmallScreen ? 8 : 12,
                      ),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<SavedAccount?>(
                        isExpanded: true,
                        value: _selectedAccount,
                        hint: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 12 : 16,
                            vertical: isSmallScreen ? 12 : 16,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.account_circle_outlined,
                                size: isSmallScreen ? 18 : 20,
                                color: Colors.grey.shade600,
                              ),
                              SizedBox(width: isSmallScreen ? 6 : 8),
                              Text(
                                'Select saved account',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 13 : 15,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        items: [
                          // Fixed "Enter email manually" item with proper padding
                          DropdownMenuItem<SavedAccount?>(
                            value: null,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 8 : 12,
                                vertical: isSmallScreen ? 6 : 8,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.edit_outlined,
                                    size: isSmallScreen ? 16 : 18,
                                    color: Colors.grey.shade600,
                                  ),
                                  SizedBox(width: isSmallScreen ? 6 : 8),
                                  Flexible(
                                    child: Text(
                                      'Enter email manually',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 12 : 14,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ..._savedAccounts.map(
                            (account) => DropdownMenuItem<SavedAccount?>(
                              value: account,
                              child: GestureDetector(
                                onLongPress: () => _removeSavedAccount(account),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isSmallScreen ? 8 : 12,
                                    vertical: isSmallScreen ? 6 : 8,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        radius: isSmallScreen ? 10 : 12,
                                        backgroundColor: Colors.blue.shade100,
                                        child: Text(
                                          account.displayName.isNotEmpty
                                              ? account.displayName[0]
                                                    .toUpperCase()
                                              : account.email[0].toUpperCase(),
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? 8 : 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue.shade800,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: isSmallScreen ? 6 : 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (account
                                                .displayName
                                                .isNotEmpty) ...[
                                              Flexible(
                                                child: Text(
                                                  account.displayName,
                                                  style: TextStyle(
                                                    fontSize: isSmallScreen
                                                        ? 11
                                                        : 13,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                              SizedBox(height: 2),
                                            ],
                                            Flexible(
                                              child: Text(
                                                account.email,
                                                style: TextStyle(
                                                  fontSize: isSmallScreen
                                                      ? 9
                                                      : 11,
                                                  color: Colors.grey.shade600,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.more_vert,
                                        size: isSmallScreen ? 14 : 16,
                                        color: Colors.grey.shade400,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                        onChanged: _selectSavedAccount,
                        icon: Padding(
                          padding: EdgeInsets.only(
                            right: isSmallScreen ? 6 : 8,
                          ),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            size: isSmallScreen ? 18 : 20,
                          ),
                        ),
                        // Add these properties to prevent overflow
                        isDense: false,
                        menuMaxHeight: 250,
                        itemHeight: isSmallScreen
                            ? 70
                            : 80, // Set minimum height for content
                        style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                      ),
                    ),
                  ),
                ],

                // Name field (only for signup)
                if (!_isLogin) ...[
                  TextFormField(
                    controller: _nameController,
                    style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: TextStyle(fontSize: isSmallScreen ? 13 : 14),
                      prefixIcon: Icon(
                        Icons.person_outline,
                        size: isSmallScreen ? 20 : 24,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          isSmallScreen ? 8 : 12,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 12 : 16,
                        vertical: isSmallScreen ? 12 : 16,
                      ),
                    ),
                    validator: (value) {
                      if (!_isLogin &&
                          (value == null || value.trim().isEmpty)) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: isSmallScreen ? 12 : 20),
                ],

                // Email field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(fontSize: isSmallScreen ? 13 : 14),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Theme.of(context).primaryColor,
                      size: isSmallScreen ? 20 : 24,
                    ),
                    suffixIcon: _emailController.text.isNotEmpty
                        ? Icon(
                            _isValidEmail(_emailController.text)
                                ? Icons.check_circle
                                : Icons.error,
                            color: _isValidEmail(_emailController.text)
                                ? Colors.green
                                : Colors.red,
                            size: isSmallScreen ? 18 : 20,
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        isSmallScreen ? 8 : 12,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 12 : 16,
                      vertical: isSmallScreen ? 12 : 16,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      // Clear selected account if user manually types a different email
                      if (_selectedAccount != null &&
                          _selectedAccount!.email != value.trim()) {
                        _selectedAccount = null;
                      }

                      // Check if the typed email matches any saved account
                      final matchingAccount = _savedAccounts
                          .where((account) => account.email == value.trim())
                          .firstOrNull;

                      if (matchingAccount != null && _selectedAccount == null) {
                        _selectedAccount = matchingAccount;
                      }
                    });
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!_isValidEmail(value.trim())) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),

                SizedBox(height: isSmallScreen ? 12 : 20),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(fontSize: isSmallScreen ? 13 : 14),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      size: isSmallScreen ? 20 : 24,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        isSmallScreen ? 8 : 12,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 12 : 16,
                      vertical: isSmallScreen ? 12 : 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (!_isLogin && value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                // Remember me checkbox (only for login)
                if (_isLogin) ...[
                  SizedBox(height: isSmallScreen ? 12 : 16),
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                        activeColor: const Color(0xFF3B82F6),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                      SizedBox(width: isSmallScreen ? 4 : 8),
                      Expanded(
                        child: Text(
                          'Remember Me',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 13 : 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                SizedBox(height: isSmallScreen ? 18 : 30),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  height: ResponsiveUtils.getButtonHeight(context),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          isSmallScreen ? 8 : 12,
                        ),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: isSmallScreen ? 18 : 20,
                            height: isSmallScreen ? 18 : 20,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            _isLogin ? 'Sign In' : 'Sign Up',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                SizedBox(height: isSmallScreen ? 12 : 20),

                // Toggle login/signup
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Text(
                      _isLogin
                          ? "Don't have an account?"
                          : 'Already have an account?',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: isSmallScreen ? 13 : 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isLogin = !_isLogin;
                          // Clear form when switching modes
                          _emailController.clear();
                          _passwordController.clear();
                          _nameController.clear();
                          _selectedAccount = null;
                        });
                      },
                      child: Text(
                        _isLogin ? 'Sign Up' : 'Sign In',
                        style: TextStyle(
                          color: const Color(0xFF3B82F6),
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 13 : 14,
                        ),
                      ),
                    ),
                  ],
                ),

                // Add some bottom padding to prevent overflow
                SizedBox(height: isSmallScreen ? 20 : 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isLogin) {
        // Sign in
        debugPrint(
          'Attempting to sign in with email: ${_emailController.text.trim()}',
        );
        final result = await FirebaseService.signInWithEmailPassword(
          _emailController.text.trim(),
          _passwordController.text,
        );
        debugPrint('Sign in result: ${result?.user?.email}');

        if (result?.user != null) {
          // Save remember me preference
          await SavedAccountsService.setRememberMe(_rememberMe);

          // If remember me is enabled, save the account with Firebase sync
          if (_rememberMe && result?.user != null) {
            try {
              // Always sync with Firebase to get fresh data
              await SavedAccountsService.syncAccountWithFirebase(
                _emailController.text.trim(),
                result!.user!.uid,
              );

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account saved and synced with Firebase'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            } catch (e) {
              debugPrint('Error saving/syncing account: $e');
              // Fallback to basic save if sync fails
              String displayName = result!.user?.displayName ?? '';
              if (displayName.isEmpty) {
                try {
                  final userProfile = await FirebaseService.getUserProfile(
                    result.user!.uid,
                  );
                  displayName = userProfile?.displayName ?? 'User';
                } catch (e) {
                  debugPrint('Error getting user profile: $e');
                  displayName = 'User';
                }
              }

              await SavedAccountsService.saveAccountWithUid(
                _emailController.text.trim(),
                displayName,
                result.user!.uid,
              );
            }
          }

          if (mounted && context.mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MyHomePage()),
            );
          }
        }
      } else {
        // Sign up
        final result = await FirebaseService.signUpWithEmailPassword(
          _emailController.text.trim(),
          _passwordController.text,
        );

        if (result?.user != null) {
          // Create user profile
          final user = UserModel(
            uid: result!.user!.uid,
            email: _emailController.text.trim(),
            displayName: _nameController.text.trim(),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          await FirebaseService.createUserProfile(user);

          // Auto-save new account with Firebase sync if remember me is enabled
          if (_rememberMe) {
            try {
              await SavedAccountsService.syncAccountWithFirebase(
                _emailController.text.trim(),
                result.user!.uid,
              );
            } catch (e) {
              debugPrint('Error saving new account: $e');
              // Fallback save
              await SavedAccountsService.saveAccountWithUid(
                _emailController.text.trim(),
                _nameController.text.trim(),
                result.user!.uid,
              );
            }
          }

          // if (mounted && context.mounted) {
          //   Navigator.of(context).pushReplacement(
          //     MaterialPageRoute(builder: (context) => const MyHomePage()),
          //   );
          // }
          // Gửi email xác thực qua Firebase (flow chuẩn)
          await EmailVerificationService.sendVerificationEmail();

          // Điều hướng sang màn hình chờ xác thực
          if (!mounted) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => VerifyEmailScreen(email: _emailController.text.trim()),
            ),
          );
        }
      }
    } catch (e) {
      String errorMessage = 'An error occurred';

      if (e.toString().contains('user-not-found')) {
        errorMessage = 'No account found with this email';
      } else if (e.toString().contains('wrong-password')) {
        errorMessage = 'Incorrect password';
      } else if (e.toString().contains('invalid-credential')) {
        errorMessage =
            'Invalid email or password. Please check your credentials and try again.';
      } else if (e.toString().contains('email-already-in-use')) {
        errorMessage = 'An account already exists with this email';
      } else if (e.toString().contains('weak-password')) {
        errorMessage = 'Password is too weak';
      } else if (e.toString().contains('invalid-email')) {
        errorMessage = 'Invalid email address';
      } else if (e.toString().contains('network-request-failed')) {
        errorMessage =
            'Network connection failed. Please check your internet connection.';
      } else if (e.toString().contains('too-many-requests')) {
        errorMessage = 'Too many failed attempts. Please try again later.';
      } else {
        errorMessage = 'Authentication failed: ${e.toString()}';
      }

      _showError(errorMessage);
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
