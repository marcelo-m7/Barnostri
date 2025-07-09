import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_models/shared_models.dart';

class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient? _client;

  SupabaseAuthRepository(this._client);

  @override
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    if (_client == null) {
      if (kDebugMode) {
        print('🔒 Mock authentication: $email');
      }
      if (email == 'admin@barnostri.com' && password == 'admin123') {
        await Future.delayed(const Duration(seconds: 1));
        return AuthResponse(
          user: User(
            id: 'demo-admin-id',
            appMetadata: {},
            userMetadata: {},
            aud: 'authenticated',
            createdAt: DateTime.now().toIso8601String(),
            email: email,
          ),
          session: Session(
            accessToken: 'demo-access-token',
            refreshToken: 'demo-refresh-token',
            expiresIn: 3600,
            tokenType: 'Bearer',
            user: User(
              id: 'demo-admin-id',
              appMetadata: {},
              userMetadata: {},
              aud: 'authenticated',
              createdAt: DateTime.now().toIso8601String(),
              email: email,
            ),
          ),
        );
      } else {
        throw const AuthException('Invalid credentials');
      }
    }
    try {
      final response = await _client!.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao fazer login: $e');
      }
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    if (_client == null) {
      if (kDebugMode) {
        print('🔓 Mock sign out');
      }
      return;
    }
    try {
      await _client!.auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao fazer logout: $e');
      }
      rethrow;
    }
  }

  @override
  User? getCurrentUser() {
    if (_client == null) {
      return null;
    }
    return _client!.auth.currentUser;
  }

  @override
  Stream<AuthState> get authStateChanges {
    if (_client == null) {
      return Stream.value(const AuthState(AuthChangeEvent.signedOut, null));
    }
    return _client!.auth.onAuthStateChange;
  }
}
