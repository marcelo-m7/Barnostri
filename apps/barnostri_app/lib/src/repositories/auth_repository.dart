import "package:supabase_flutter/supabase_flutter.dart";

abstract class AuthRepository {
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  });
  Future<void> signOut();
  User? getCurrentUser();
  Stream<AuthState> get authStateChanges;
}
