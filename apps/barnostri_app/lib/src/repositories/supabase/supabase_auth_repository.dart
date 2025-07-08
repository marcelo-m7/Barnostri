import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../repositories/auth_repository.dart';
import 'package:shared_models/shared_models.dart';

class SupabaseAuthRepository implements AuthRepository {
  @override
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    if (!SupabaseConfig.isConfigured) {
      if (kDebugMode) {
        print('🔒 Mock authentication: $email');
      }
      if (email == 'admin@barnostri.com' && password == 'admin123') {
        await Future.delayed(const Duration(seconds: 1));
        return AuthResponse(
          user: User(
            id: 'demo-admin-id',
            appMetadata: const {},
            userMetadata: const {},
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
              appMetadata: const {},
              userMetadata: const {},
              aud: 'authenticated',
              createdAt: DateTime.now().toIso8601String(),
              email: email,
            ),
          ),
        );
      } else {
        throw AuthException('Invalid credentials');
      }
    }

    try {
      final response = await SupabaseConfig.client.auth.signInWithPassword(
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
    if (!SupabaseConfig.isConfigured) {
      if (kDebugMode) {
        print('🔓 Mock sign out');
      }
      return;
    }

    try {
      await SupabaseConfig.client.auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao fazer logout: $e');
      }
      rethrow;
    }
  }

  @override
  User? getCurrentUser() {
    if (!SupabaseConfig.isConfigured) {
      return null;
    }
    return SupabaseConfig.client.auth.currentUser;
  }

  @override
  Stream<AuthState> get authStateChanges {
    if (!SupabaseConfig.isConfigured) {
      return Stream.value(AuthState(AuthChangeEvent.signedOut, null));
    }
    return SupabaseConfig.client.auth.onAuthStateChange;
  }
}
