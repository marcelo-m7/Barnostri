import 'package:flutter_test/flutter_test.dart';
import 'package:qr_code_scanner/src/web/flutter_qr_stub.dart'
    if (dart.library.html) 'package:qr_code_scanner/src/web/flutter_qr_web.dart';

void main() {
  test('createWebQrView returns a widget', () {
    final view = createWebQrView();
    expect(view, isNotNull);
  });
}
