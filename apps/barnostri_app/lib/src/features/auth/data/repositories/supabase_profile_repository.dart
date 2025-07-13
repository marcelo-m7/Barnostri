import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_models/shared_models.dart';
import 'package:barnostri_app/src/core/logger.dart';

class SupabaseProfileRepository implements ProfileRepository {
  final SupabaseClient? _client;

  SupabaseProfileRepository(this._client);

  bool get _useEdgeFunction =>
      Platform.environment.containsKey('SUPABASE_SERVICE_ROLE_KEY');

  @override
  Future<void> createProfile(UserProfile profile) async {
    if (_client == null) {
      if (kDebugMode) {
        debugPrint('📝 Mock create profile for ${profile.id}');
      }
      return;
    }
    try {
      if (_useEdgeFunction) {
        await _client!.functions
            .invoke('create_user_profile', body: profile.toJson());
      } else {
        await _client!.from('profiles').insert(profile.toJson());
      }
    } catch (e) {
      logger.severe('Error creating profile: $e');
      rethrow;
    }
  }

  @override
  Future<UserProfile?> fetchProfile(String id) async {
    if (_client == null) {
      return UserProfile(
        id: id,
        name: 'Mock User',
        phone: '000000000',
        userType: 'cliente',
        storeName: null,
        createdAt: DateTime.now(),
      );
    }
    try {
      final response =
          await _client!.from('profiles').select('*').eq('id', id).single();
      return UserProfile.fromJson(response);
    } catch (e) {
      logger.severe('Error fetching profile: $e');
      return null;
    }
  }
}
