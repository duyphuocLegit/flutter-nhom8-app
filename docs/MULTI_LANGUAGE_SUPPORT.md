<!-- @format -->

# Multi-Language Support Implementation Guide

This guide explains how to use the newly implemented multi-language support in the Flutter TaskApp.

## Overview

The app now supports both English and Vietnamese languages using Flutter's official localization approach with `flutter_localizations` and `intl`.

## Features

- ✅ Official Flutter localization with .arb files
- ✅ Language preferences stored in Firebase Firestore (per-user)
- ✅ Local storage with SharedPreferences (offline support)
- ✅ Provider-based state management for language switching
- ✅ No app restart required when changing languages
- ✅ Comprehensive translation coverage

## Supported Languages

- 🇺🇸 English (`en`)
- 🇻🇳 Vietnamese (`vi`)

## How to Use

### 1. Accessing Translations in Widgets

```dart
import 'package:flutter/material.dart';
import 'package:nhom10/l10n/app_localizations.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
      ),
      body: Column(
        children: [
          Text(l10n.welcome),
          ElevatedButton(
            onPressed: () {},
            child: Text(l10n.login),
          ),
        ],
      ),
    );
  }
}
```

### 2. Using the Extension Helper (Optional)

```dart
import 'package:nhom10/screens/localization_example_screen.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.appTitle), // Using extension
      ),
      body: Column(
        children: [
          Text(context.l10n.welcome),
          if (context.loading.isNotEmpty) // Using extension
            CircularProgressIndicator(),
        ],
      ),
    );
  }
}
```

### 3. Language Selection Widgets

#### Compact Language Switch (for App Bar)

```dart
import 'package:nhom10/widgets/language_selector.dart';

AppBar(
  title: Text('Settings'),
  actions: const [
    CompactLanguageSwitch(), // Shows language dialog
  ],
)
```

#### Language Dropdown (for Settings Screen)

```dart
import 'package:nhom10/widgets/language_selector.dart';

ListView(
  children: [
    const LanguageDropdown(), // Shows current language with dropdown
  ],
)
```

#### Full Language Selector (for Settings Page)

```dart
import 'package:nhom10/widgets/language_selector.dart';

Column(
  children: [
    const LanguageSelector(), // Shows radio buttons in a card
  ],
)
```

### 4. Programmatically Changing Language

```dart
import 'package:provider/provider.dart';
import 'package:nhom10/services/language_service.dart';

// In your widget
void changeLanguage(BuildContext context, String languageCode) {
  final languageService = context.read<LanguageService>();
  languageService.setLanguage(languageCode);
}

// Usage
changeLanguage(context, 'vi'); // Switch to Vietnamese
changeLanguage(context, 'en'); // Switch to English
```

### 5. Form Validation with Localization

```dart
import 'package:nhom10/utils/localization_helpers.dart';

TextFormField(
  validator: (value) => ValidationHelper.validateEmail(context, value),
  decoration: InputDecoration(
    labelText: context.l10n.email,
    hintText: context.l10n.pleaseEnterValidEmail,
  ),
)
```

## Available Translations

### Authentication

- `login`, `signUp`, `logout`
- `email`, `password`, `confirmPassword`
- `forgotPassword`, `createAccount`
- `alreadyHaveAccount`, `dontHaveAccount`

### Navigation

- `home`, `tasks`, `calendar`, `settings`, `profile`

### Task Management

- `addTask`, `taskTitle`, `taskDescription`
- `dueDate`, `priority`, `completed`, `pending`, `overdue`
- `high`, `medium`, `low`

### Common Actions

- `save`, `cancel`, `delete`, `edit`, `retry`
- `all`, `today`, `thisWeek`, `thisMonth`

### Messages

- `welcome`, `hello`, `loading`, `error`, `success`
- `noTasksFound`, `noInternetConnection`

### Settings

- `language`, `theme`, `notifications`, `aboutApp`, `version`
- `darkMode`, `lightMode`, `systemMode`

### Validation Messages

- `pleaseEnterValidEmail`, `passwordTooShort`
- `passwordsDoNotMatch`, `fieldRequired`

## File Structure

```
lib/
├── l10n/
│   ├── app_en.arb              # English translations
│   ├── app_vi.arb              # Vietnamese translations
│   ├── app_localizations.dart   # Generated base class
│   ├── app_localizations_en.dart # Generated English class
│   └── app_localizations_vi.dart # Generated Vietnamese class
├── services/
│   └── language_service.dart    # Language state management
├── utils/
│   └── localization_helpers.dart # Helper utilities
├── widgets/
│   └── language_selector.dart   # Language selection widgets
└── screens/
    └── localization_example_screen.dart # Usage examples
```

## Adding New Translations

### 1. Add to English ARB file (`lib/l10n/app_en.arb`)

```json
{
	"newKey": "English Text",
	"@newKey": {
		"description": "Description of what this text is for"
	}
}
```

### 2. Add to Vietnamese ARB file (`lib/l10n/app_vi.arb`)

```json
{
	"newKey": "Vietnamese Text"
}
```

### 3. Regenerate localization files

```bash
flutter gen-l10n
```

### 4. Use in your widgets

```dart
Text(AppLocalizations.of(context)!.newKey)
```

## Adding New Languages

### 1. Create new ARB file

Create `lib/l10n/app_[locale].arb` (e.g., `app_fr.arb` for French)

### 2. Update LanguageService

```dart
// In lib/services/language_service.dart
static const List<Locale> supportedLocales = [
  Locale('en'),
  Locale('vi'),
  Locale('fr'), // Add new language
];

static const Map<String, String> languageNames = {
  'en': 'English',
  'vi': 'Tiếng Việt',
  'fr': 'Français', // Add display name
};
```

### 3. Regenerate localization files

```bash
flutter gen-l10n
```

## Best Practices

1. **Always use `AppLocalizations.of(context)!`** to get translations
2. **Test both languages** during development
3. **Use context extensions** for commonly used strings
4. **Keep ARB files in sync** - ensure both files have the same keys
5. **Use descriptive keys** - prefer `loginButton` over `button1`
6. **Add descriptions** in ARB files for translators
7. **Handle text overflow** - Vietnamese text can be longer than English

## Testing

### Manual Testing

1. Run the app
2. Go to Settings or use the language switch
3. Change language between English and Vietnamese
4. Verify all text updates immediately
5. Restart the app and verify language persists

### Example Screen

Navigate to `LocalizationExampleScreen` to see comprehensive examples of:

- Basic text translation
- Form field localization
- Button text translation
- Language selection widgets
- Current language information

## Troubleshooting

### Translations not updating

1. Run `flutter gen-l10n` to regenerate files
2. Restart your IDE
3. Hot restart (not hot reload) the app

### Missing translations

1. Check both ARB files have the same keys
2. Verify the key exists in the ARB files
3. Run `flutter gen-l10n` after adding new keys

### Language not persisting

1. Check Firebase connection
2. Verify user authentication state
3. Check SharedPreferences permissions

### Build errors

1. Run `flutter clean`
2. Run `flutter pub get`
3. Run `flutter gen-l10n`
4. Rebuild the app

## Firebase Integration

Language preferences are automatically:

- 💾 **Saved to Firestore** when user is logged in
- 📱 **Saved locally** with SharedPreferences for offline use
- 🔄 **Synced across devices** when user logs in on different devices
- ⚡ **Loaded immediately** from local storage for fast startup

## Performance

- Language switching is **instant** (no app restart)
- Local storage provides **fast startup**
- Firebase sync is **non-blocking**
- Generated code is **optimized** for performance
