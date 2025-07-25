import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:barnostri_app/main.dart';
import 'package:barnostri_app/src/features/auth/presentation/pages/admin_page.dart';
import 'package:barnostri_app/src/features/menu/presentation/pages/menu_page.dart';
import 'package:barnostri_app/src/core/repositories.dart';
import 'package:shared_models/shared_models.dart';

class _FakeProfileRepository implements ProfileRepository {
  int calls = 0;
  @override
  Future<void> createProfile(UserProfile profile) async {
    calls++;
  }

  @override
  Future<UserProfile?> fetchProfile(String id) async => null;
}

Future<void> _pumpApp(WidgetTester tester, Size size, TargetPlatform? platform,
    {ProfileRepository? profileRepo}) async {
  await tester.binding.setSurfaceSize(size);
  debugDefaultTargetPlatformOverride = platform;
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        if (profileRepo != null)
          profileRepositoryProvider.overrideWithValue(profileRepo),
      ],
      child: const BarnostriApp(),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _reset(WidgetTester tester) async {
  debugDefaultTargetPlatformOverride = null;
  await tester.binding.setSurfaceSize(null);
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  const size = Size(400, 800);

  final platforms = <String, TargetPlatform?>{
    'Android': TargetPlatform.android,
    'iOS': TargetPlatform.iOS,
    'Web': null,
  };

  platforms.forEach((name, platform) {
    group('Signup flow on $name', () {
      testWidgets('customer redirects to menu', (tester) async {
        addTearDown(() async => _reset(tester));

        final profileRepo = _FakeProfileRepository();
        await _pumpApp(tester, size, platform, profileRepo: profileRepo);
        appRouter.go('/signup');
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField).at(0), 'Customer');
        await tester.enterText(find.byType(TextField).at(1), '123456');
        await tester.enterText(
            find.byType(TextField).at(2), 'cust@example.com');
        await tester.enterText(find.byType(TextField).at(3), 'secret');
        await tester.tap(find.text('Sign Up'));
        await tester.pumpAndSettle();

        expect(find.byType(MenuPage), findsOneWidget);
        expect(profileRepo.calls, 1);
      });

      testWidgets('merchant redirects to admin', (tester) async {
        addTearDown(() async => _reset(tester));

        final profileRepo = _FakeProfileRepository();
        await _pumpApp(tester, size, platform, profileRepo: profileRepo);
        appRouter.go('/signup');
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField).at(0), 'Merchant');
        await tester.enterText(find.byType(TextField).at(1), '123456');
        await tester.enterText(
            find.byType(TextField).at(2), 'store@example.com');
        await tester.enterText(find.byType(TextField).at(3), 'secret');
        await tester.tap(find.byType(DropdownButtonFormField<String>));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Merchant').last);
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField).at(4), 'My Store');
        await tester.tap(find.text('Sign Up'));
        await tester.pumpAndSettle();

        expect(find.byType(AdminPage), findsOneWidget);
        expect(profileRepo.calls, 1);
      });
    });
  });
}
