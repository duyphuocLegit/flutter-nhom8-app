import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/task_model.dart';
import '../services/firebase_service.dart';
import '../widgets/constant.dart';
import '../l10n/app_localizations.dart';
import 'authentication.dart';
import 'edit_profile.dart';
import 'password.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  UserModel? userProfile;
  Map<String, int> taskStats = {'completed': 0, 'pending': 0, 'total': 0};
  List<TaskItemModel> recentTasks = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadAccountData();
  }

  Future<void> _loadAccountData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // Check if user is authenticated
      if (FirebaseService.currentUserId == null) {
        setState(() {
          isLoading = false;
          errorMessage = 'User not authenticated';
        });
        return;
      }

      // Load all account data in parallel with timeout
      final results =
          await Future.wait([
            FirebaseService.getUserProfile(FirebaseService.currentUserId!),
            FirebaseService.getTaskStats(),
            FirebaseService.getRecentTasks(5),
          ]).timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Request timeout'),
          );

      if (mounted) {
        setState(() {
          userProfile = results[0] as UserModel?;
          taskStats = results[1] as Map<String, int>;
          recentTasks = results[2] as List<TaskItemModel>;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading account data: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load account data: ${e.toString()}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kBlueDark),
          ),
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFF8FAFC),
          elevation: 0,
          title: Text(AppLocalizations.of(context)!.account),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
              const SizedBox(height: 16),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red.shade600, fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadAccountData,
                child: Text(AppLocalizations.of(context)!.retry),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.account,
          style: const TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              _buildProfileHeader(),
              const SizedBox(height: 24),

              // Account Management Section
              _buildAccountManagementSection(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Picture - Fixed opacity usage
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kBlueLight.withOpacity(0.1),
              border: Border.all(color: kBlueLight.withOpacity(0.3), width: 2),
            ),
            child:
                userProfile?.photoUrl != null &&
                    userProfile!.photoUrl!.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      userProfile!.photoUrl!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.person,
                          size: 40,
                          color: kBlueLight.withOpacity(0.7),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  )
                : Icon(
                    Icons.person,
                    size: 40,
                    color: kBlueLight.withOpacity(0.7),
                  ),
          ),
          const SizedBox(width: 16),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userProfile?.displayName ?? 'User Name',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                // Improved email visibility with better contrast
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: const Color(0xFF1E293B).withOpacity(0.1),
                    ),
                  ),
                  child: Text(
                    userProfile?.email ?? 'user@example.com',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1E293B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.active,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountManagementSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(AppLocalizations.of(context)!.accountManagement),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildAccountOption(
                title: AppLocalizations.of(context)!.editProfile,
                subtitle: AppLocalizations.of(context)!.updateProfileDetails,
                icon: Icons.edit_outlined,
                iconColor: Colors.blue.shade600,
                onTap: () async {
                  if (userProfile != null) {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditProfileScreen(userProfile: userProfile!),
                      ),
                    );

                    if (result == true) {
                      _loadAccountData();
                    }
                  }
                },
              ),
              _buildOptionDivider(),
              _buildAccountOption(
                title: AppLocalizations.of(context)!.changePassword,
                subtitle: AppLocalizations.of(
                  context,
                )!.updatePasswordForSecurity,
                icon: Icons.lock_outline,
                iconColor: Colors.orange.shade600,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangePassword(),
                    ),
                  );
                },
              ),
              _buildOptionDivider(),
              _buildAccountOption(
                title: AppLocalizations.of(context)!.accountData,
                subtitle: AppLocalizations.of(context)!.viewAccountStorage,
                icon: Icons.storage_outlined,
                iconColor: Colors.teal.shade600,
                onTap: () {
                  _showRealAccountDataUsage();
                },
              ),
              _buildOptionDivider(),
              _buildAccountOption(
                title: AppLocalizations.of(context)!.logout,
                subtitle: AppLocalizations.of(context)!.signOutOfAccount,
                icon: Icons.logout_outlined,
                iconColor: Colors.red.shade600,
                onTap: () {
                  _showLogoutDialog();
                },
              ),
              _buildOptionDivider(),
              _buildAccountOption(
                title: AppLocalizations.of(context)!.deleteAccount,
                subtitle: AppLocalizations.of(
                  context,
                )!.permanentlyDeleteAccount,
                icon: Icons.delete_forever_outlined,
                iconColor: Colors.red.shade600,
                onTap: () {
                  _showDeleteAccountDialog();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E293B),
      ),
    );
  }

  Widget _buildAccountOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.shade200,
      indent: 16,
      endIndent: 16,
    );
  }

  // Updated to show real account data
  void _showRealAccountDataUsage() {
    // Calculate storage estimate based on real data
    final estimatedStorage = _calculateStorageUsage();
    final accountCreatedDate = userProfile?.createdAt != null
        ? _formatDate(userProfile!.createdAt)
        : 'Unknown';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.accountDataUsage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDataRow(
              AppLocalizations.of(context)!.storageUsed,
              '$estimatedStorage MB / 100 MB',
            ),
            const SizedBox(height: 8),
            _buildDataRow(
              AppLocalizations.of(context)!.totalTasks,
              '${taskStats['total']}',
            ),
            const SizedBox(height: 8),
            _buildDataRow(
              AppLocalizations.of(context)!.completedTasks,
              '${taskStats['completed']}',
            ),
            const SizedBox(height: 8),
            _buildDataRow(
              AppLocalizations.of(context)!.pendingTasks,
              '${taskStats['pending']}',
            ),
            const SizedBox(height: 8),
            _buildDataRow(
              AppLocalizations.of(context)!.profileImages,
              userProfile?.photoUrl != null ? '1' : '0',
            ),
            const SizedBox(height: 8),
            _buildDataRow(
              AppLocalizations.of(context)!.accountCreated,
              accountCreatedDate,
            ),
            const SizedBox(height: 8),
            _buildDataRow(
              AppLocalizations.of(context)!.lastActive,
              AppLocalizations.of(context)!.today,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.close),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(color: Colors.grey.shade700),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  String _calculateStorageUsage() {
    // Estimate storage based on real data
    double storage = 0.0;

    // Base user profile: ~0.1 MB
    storage += 0.1;

    // Each task: ~0.01 MB
    storage += (taskStats['total'] ?? 0) * 0.01;

    // Profile image if exists: ~0.5 MB
    if (userProfile?.photoUrl != null && userProfile!.photoUrl!.isNotEmpty) {
      storage += 0.5;
    }

    return storage.toStringAsFixed(1);
  }

  String _formatDate(DateTime date) {
    final months = [
      AppLocalizations.of(context)!.january,
      AppLocalizations.of(context)!.february,
      AppLocalizations.of(context)!.march,
      AppLocalizations.of(context)!.april,
      AppLocalizations.of(context)!.may,
      AppLocalizations.of(context)!.june,
      AppLocalizations.of(context)!.july,
      AppLocalizations.of(context)!.august,
      AppLocalizations.of(context)!.september,
      AppLocalizations.of(context)!.october,
      AppLocalizations.of(context)!.november,
      AppLocalizations.of(context)!.december,
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.logout),
        content: Text(AppLocalizations.of(context)!.confirmLogout),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                Navigator.pop(context); // Close dialog first

                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    content: Row(
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(width: 16),
                        Text(AppLocalizations.of(context)!.signingOut),
                      ],
                    ),
                  ),
                );

                await FirebaseService.signOut();

                if (mounted && context.mounted) {
                  Navigator.pop(context); // Close loading dialog
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthScreen()),
                    (route) => false,
                  );
                }
              } catch (e) {
                if (mounted && context.mounted) {
                  Navigator.pop(context); // Close loading dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(
                          context,
                        )!.errorSigningOut(e.toString()),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text(AppLocalizations.of(context)!.logout),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red.shade600),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context)!.deleteAccount,
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.deleteAccountWarning,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.deleteProfileSettings,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                  Text(
                    AppLocalizations.of(
                      context,
                    )!.deleteAllTasks(taskStats['total'].toString()),
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                  Text(
                    AppLocalizations.of(context)!.deleteAccountAccess,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                  Text(
                    AppLocalizations.of(context)!.deletePreferencesHistory,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.orange.shade300),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.orange.shade700,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.actionCannotBeUndone,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showFinalDeleteConfirmation();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(AppLocalizations.of(context)!.continueToDelete),
          ),
        ],
      ),
    );
  }

  void _showFinalDeleteConfirmation() {
    final TextEditingController confirmController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.finalConfirmation),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.finalDeleteInstruction,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: AppLocalizations.of(context)!.password,
                hintText: AppLocalizations.of(context)!.enterPassword,
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: AppLocalizations.of(context)!.confirmation,
                hintText: AppLocalizations.of(context)!.typeDeleteHere,
                prefixIcon: Icon(Icons.warning_outlined),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Text(
                AppLocalizations.of(context)!.deleteWarningDetails,
                style: TextStyle(fontSize: 12, color: Colors.red),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (passwordController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)!.pleaseEnterPassword,
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              if (confirmController.text != 'DELETE') {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)!.pleaseTypeDelete,
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              Navigator.pop(context);
              _performAccountDeletion(passwordController.text);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
              AppLocalizations.of(context)!.deleteForever,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _performAccountDeletion(String password) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.red),
            SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.deletingAccount),
            SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.mayTakeFewMoments,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );

    try {
      // First, re-authenticate the user for security
      await FirebaseService.reauthenticateUser(password);

      // Then delete the account and all data
      await FirebaseService.deleteUserAccount();

      if (mounted && context.mounted) {
        Navigator.pop(context); // Close loading dialog

        // Navigate to auth screen and show success message
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AuthScreen()),
          (route) => false,
        );

        // Show success message on the auth screen
        Future.delayed(const Duration(milliseconds: 100), () {
          final currentContext = Navigator.of(context).context;
          if (currentContext.mounted) {
            ScaffoldMessenger.of(currentContext).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(
                    currentContext,
                  )!.accountDeletedSuccessfully,
                ),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
              ),
            );
          }
        });
      }
    } catch (e) {
      if (mounted && context.mounted) {
        Navigator.pop(context); // Close loading dialog

        String errorMessage;
        if (e.toString().contains('wrong-password')) {
          errorMessage = AppLocalizations.of(context)!.incorrectPassword;
        } else if (e.toString().contains('too-many-requests')) {
          errorMessage = AppLocalizations.of(context)!.tooManyAttempts;
        } else if (e.toString().contains('requires-recent-login')) {
          errorMessage = AppLocalizations.of(context)!.signOutAndBackIn;
        } else if (e.toString().contains('network-request-failed')) {
          errorMessage = AppLocalizations.of(context)!.networkError;
        } else {
          errorMessage = AppLocalizations.of(
            context,
          )!.failedToDeleteAccount(e.toString());
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () => _showDeleteAccountDialog(),
            ),
          ),
        );
      }
    }
  }
}
