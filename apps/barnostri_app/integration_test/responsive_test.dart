import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barnostri_app/main.dart';

void main() {
  testWidgets('App renders on small and large screens', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));
    await tester.pumpWidget(const ProviderScope(child: BarnostriApp()));
    expect(find.text('Barnostri'), findsOneWidget);

    await tester.binding.setSurfaceSize(const Size(1200, 800));
    await tester.pumpAndSettle();
    expect(find.text('Barnostri'), findsOneWidget);
  });
}
