import 'package:shared_models/shared_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Handles user registration via the [AuthRepository].
class SignUpUseCase {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  /// Creates a new user with the provided [email] and [password].
  Future<AuthResponse> call({required String email, required String password}) {
    return _repository.signUp(email: email, password: password);
  }
}
