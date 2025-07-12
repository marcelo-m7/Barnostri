import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barnostri_app/src/widgets/language_selector.dart';
import 'package:barnostri_app/src/core/services/language_service.dart';
import 'package:barnostri_app/l10n/generated/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Dropdown displays locales and updates language', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await container.read(languageServiceProvider.notifier).initialize();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: LanguageService.supportedLocales,
          home: Scaffold(body: LanguageSelector()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Open dropdown
    await tester.tap(find.byType(DropdownButton<Locale>));
    await tester.pumpAndSettle();

    // Verify all locales are shown
    final languageService = container.read(languageServiceProvider.notifier);
    for (final locale in LanguageService.supportedLocales) {
      expect(find.text(languageService.getLanguageDisplayName(locale)),
          findsWidgets);
    }

    // Select English
    await tester.tap(find
        .text(languageService.getLanguageDisplayName(const Locale('en', 'GB')))
        .last);
    await tester.pumpAndSettle();

    expect(container.read(languageServiceProvider), const Locale('en', 'GB'));
  });

  testWidgets('Bottom sheet displays locales and updates language',
      (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await container.read(languageServiceProvider.notifier).initialize();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: LanguageService.supportedLocales,
          home: Scaffold(body: LanguageSelectorButton()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Open bottom sheet
    await tester.tap(find.byType(LanguageSelectorButton));
    await tester.pumpAndSettle();

    final languageService = container.read(languageServiceProvider.notifier);
    for (final locale in LanguageService.supportedLocales) {
      expect(find.text(languageService.getLanguageDisplayName(locale)),
          findsWidgets);
    }

    // Tap French
    await tester.tap(find
        .text(languageService.getLanguageDisplayName(const Locale('fr', 'CH')))
        .last);
    await tester.pumpAndSettle();

    expect(container.read(languageServiceProvider), const Locale('fr', 'CH'));
  });
}
