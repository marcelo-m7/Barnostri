import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:barnostri_app/src/core/logger.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('setupLogger uses Level.ALL in debug mode', () {
    setupLogger();
    expect(Logger.root.level, Level.ALL);
  });

  test('setupLogger uses Level.WARNING in release mode', () {
    setupLogger(isReleaseOverride: true);
    expect(Logger.root.level, Level.WARNING);
  });
}
