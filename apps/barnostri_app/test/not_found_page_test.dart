import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barnostri_app/src/features/home/presentation/pages/not_found_page.dart';
import 'package:barnostri_app/l10n/generated/app_localizations.dart';
import 'package:barnostri_app/src/core/services/language_service.dart';

void main() {
  testWidgets('NotFoundPage shows localized text', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: LanguageService.supportedLocales,
        locale: Locale('en', 'GB'),
        home: NotFoundPage(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Page not found'), findsOneWidget);
  });
}
