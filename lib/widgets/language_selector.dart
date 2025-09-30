import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nhom10/services/language_service.dart';
import 'package:nhom10/l10n/app_localizations.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        final l10n = AppLocalizations.of(context)!;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.language,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ...LanguageService.supportedLocales.map((locale) {
                  final isSelected =
                      languageService.currentLocale.languageCode ==
                      locale.languageCode;
                  final languageName = LanguageService.getLanguageName(
                    locale.languageCode,
                  );

                  return RadioListTile<String>(
                    title: Text(languageName),
                    value: locale.languageCode,
                    groupValue: languageService.currentLocale.languageCode,
                    onChanged: (String? value) {
                      if (value != null) {
                        languageService.setLanguage(value);
                      }
                    },
                    selected: isSelected,
                    activeColor: Theme.of(context).primaryColor,
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        final l10n = AppLocalizations.of(context)!;

        return ListTile(
          leading: const Icon(Icons.language),
          title: Text(l10n.language),
          subtitle: Text(
            LanguageService.getLanguageName(
              languageService.currentLocale.languageCode,
            ),
          ),
          trailing: DropdownButton<String>(
            value: languageService.currentLocale.languageCode,
            underline: const SizedBox(),
            items: LanguageService.supportedLocales.map((locale) {
              return DropdownMenuItem<String>(
                value: locale.languageCode,
                child: Text(
                  LanguageService.getLanguageName(locale.languageCode),
                ),
              );
            }).toList(),
            onChanged: (String? value) {
              if (value != null) {
                languageService.setLanguage(value);
              }
            },
          ),
        );
      },
    );
  }
}

class CompactLanguageSwitch extends StatelessWidget {
  const CompactLanguageSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return IconButton(
          icon: const Icon(Icons.language),
          onPressed: () {
            _showLanguageDialog(context, languageService);
          },
          tooltip: AppLocalizations.of(context)!.language,
        );
      },
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    LanguageService languageService,
  ) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.language),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: LanguageService.supportedLocales.map((locale) {
              final languageName = LanguageService.getLanguageName(
                locale.languageCode,
              );

              return ListTile(
                title: Text(languageName),
                leading: Radio<String>(
                  value: locale.languageCode,
                  groupValue: languageService.currentLocale.languageCode,
                  onChanged: (String? value) {
                    if (value != null) {
                      languageService.setLanguage(value);
                      Navigator.of(context).pop();
                    }
                  },
                ),
                onTap: () {
                  languageService.setLanguage(locale.languageCode);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
          ],
        );
      },
    );
  }
}
