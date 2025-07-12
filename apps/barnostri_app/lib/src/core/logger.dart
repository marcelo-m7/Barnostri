import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart';

final Logger logger = Logger('BarnostriApp');

void setupLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen(
    (record) => debugPrint('${record.level.name}: ${record.message}'),
  );
}
