import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';

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
          AppLocalizations.of(context)!.privacyPolicy,
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
                              AppLocalizations.of(context)!.privacyPolicy,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.lastUpdated,
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
                    AppLocalizations.of(context)!.privacyDescription,
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
        title: AppLocalizations.of(context)!.informationWeCollect,
        icon: Icons.info_outline,
        content: [
          AppLocalizations.of(context)!.accountInfoCollection,
          AppLocalizations.of(context)!.taskDataCollection,
          AppLocalizations.of(context)!.usageDataCollection,
          AppLocalizations.of(context)!.deviceInfoCollection,
        ],
      ),
      _PrivacySection(
        title: AppLocalizations.of(context)!.howWeUseYourInformation,
        icon: Icons.how_to_reg,
        content: [
          AppLocalizations.of(context)!.provideService,
          AppLocalizations.of(context)!.syncData,
          AppLocalizations.of(context)!.sendNotifications,
          AppLocalizations.of(context)!.improveApp,
          AppLocalizations.of(context)!.customerSupport,
        ],
      ),
      _PrivacySection(
        title: AppLocalizations.of(context)!.dataStorageSecurity,
        icon: Icons.security,
        content: [
          AppLocalizations.of(context)!.secureStorage,
          AppLocalizations.of(context)!.httpsConnections,
          AppLocalizations.of(context)!.privateTasks,
          AppLocalizations.of(context)!.securityUpdates,
          AppLocalizations.of(context)!.encryptedBackups,
        ],
      ),
      _PrivacySection(
        title: AppLocalizations.of(context)!.dataSharing,
        icon: Icons.share,
        content: [
          AppLocalizations.of(context)!.noSellData,
          AppLocalizations.of(context)!.noShareTasks,
          AppLocalizations.of(context)!.anonymousStats,
          AppLocalizations.of(context)!.legalRequirements,
        ],
      ),
      _PrivacySection(
        title: AppLocalizations.of(context)!.yourRights,
        icon: Icons.account_circle,
        content: [
          AppLocalizations.of(context)!.accessRight,
          AppLocalizations.of(context)!.updateRight,
          AppLocalizations.of(context)!.deleteRight,
          AppLocalizations.of(context)!.exportRight,
          AppLocalizations.of(context)!.controlRight,
        ],
      ),
      _PrivacySection(
        title: AppLocalizations.of(context)!.thirdPartyServices,
        icon: Icons.integration_instructions,
        content: [
          AppLocalizations.of(context)!.firebaseService,
          AppLocalizations.of(context)!.googlePlayServices,
          AppLocalizations.of(context)!.noAdvertising,
          AppLocalizations.of(context)!.thirdPartyCompliance,
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
                AppLocalizations.of(context)!.questionsOrConcerns,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.privacyContactDescription,
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
                    AppLocalizations.of(context)!.privacyResponseTime,
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
