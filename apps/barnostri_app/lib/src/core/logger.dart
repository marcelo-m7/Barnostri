import 'package:logging/logging.dart';

final Logger logger = Logger('BarnostriApp');

void setupLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.level.name}: ${record.message}');
  });
}
