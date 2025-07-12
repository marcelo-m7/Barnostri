import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barnostri_app/src/widgets/menu_item_card.dart';
import 'package:barnostri_app/l10n/generated/app_localizations.dart';
import 'package:barnostri_app/src/core/services/language_service.dart';
import 'package:shared_models/shared_models.dart';
import 'package:intl/intl.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('placeholder icon displayed when imageUrl is null',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final item = MenuItem(
      id: '1',
      name: 'Test Food',
      description: null,
      price: 10.0,
      categoryId: '1',
      available: true,
      imageUrl: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      category: null,
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: LanguageService.supportedLocales,
        home: Scaffold(body: MenuItemCard(item: item, onTap: () {})),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.fastfood), findsOneWidget);
  });

  testWidgets('displays price formatted for pt_BR locale', (tester) async {
    final item = MenuItem(
      id: '1',
      name: 'Test Food',
      description: null,
      price: 10.0,
      categoryId: '1',
      available: true,
      imageUrl: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      category: null,
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pt', 'BR'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: LanguageService.supportedLocales,
        home: Scaffold(body: MenuItemCard(item: item, onTap: () {})),
      ),
    );

    await tester.pumpAndSettle();

    final symbol = NumberFormat.simpleCurrency(locale: 'pt_BR').currencySymbol;
    expect(
      find.text(formatCurrency(10.0, locale: 'pt_BR', symbol: symbol)),
      findsOneWidget,
    );
  });

  testWidgets('displays price formatted for en_GB locale', (tester) async {
    final item = MenuItem(
      id: '1',
      name: 'Test Food',
      description: null,
      price: 10.0,
      categoryId: '1',
      available: true,
      imageUrl: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      category: null,
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en', 'GB'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: LanguageService.supportedLocales,
        home: Scaffold(body: MenuItemCard(item: item, onTap: () {})),
      ),
    );

    await tester.pumpAndSettle();

    final symbol = NumberFormat.simpleCurrency(locale: 'en_GB').currencySymbol;
    expect(
      find.text(formatCurrency(10.0, locale: 'en_GB', symbol: symbol)),
      findsOneWidget,
    );
  });
}
