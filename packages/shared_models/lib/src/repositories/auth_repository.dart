import "package:supabase_flutter/supabase_flutter.dart";
import '../models/enums.dart';

abstract class AuthRepository {
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  });
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String name,
    required UserType userType,
    String? phone,
    String? storeName,
  });
  Future<void> signOut();
  User? getCurrentUser();
  Stream<AuthState> get authStateChanges;
}
