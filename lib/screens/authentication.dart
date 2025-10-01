import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../services/saved_accounts_service.dart';
import '../models/user_model.dart';
import '../utils/responsive_utils.dart';
import '../l10n/app_localizations.dart';
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

  // Email validation helper
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  void initState() {
    super.initState();
    _initializeAuthScreen();
  }

  Future<void> _initializeAuthScreen() async {
    await SavedAccountsService.cleanupInconsistentData();
    await _loadSavedAccounts();
    await _loadRememberMeSettings();
  }

  Future<void> _loadSavedAccounts() async {
    try {
      final savedAccounts =
          await SavedAccountsService.getSavedAccountsWithFirebaseSync();
      final lastUsedEmail = await SavedAccountsService.getLastUsedEmail();

      if (mounted) {
        setState(() {
          _savedAccounts = savedAccounts;

          if (lastUsedEmail != null && savedAccounts.isNotEmpty) {
            _selectedAccount = savedAccounts
                .where((account) => account.email == lastUsedEmail)
                .firstOrNull;

            if (_selectedAccount != null) {
              _emailController.text = _selectedAccount!.email;
            } else {
              SavedAccountsService.clearLastUsedEmail();
              _emailController.clear();
            }
          } else if (lastUsedEmail != null && savedAccounts.isEmpty) {
            SavedAccountsService.clearLastUsedEmail();
            _emailController.clear();
          }
        });
      }
    } catch (e) {
      debugPrint('Error loading saved accounts: ');
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
      debugPrint('Error loading remember me settings: ');
    }
  }

  void _selectSavedAccount(SavedAccount? account) {
    setState(() {
      _selectedAccount = account;
      if (account != null) {
        _emailController.text = account.email;
        _passwordController.clear();
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
          title: Text(AppLocalizations.of(context)!.removeAccount),
          content: Text(
            AppLocalizations.of(context)!.removeAccountMessage(account.email),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(AppLocalizations.of(context)!.remove),
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
            SnackBar(
              content: Text(AppLocalizations.of(context)!.accountRemoved),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(
                  context,
                )!.errorRemovingAccount(e.toString()),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Widget _buildSimpleTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    void Function(String)? onChanged,
    String? Function(String?)? validator,
    required bool isSmallScreen,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(
        fontSize: isSmallScreen ? 15 : 17,
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          fontSize: isSmallScreen ? 14 : 15,
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(
          prefixIcon,
          size: isSmallScreen ? 22 : 26,
          color: colorScheme.onSurfaceVariant,
        ),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
          borderSide: BorderSide(color: colorScheme.outline, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        contentPadding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 16 : 20,
          vertical: isSmallScreen ? 16 : 20,
        ),
      ),
      onChanged: onChanged,
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = ResponsiveUtils.isVerySmallScreen(context);
    final horizontalPadding = ResponsiveUtils.getHorizontalPadding(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(horizontalPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: isSmallScreen ? 20 : 30),

                // Simple, friendly logo
                Center(
                  child: Container(
                    // padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                    // decoration: BoxDecoration(
                    //   color: colorScheme.primaryContainer,
                    //   borderRadius: BorderRadius.circular(
                    //     isSmallScreen ? 16 : 20,
                    //   ),
                    //   border: Border.all(
                    //     color: colorScheme.outline.withValues(alpha: 0.3),
                    //     width: 1,
                    //   ),
                    // ),
                    child: Image.asset(
                      'assets/logo.png',
                      width: isSmallScreen ? 50 : 66,
                      height: isSmallScreen ? 50 : 66,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),

                SizedBox(height: isSmallScreen ? 20 : 32),

                // Clean welcome text
                Center(
                  child: Column(
                    children: [
                      Text(
                        _isLogin
                            ? AppLocalizations.of(context)!.welcomeBack
                            : AppLocalizations.of(context)!.createAccount,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: isSmallScreen ? 4 : 8),
                      Container(
                        width: 60,
                        height: 3,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: isSmallScreen ? 8 : 12),

                Center(
                  child: Text(
                    _isLogin
                        ? AppLocalizations.of(context)!.signInToContinue
                        : AppLocalizations.of(context)!.signUpToStart,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: isSmallScreen ? 28 : 44),

                // Main form container with clean design
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 20 : 28),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(
                      isSmallScreen ? 16 : 24,
                    ),
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Saved accounts dropdown (only for login and when accounts exist)
                      if (_isLogin && _savedAccounts.isNotEmpty) ...[
                        Container(
                          margin: EdgeInsets.only(
                            bottom: isSmallScreen ? 16 : 24,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(
                              isSmallScreen ? 10 : 14,
                            ),
                            border: Border.all(
                              color: colorScheme.outline.withValues(alpha: 0.3),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<SavedAccount?>(
                              isExpanded: true,
                              value: _selectedAccount,
                              hint: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isSmallScreen ? 14 : 18,
                                  vertical: isSmallScreen ? 14 : 18,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.account_circle_outlined,
                                      size: isSmallScreen ? 20 : 22,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                    SizedBox(width: isSmallScreen ? 8 : 10),
                                    Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.selectSavedAccount,
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 14 : 16,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              items: [
                                DropdownMenuItem<SavedAccount?>(
                                  value: null,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isSmallScreen ? 10 : 14,
                                      vertical: isSmallScreen ? 8 : 10,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.edit_outlined,
                                          size: isSmallScreen ? 18 : 20,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                        SizedBox(width: isSmallScreen ? 8 : 10),
                                        Flexible(
                                          child: Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.enterEmailManually,
                                            style: TextStyle(
                                              fontSize: isSmallScreen ? 13 : 15,
                                              color: colorScheme.onSurface,
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
                                      onLongPress: () =>
                                          _removeSavedAccount(account),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: isSmallScreen ? 10 : 14,
                                          vertical: isSmallScreen ? 8 : 10,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CircleAvatar(
                                              radius: isSmallScreen ? 12 : 14,
                                              backgroundColor:
                                                  colorScheme.primaryContainer,
                                              child: Text(
                                                account.displayName.isNotEmpty
                                                    ? account.displayName[0]
                                                          .toUpperCase()
                                                    : account.email[0]
                                                          .toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: isSmallScreen
                                                      ? 10
                                                      : 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: colorScheme
                                                      .onPrimaryContainer,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: isSmallScreen ? 8 : 10,
                                            ),
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
                                                          fontSize:
                                                              isSmallScreen
                                                              ? 12
                                                              : 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: colorScheme
                                                              .onSurface,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
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
                                                            ? 10
                                                            : 12,
                                                        color: colorScheme
                                                            .onSurfaceVariant,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Icon(
                                              Icons.more_vert,
                                              size: isSmallScreen ? 16 : 18,
                                              color:
                                                  colorScheme.onSurfaceVariant,
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
                                  right: isSmallScreen ? 8 : 10,
                                ),
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: isSmallScreen ? 20 : 22,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              isDense: false,
                              menuMaxHeight: 250,
                              itemHeight: isSmallScreen ? 75 : 85,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 13 : 15,
                              ),
                              dropdownColor: colorScheme.surface,
                            ),
                          ),
                        ),
                      ],

                      // Name field (only for signup)
                      if (!_isLogin) ...[
                        _buildSimpleTextField(
                          controller: _nameController,
                          labelText: AppLocalizations.of(context)!.fullName,
                          prefixIcon: Icons.person_outline,
                          isSmallScreen: isSmallScreen,
                          validator: (value) {
                            if (!_isLogin &&
                                (value == null || value.trim().isEmpty)) {
                              return AppLocalizations.of(
                                context,
                              )!.pleaseEnterYourName;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: isSmallScreen ? 16 : 24),
                      ],

                      // Email field
                      _buildSimpleTextField(
                        controller: _emailController,
                        labelText: AppLocalizations.of(context)!.email,
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        isSmallScreen: isSmallScreen,
                        suffixIcon: _emailController.text.isNotEmpty
                            ? Icon(
                                _isValidEmail(_emailController.text)
                                    ? Icons.check_circle
                                    : Icons.error,
                                color: _isValidEmail(_emailController.text)
                                    ? Colors.green
                                    : colorScheme.error,
                                size: isSmallScreen ? 20 : 22,
                              )
                            : null,
                        onChanged: (value) {
                          setState(() {
                            if (_selectedAccount != null &&
                                _selectedAccount!.email != value.trim()) {
                              _selectedAccount = null;
                            }

                            final matchingAccount = _savedAccounts
                                .where(
                                  (account) => account.email == value.trim(),
                                )
                                .firstOrNull;

                            if (matchingAccount != null &&
                                _selectedAccount == null) {
                              _selectedAccount = matchingAccount;
                            }
                          });
                        },
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppLocalizations.of(
                              context,
                            )!.pleaseEnterYourEmail;
                          }
                          if (!_isValidEmail(value.trim())) {
                            return AppLocalizations.of(
                              context,
                            )!.invalidEmailAddress;
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: isSmallScreen ? 16 : 24),

                      // Password field
                      _buildSimpleTextField(
                        controller: _passwordController,
                        labelText: AppLocalizations.of(context)!.password,
                        prefixIcon: Icons.lock_outline,
                        obscureText: true,
                        isSmallScreen: isSmallScreen,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(
                              context,
                            )!.pleaseEnterYourPassword;
                          }
                          if (!_isLogin && value.length < 6) {
                            return AppLocalizations.of(
                              context,
                            )!.passwordMustBeAtLeast6Characters;
                          }
                          return null;
                        },
                      ),

                      // Remember me checkbox (only for login)
                      if (_isLogin) ...[
                        SizedBox(height: isSmallScreen ? 16 : 20),
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                              activeColor: colorScheme.primary,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                            SizedBox(width: isSmallScreen ? 6 : 8),
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context)!.rememberMe,
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 15,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],

                      SizedBox(height: isSmallScreen ? 24 : 32),

                      // Clean submit button
                      SizedBox(
                        width: double.infinity,
                        height: ResponsiveUtils.getButtonHeight(context),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                isSmallScreen ? 12 : 16,
                              ),
                            ),
                            elevation: 2,
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  width: isSmallScreen ? 20 : 22,
                                  height: isSmallScreen ? 20 : 22,
                                  child: CircularProgressIndicator(
                                    color: colorScheme.onPrimary,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  _isLogin
                                      ? AppLocalizations.of(context)!.signIn
                                      : AppLocalizations.of(context)!.signUp,
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 16 : 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: isSmallScreen ? 20 : 28),

                // Simple toggle section
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 16 : 20,
                      vertical: isSmallScreen ? 8 : 10,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(
                        isSmallScreen ? 20 : 25,
                      ),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Text(
                          _isLogin
                              ? "Don't have an account?"
                              : 'Already have an account?',
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: isSmallScreen ? 14 : 15,
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isLogin = !_isLogin;
                              _emailController.clear();
                              _passwordController.clear();
                              _nameController.clear();
                              _selectedAccount = null;
                            });
                          },
                          child: Text(
                            _isLogin
                                ? AppLocalizations.of(context)!.signUp
                                : AppLocalizations.of(context)!.signIn,
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: isSmallScreen ? 14 : 15,
                              decoration: TextDecoration.underline,
                              decorationColor: colorScheme.primary.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

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
        debugPrint('Attempting to sign in with email: ');
        final result = await FirebaseService.signInWithEmailPassword(
          _emailController.text.trim(),
          _passwordController.text,
        );
        debugPrint('Sign in result: ');

        if (result?.user != null) {
          await SavedAccountsService.setRememberMe(_rememberMe);

          if (_rememberMe && result?.user != null) {
            try {
              await SavedAccountsService.syncAccountWithFirebase(
                _emailController.text.trim(),
                result!.user!.uid,
              );

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(
                        context,
                      )!.accountSavedAndSyncedWithFirebase,
                    ),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            } catch (e) {
              debugPrint('Error saving/syncing account: ');
              String displayName = result!.user?.displayName ?? '';
              if (displayName.isEmpty) {
                try {
                  final userProfile = await FirebaseService.getUserProfile(
                    result.user!.uid,
                  );
                  displayName = userProfile?.displayName ?? 'User';
                } catch (e) {
                  debugPrint('Error getting user profile: ');
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

          await EmailVerificationService.sendVerificationEmail();

          if (!mounted) return;

          final isVerified =
              await EmailVerificationService.reloadAndIsVerified();
          if (isVerified) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MyHomePage()),
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) =>
                    VerifyEmailScreen(email: _emailController.text.trim()),
              ),
            );
          }
        }
      } else {
        final result = await FirebaseService.signUpWithEmailPassword(
          _emailController.text.trim(),
          _passwordController.text,
        );

        if (result?.user != null) {
          final user = UserModel(
            uid: result!.user!.uid,
            email: _emailController.text.trim(),
            displayName: _nameController.text.trim(),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          await FirebaseService.createUserProfile(user);

          if (_rememberMe) {
            try {
              await SavedAccountsService.syncAccountWithFirebase(
                _emailController.text.trim(),
                result.user!.uid,
              );
            } catch (e) {
              debugPrint('Error saving new account: ');
              await SavedAccountsService.saveAccountWithUid(
                _emailController.text.trim(),
                _nameController.text.trim(),
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
      }
    } catch (e) {
      String errorMessage = AppLocalizations.of(context)!.error;

      if (e.toString().contains('user-not-found')) {
        errorMessage = AppLocalizations.of(
          context,
        )!.noAccountFoundWithThisEmail;
      } else if (e.toString().contains('wrong-password')) {
        errorMessage = AppLocalizations.of(context)!.invalidEmailOrPassword;
      } else if (e.toString().contains('invalid-credential')) {
        errorMessage = AppLocalizations.of(context)!.invalidEmailOrPassword;
      } else if (e.toString().contains('email-already-in-use')) {
        errorMessage = AppLocalizations.of(
          context,
        )!.accountAlreadyExistsWithThisEmail;
      } else if (e.toString().contains('weak-password')) {
        errorMessage = AppLocalizations.of(context)!.passwordIsTooWeak;
      } else if (e.toString().contains('invalid-email')) {
        errorMessage = AppLocalizations.of(context)!.invalidEmailAddress;
      } else if (e.toString().contains('network-request-failed')) {
        errorMessage = AppLocalizations.of(context)!.networkConnectionFailed;
      } else if (e.toString().contains('too-many-requests')) {
        errorMessage = AppLocalizations.of(context)!.tooManyFailedAttempts;
      } else {
        errorMessage = AppLocalizations.of(
          context,
        )!.authenticationFailed(e.toString());
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
