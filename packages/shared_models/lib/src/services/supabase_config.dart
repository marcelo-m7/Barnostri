import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static late final SupabaseClient _client;
  static bool _isConfigured = false;

  static SupabaseClient get client => _client;
  static bool get isConfigured => _isConfigured;

  static Future<void> initialize({String env = 'dev'}) async {
    try {
      final configJson = await rootBundle.loadString('supabase/supabase-config.json');
      final data = jsonDecode(configJson) as Map<String, dynamic>;
      final envConfig = data[env] as Map<String, dynamic>;
      final supabaseUrl = envConfig['SUPABASE_URL'] as String;
      final anonKey = envConfig['SUPABASE_ANON_KEY'] as String;

      await Supabase.initialize(url: supabaseUrl, anonKey: anonKey);
      _client = Supabase.instance.client;
      _isConfigured = true;
    } catch (e) {
      _isConfigured = false;
      if (kDebugMode) {
        print('❌ Failed to initialize Supabase: $e');
      }
    }
  }

  static User? getCurrentUser() {
    if (!_isConfigured) {
      return null;
    }
    return _client.auth.currentUser;
  }

  static Stream<AuthState> get authStateChanges {
    if (!_isConfigured) {
      // Return mock auth state stream for demo
      return Stream.value(AuthState(AuthChangeEvent.signedOut, null));
    }
    return _client.auth.onAuthStateChange;
  }
}
