import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_models/shared_models.dart';
import 'package:barnostri_app/src/core/logger.dart';

class SupabaseProfileRepository implements ProfileRepository {
  final SupabaseClient? _client;
  final String? _serviceRoleKey;

  SupabaseProfileRepository(this._client, {String? serviceRoleKey})
      : _serviceRoleKey = serviceRoleKey;

  @override
  Future<void> createProfile(UserProfile profile) async {
    if (_client == null) {
      if (kDebugMode) {
        debugPrint('📝 Mock create profile for ${profile.id}');
      }
      return;
    }
    try {
      if (_serviceRoleKey != null && _serviceRoleKey!.isNotEmpty) {
        await _client!.functions.invoke(
          'create_user_profile',
          body: profile.toJson(),
          headers: {'Authorization': 'Bearer $_serviceRoleKey'},
        );
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
        userType: UserType.cliente,
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
