import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/supabase_config.dart';

/// Global providers used across the application.

/// Indicates whether the application is running in demo mode.
///
/// Demo mode is active when Supabase has not been configured.
final demoModeProvider = Provider<bool>((ref) {
  return !SupabaseConfig.isConfigured;
});
