import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Privacy Policy',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        systemOverlayStyle: theme.brightness == Brightness.light
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.privacy_tip,
                        color: colorScheme.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Privacy Policy',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Last updated: September 27, 2025',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your privacy is important to us. This policy explains how we collect, use, and protect your information.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Privacy sections
            ..._buildPrivacySections(theme, colorScheme),

            const SizedBox(height: 24),

            // Contact section
            _buildContactSection(theme, colorScheme),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPrivacySections(ThemeData theme, ColorScheme colorScheme) {
    final sections = [
      _PrivacySection(
        title: 'Information We Collect',
        icon: Icons.info_outline,
        content: [
          'Account Information: Email address, name, and profile picture when you sign up',
          'Task Data: Your tasks, categories, due dates, and completion status',
          'Usage Data: How you interact with the app for improving user experience',
          'Device Information: Device type and operating system for compatibility',
        ],
      ),
      _PrivacySection(
        title: 'How We Use Your Information',
        icon: Icons.how_to_reg,
        content: [
          'Provide and maintain the task management service',
          'Sync your data across your devices securely',
          'Send notifications about your tasks and deadlines',
          'Improve app performance and add new features',
          'Provide customer support when needed',
        ],
      ),
      _PrivacySection(
        title: 'Data Storage & Security',
        icon: Icons.security,
        content: [
          'Your data is stored securely using Firebase with industry-standard encryption',
          'We use secure HTTPS connections for all data transmission',
          'Your tasks are private and only accessible to you',
          'We implement regular security updates and monitoring',
          'Data backups are encrypted and stored securely',
        ],
      ),
      _PrivacySection(
        title: 'Data Sharing',
        icon: Icons.share,
        content: [
          'We do not sell your personal information to third parties',
          'We do not share your task data with other users',
          'Anonymous usage statistics may be used to improve the app',
          'We may share data only if required by law or to protect our rights',
        ],
      ),
      _PrivacySection(
        title: 'Your Rights',
        icon: Icons.account_circle,
        content: [
          'Access: You can view all your data within the app',
          'Update: You can modify your profile and task information anytime',
          'Delete: You can delete your account and all associated data',
          'Export: You can request a copy of your data',
          'Control: You can manage notification and privacy settings',
        ],
      ),
      _PrivacySection(
        title: 'Third-Party Services',
        icon: Icons.integration_instructions,
        content: [
          'Firebase: Used for authentication, data storage, and cloud functions',
          'Google Play Services: For app distribution and crash reporting',
          'No advertising networks or tracking services are used',
          'All third-party services comply with their own privacy policies',
        ],
      ),
    ];

    return sections
        .map((section) => _buildPrivacyCard(section, theme, colorScheme))
        .toList();
  }

  Widget _buildPrivacyCard(
    _PrivacySection section,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(section.icon, color: colorScheme.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  section.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...section.content.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.contact_support, color: colorScheme.primary, size: 24),
              const SizedBox(width: 12),
              Text(
                'Questions or Concerns?',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'If you have any questions about this Privacy Policy or how we handle your data, please contact us:',
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
          const SizedBox(height: 12),
          _buildContactItem(
            Icons.email,
            'support@taskapp.com',
            theme,
            colorScheme,
          ),
          const SizedBox(height: 8),
          _buildContactItem(
            Icons.language,
            'www.taskapp.com/privacy',
            theme,
            colorScheme,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'We will respond to all privacy-related inquiries within 48 hours.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
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

  Widget _buildContactItem(
    IconData icon,
    String text,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        Icon(icon, color: colorScheme.onSurface.withOpacity(0.6), size: 18),
        const SizedBox(width: 8),
        Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _PrivacySection {
  final String title;
  final IconData icon;
  final List<String> content;

  _PrivacySection({
    required this.title,
    required this.icon,
    required this.content,
  });
}
