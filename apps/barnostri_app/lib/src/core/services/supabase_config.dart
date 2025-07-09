import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SupabaseConfig {
  static bool _isConfigured = false;

  static bool get isConfigured => _isConfigured;

  /// Loads the configuration and returns a [SupabaseClient] instance.
  ///
  /// Returns `null` if the configuration file cannot be read.
  static Future<SupabaseClient?> createClient({String env = 'dev'}) async {
    try {
      final configJson = await rootBundle.loadString(
        'supabase/supabase-config.json',
      );
      final data = jsonDecode(configJson) as Map<String, dynamic>;
      final envConfig = data[env] as Map<String, dynamic>;
      final supabaseUrl = envConfig['SUPABASE_URL'] as String;
      final anonKey = envConfig['SUPABASE_ANON_KEY'] as String;

      await Supabase.initialize(url: supabaseUrl, anonKey: anonKey);
      _isConfigured = true;
      return Supabase.instance.client;
    } catch (e) {
      _isConfigured = false;
      if (kDebugMode) {
        print('❌ Failed to initialize Supabase: $e');
      }
      return null;
    }
  }
}

/// Provider that holds the [SupabaseClient] instance.
///
/// It defaults to `null` and is overridden during application initialization.
final supabaseClientProvider = Provider<SupabaseClient?>((ref) => null);
