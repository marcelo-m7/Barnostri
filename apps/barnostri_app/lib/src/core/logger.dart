import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart';

final Logger logger = Logger('BarnostriApp');

/// Configures the root [Logger] level depending on the build mode.
///
/// In debug mode every log is emitted using [Level.ALL]. For release builds
/// (when [kReleaseMode] is `true`) the level is raised to [Level.WARNING] to
/// avoid verbose logging.
void setupLogger({bool? isReleaseOverride}) {
  final isRelease = isReleaseOverride ?? kReleaseMode;
  Logger.root.level = isRelease ? Level.WARNING : Level.ALL;
  Logger.root.onRecord.listen(
    (record) => debugPrint('${record.level.name}: ${record.message}'),
  );
}
