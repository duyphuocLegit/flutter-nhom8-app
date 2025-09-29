import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/setting_service.dart';
import '../services/theme_service.dart';
import '../widgets/notification_test_widget.dart';
import 'privacy.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<String, dynamic> _settings = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final settings = {
        'taskReminders': await SettingsService.getTaskReminders(),
      };
      if (mounted) {
        setState(() {
          _settings = settings;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorMessage('Failed to load settings');
      }
    }
  }

  Future<void> _updateSetting(
    String key,
    dynamic value,
    Future<void> Function(bool) updateFunction,
  ) async {
    setState(() => _settings[key] = value);
    try {
      await updateFunction(value);
    } catch (e) {
      // Revert on error
      setState(() => _settings[key] = !(value as bool));
      _showErrorMessage('Failed to update setting');
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Settings'), centerTitle: true),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading settings...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      key: const ValueKey('settings'),
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Settings ⚙️',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Theme Settings
              _buildSettingsCard(
                title: 'Appearance',
                icon: Icons.palette,
                children: [_buildThemeSelector()],
              ),
              const SizedBox(height: 16),

              // App Settings
              _buildSettingsCard(
                title: 'App Settings',
                icon: Icons.tune,
                children: [
                  _buildToggleItem(
                    title: 'Notifications',
                    subtitle: 'Get reminders for your tasks',
                    value: _settings['taskReminders'] ?? true,
                    onChanged: (value) => _updateSetting(
                      'taskReminders',
                      value,
                      SettingsService.setTaskReminders,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Notification Test
              _buildSettingsCard(
                title: 'Test Notifications',
                icon: Icons.notifications_active,
                children: [
                  const Text(
                    'Test notification features:',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  const NotificationTestWidget(),
                ],
              ),
              const SizedBox(height: 16),

              // Data & Privacy
              _buildSettingsCard(
                title: 'Data & Privacy',
                icon: Icons.privacy_tip,
                children: [
                  _buildSettingItem(
                    title: 'Privacy Policy',
                    subtitle: 'Learn about our privacy practices',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyScreen(),
                      ),
                    ),
                  ),
                  _buildSettingItem(
                    title: 'Clear Cache',
                    subtitle: 'Free up storage space',
                    onTap: _showClearCacheDialog,
                  ),
                  _buildSettingItem(
                    title: 'Reset Settings',
                    subtitle: 'Reset all settings to default',
                    onTap: _showResetDialog,
                    isDestructive: true,
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: colorScheme.primary, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children.map(
              (child) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isDestructive ? colorScheme.error : null,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: Icon(
          Icons.chevron_right,
          color: isDestructive ? colorScheme.error : colorScheme.onSurface,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  Widget _buildThemeSelector() {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildThemeOption(
                'System',
                'Follow system settings',
                ThemeMode.system,
                themeService,
              ),
              const Divider(height: 1),
              _buildThemeOption(
                'Light',
                'Always use light theme',
                ThemeMode.light,
                themeService,
              ),
              const Divider(height: 1),
              _buildThemeOption(
                'Dark',
                'Always use dark theme',
                ThemeMode.dark,
                themeService,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
    String title,
    String subtitle,
    ThemeMode mode,
    ThemeService themeService,
  ) {
    return RadioListTile<ThemeMode>(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
      value: mode,
      groupValue: themeService.themeMode,
      onChanged: (ThemeMode? value) {
        if (value != null) {
          themeService.setThemeMode(value);
        }
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Future<void> _showClearCacheDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text(
          'This will remove temporary files and may help improve app performance. '
          'Your tasks and settings will not be affected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear Cache'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cache cleared successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _showResetDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text(
          'This will reset all settings to their default values. '
          'Your tasks will not be affected. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await SettingsService.resetAllSettings();
        await _loadSettings();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Settings reset successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          _showErrorMessage('Failed to reset settings');
        }
      }
    }
  }
}
