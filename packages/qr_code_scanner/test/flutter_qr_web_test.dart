@TestOn('browser')
import 'dart:async';

import 'package:test/test.dart';
import 'package:qr_code_scanner/src/web/flutter_qr_web.dart';

void main() {
  test('cancel stops frame timer', () {
    final widget = WebQrView(onPlatformViewCreated: (_) {});
    final dynamic state = widget.createState();

    final timer = Timer.periodic(const Duration(milliseconds: 10), (_) {});
    state.frameInterval = timer;
    expect(state.frameInterval, isNotNull);

    state.cancel();

    expect(timer.isActive, isFalse);
    expect(state.frameInterval, isNull);
  });
}
