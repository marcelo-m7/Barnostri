import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barnostri_app/src/features/order/presentation/pages/qr_scanner_page.dart';

void main() {
  testWidgets('shows unsupported message on web', (tester) async {
    if (!kIsWeb) return; // only relevant on web
    await tester.pumpWidget(const MaterialApp(home: QrScannerPage()));
    expect(find.text('QR scanning not supported on web'), findsOneWidget);
  }, skip: !kIsWeb);
}
