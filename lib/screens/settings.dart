import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/setting_service.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';
import '../widgets/notification_test_widget.dart';
import '../l10n/app_localizations.dart';
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
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.settings),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(AppLocalizations.of(context)!.loading),
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
          '${AppLocalizations.of(context)!.settings} ⚙️',
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
                title: AppLocalizations.of(context)!.appearance,
                icon: Icons.palette,
                children: [_buildThemeSelector()],
              ),
              const SizedBox(height: 16),

              // Language Settings
              _buildSettingsCard(
                title: AppLocalizations.of(context)!.language,
                icon: Icons.language,
                children: [
                  _buildSettingItem(
                    title: AppLocalizations.of(context)!.language,
                    subtitle: _getCurrentLanguageLabel(context),
                    onTap: () => _showLanguageDialog(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // App Settings
              _buildSettingsCard(
                title: AppLocalizations.of(context)!.appSettings,
                icon: Icons.tune,
                children: [
                  _buildToggleItem(
                    title: AppLocalizations.of(context)!.notifications,
                    subtitle: AppLocalizations.of(
                      context,
                    )!.getRemindersForTasks,
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
                title: AppLocalizations.of(context)!.testNotifications,
                icon: Icons.notifications_active,
                children: [
                  Text(
                    AppLocalizations.of(context)!.testNotificationFeatures,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  const NotificationTestWidget(),
                ],
              ),
              const SizedBox(height: 16),

              // Data & Privacy
              _buildSettingsCard(
                title: AppLocalizations.of(context)!.dataAndPrivacy,
                icon: Icons.privacy_tip,
                children: [
                  _buildSettingItem(
                    title: AppLocalizations.of(context)!.privacyPolicy,
                    subtitle: AppLocalizations.of(
                      context,
                    )!.learnAboutPrivacyPractices,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyScreen(),
                      ),
                    ),
                  ),
                  _buildSettingItem(
                    title: AppLocalizations.of(context)!.clearCache,
                    subtitle: AppLocalizations.of(context)!.freeUpStorageSpace,
                    onTap: _showClearCacheDialog,
                  ),
                  _buildSettingItem(
                    title: AppLocalizations.of(context)!.resetSettings,
                    subtitle: AppLocalizations.of(
                      context,
                    )!.resetAllSettingsToDefault,
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

  String _getCurrentLanguageLabel(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    switch (locale) {
      case 'vi':
        return 'Tiếng Việt';
      case 'en':
        return 'English';
      default:
        return locale;
    }
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Tiếng Việt'),
              onTap: () {
                _changeLanguage(const Locale('vi'));
                Navigator.pop(context);
              },
              selected: Localizations.localeOf(context).languageCode == 'vi',
            ),
            ListTile(
              title: const Text('English'),
              onTap: () {
                _changeLanguage(const Locale('en'));
                Navigator.pop(context);
              },
              selected: Localizations.localeOf(context).languageCode == 'en',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
        ],
      ),
    );
  }

  void _changeLanguage(Locale locale) {
    // This assumes you use a ChangeNotifier/Provider for locale management
    // Replace ThemeService with your actual LocaleProvider
    Provider.of<LanguageService>(
      context,
      listen: false,
    ).setLanguage(locale.languageCode);
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
      // ignore: deprecated_member_use
      groupValue: themeService.themeMode,
      // ignore: deprecated_member_use
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
        title: Text(AppLocalizations.of(context)!.clearCache),
        content: Text(AppLocalizations.of(context)!.clearCacheMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)!.clearCache),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.cacheCleared),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _showResetDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.resetSettings),
        content: Text(AppLocalizations.of(context)!.resetSettingsMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(AppLocalizations.of(context)!.reset),
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
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.settingsResetSuccessfully,
              ),
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
