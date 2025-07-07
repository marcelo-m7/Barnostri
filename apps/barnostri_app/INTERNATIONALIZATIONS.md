# Internationalization (i18n) Implementation for Barnostri

## Overview

This document describes the complete internationalization (i18n) implementation for the Barnostri mobile app, supporting Portuguese (pt-BR), English (en-GB), and French (fr-CH) languages.

## Supported Languages

- **Portuguese (pt-BR)** - Primary language for Brazilian beach kiosk customers
- **English (en-GB)** - International customers and tourists
- **French (fr-CH)** - Swiss French-speaking customers

## Implementation Structure

### 1. Configuration Files

#### `l10n.yaml`
```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
output-dir: lib/l10n/generated
nullable-getter: false
```

#### `pubspec.yaml` Changes
```yaml
flutter:
  uses-material-design: true
  generate: true

dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.0
```

### 2. Translation Files (.arb)

#### Source Files:
- `lib/l10n/app_en.arb` - English template (base language)
- `lib/l10n/app_pt.arb` - Portuguese translations
- `lib/l10n/app_fr.arb` - French translations

#### Generated Files:
- `lib/l10n/generated/app_localizations.dart` - Main localization class
- `lib/l10n/generated/app_localizations_en.dart` - English implementation
- `lib/l10n/generated/app_localizations_pt.dart` - Portuguese implementation
- `lib/l10n/generated/app_localizations_fr.dart` - French implementation

### 3. Language Service

#### `lib/services/language_service.dart`
Provides:
- Language preference persistence using SharedPreferences
- Supported locales management
- Language display names and country flags
- Automatic device locale detection
- Language switching functionality

### 4. UI Components

#### `lib/widgets/language_selector.dart`
Two main components:
- **LanguageSelector** - Dropdown or bottom sheet selector
- **LanguageSelectorButton** - Compact button that opens language selection

### 5. App Integration

#### `lib/main.dart` Updates:
- Added `AppLocalizations.delegate` and Flutter localization delegates
- Configured supported locales
- Added language service provider
- Updated app title to use localized strings

## Key Features

### 1. String Categories

The app includes translations for:
- **Navigation & UI**: Menu, Cart, Orders, Tables, etc.
- **Actions**: Add, Edit, Delete, Save, Cancel, etc.
- **Status Messages**: Loading, Success, Error, etc.
- **Order Management**: Order status, payment methods, etc.
- **Admin Functions**: Login, logout, item management, etc.
- **Form Labels**: Name, Description, Price, Quantity, etc.

### 2. Parameterized Strings

Support for dynamic content:
```dart
// Table number with parameter
String tableNumber(String number) => 'Table $number';

// Items count with parameter
String itemsCount(int count) => '$count items';
```

### 3. Language Persistence

- User language preference is saved locally
- Automatic restoration on app restart
- Fallback to device locale if supported

### 4. Visual Language Indicator

- Country flag emojis (🇧🇷, 🇬🇧, 🇨🇭)
- Language display names in native language
- Intuitive language selection UI

## Usage Examples

### Basic Usage in Widgets:
```dart
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  
  return Text(l10n.welcomeMessage);
}
```

### With Parameters:
```dart
Text(l10n.tableNumber('5')) // "Table 5" or "Mesa 5"
Text(l10n.itemsCount(3))    // "3 items" or "3 itens"
```

### Language Selection:
```dart
// Show language selector as bottom sheet
LanguageSelector.showLanguageSelector(context);

// Or use as a button
LanguageSelectorButton(
  onLanguageChanged: () => setState(() {}),
)
```

## String Keys Reference

### Common UI Elements:
- `appTitle` - App name
- `menu`, `cart`, `orders`, `tables` - Navigation items
- `search`, `loading`, `cancel`, `save` - Action buttons
- `back`, `next`, `close`, `ok` - Navigation actions

### Order Management:
- `orderReceived`, `inPreparation`, `ready`, `delivered` - Order statuses
- `pix`, `card`, `cash` - Payment methods
- `checkout`, `processingOrder`, `orderPlaced` - Checkout flow

### Admin Functions:
- `login`, `logout`, `admin` - Authentication
- `addItem`, `editItem`, `deleteItem` - Item management
- `addCategory`, `addTable` - Category and table management

### Form Elements:
- `name`, `description`, `price`, `quantity` - Form fields
- `email`, `password`, `observations` - Input fields
- `available`, `unavailable` - Status indicators

## Best Practices

### 1. Always Use Localized Strings
```dart
// ✅ Good
Text(l10n.welcomeMessage)

// ❌ Bad
Text('Welcome to Barnostri')
```

### 2. Handle Null Safety
```dart
// ✅ Good
final l10n = AppLocalizations.of(context)!;

// ✅ Also good with null check
final l10n = AppLocalizations.of(context);
if (l10n != null) {
  Text(l10n.welcomeMessage);
}
```

### 3. Use Parameterized Strings
```dart
// ✅ Good
Text(l10n.tableNumber(mesa.numero))

// ❌ Bad
Text('Table ${mesa.numero}')
```

### 4. Provide Context in ARB Files
```json
{
  "welcomeMessage": "Welcome to Barnostri Beach Kiosk",
  "@welcomeMessage": {
    "description": "Welcome message shown on the home screen"
  }
}
```

## Testing Different Languages

### 1. Using Language Selector
- Open the app
- Tap the language selector button (top right on home screen)
- Select your desired language
- The app will immediately switch languages

### 2. Demo Mode Credentials
The demo banner and credentials are also localized:
- **Portuguese**: "Modo Demo - Use: admin@barnostri.com / admin123"
- **English**: "Demo Mode - Use: admin@barnostri.com / admin123"
- **French**: "Mode Démo - Utilisez: admin@barnostri.com / admin123"

### 3. Testing All Features
All user-facing strings are localized including:
- Home screen welcome message
- QR scanner page title
- Admin login form
- Menu categories and navigation
- Order status messages
- Error and success messages

## Maintenance

### Adding New Strings:
1. Add to `lib/l10n/app_en.arb` (template)
2. Add translations to `app_pt.arb` and `app_fr.arb`
3. Re-generate localization files if needed
4. Use the new string in your widgets

### Adding New Languages:
1. Create new `.arb` file (e.g., `app_es.arb`)
2. Add locale to `LanguageService.supportedLocales`
3. Update `AppLocalizations.supportedLocales`
4. Generate implementation files
5. Update language selector UI

## File Structure Summary

```
lib/
├── l10n/
│   ├── app_en.arb                    # English template
│   ├── app_pt.arb                    # Portuguese translations
│   ├── app_fr.arb                    # French translations
│   └── generated/
│       ├── app_localizations.dart    # Main localization class
│       ├── app_localizations_en.dart # English implementation
│       ├── app_localizations_pt.dart # Portuguese implementation
│       └── app_localizations_fr.dart # French implementation
├── services/
│   └── language_service.dart         # Language preference management
├── widgets/
│   └── language_selector.dart        # Language selection UI
└── main.dart                         # App configuration with i18n support
```

The internationalization system is fully integrated and ready for production use, providing seamless language switching and comprehensive translation coverage for all user-facing text in the Barnostri app.