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
  /// Returns `null` if an unexpected error occurs while initializing Supabase.
  /// Throws an [Exception] with a descriptive message when the configuration
  /// file is missing or malformed.
  static Future<SupabaseClient?> createClient({
    String env = 'dev',
    String? assetPath,
  }) async {
    if (_isConfigured) {
      try {
        return Supabase.instance.client;
      } on AssertionError {
        _isConfigured = false;
      }
    }
    try {
      final configJson = await rootBundle.loadString(
        assetPath ?? 'supabase/supabase-config.json',
      );
      final data = jsonDecode(configJson) as Map<String, dynamic>;
      final rawEnv = data[env];
      if (rawEnv is! Map<String, dynamic>) {
        throw FormatException('Environment "$env" not found');
      }
      final envConfig = rawEnv;
      final supabaseUrl = envConfig['SUPABASE_URL'] as String?;
      final anonKey = envConfig['SUPABASE_ANON_KEY'] as String?;
      if (supabaseUrl == null || anonKey == null) {
        throw const FormatException('Invalid Supabase configuration');
      }

      await Supabase.initialize(url: supabaseUrl, anonKey: anonKey);
      _isConfigured = true;
      return Supabase.instance.client;
    } on FlutterError catch (e) {
      _isConfigured = false;
      final msg =
          'Unable to load supabase-config.json: ${e.message}. Ensure the file exists.';
      if (kDebugMode) {
        debugPrint('❌ $msg');
      }
      throw Exception(msg);
    } on FormatException catch (e) {
      _isConfigured = false;
      final msg = 'Malformed Supabase configuration: ${e.message}';
      if (kDebugMode) {
        debugPrint('❌ $msg');
      }
      throw FormatException(msg);
    } catch (e) {
      _isConfigured = false;
      if (kDebugMode) {
        debugPrint('❌ Failed to initialize Supabase: $e');
      }
      return null;
    }
  }
}

/// Provider that holds the [SupabaseClient] instance.
///
/// It defaults to `null` and is overridden during application initialization.
final supabaseClientProvider = Provider<SupabaseClient?>((ref) => null);
