import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barnostri_app/src/widgets/menu_item_card.dart';
import 'package:barnostri_app/l10n/generated/app_localizations.dart';
import 'package:barnostri_app/src/core/services/language_service.dart';
import 'package:shared_models/shared_models.dart';

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
}
