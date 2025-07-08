import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_models/shared_models.dart';

/// Whether the application is running in demo mode.
///
/// Demo mode is active when Supabase has not been configured.
final demoModeProvider = Provider<bool>((ref) {
  return !SupabaseConfig.isConfigured;
});
