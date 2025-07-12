import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:integration_test/integration_test.dart';
import 'package:barnostri_app/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final platforms = <String, TargetPlatform?>{
    'Android': TargetPlatform.android,
    'iOS': TargetPlatform.iOS,
    'Web': null,
  };

  platforms.forEach((name, platform) {
    group('Rendering on $name', () {
      testWidgets('App renders on small and large screens', (tester) async {
        debugDefaultTargetPlatformOverride = platform;

        await tester.binding.setSurfaceSize(const Size(400, 800));
        await tester.pumpWidget(const ProviderScope(child: BarnostriApp()));
        expect(find.text('Barnostri'), findsOneWidget);

        await tester.binding.setSurfaceSize(const Size(1200, 800));
        await tester.pumpAndSettle();
        expect(find.text('Barnostri'), findsOneWidget);

        debugDefaultTargetPlatformOverride = null;
        await tester.binding.setSurfaceSize(null);
      });
    });
  });
}
