import '../../data/auth_repository.dart';

/// Handles user login via the [AuthRepository].
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  /// Attempts to authenticate a user with the provided [email] and [password].
  Future<AuthResponse> call({required String email, required String password}) {
    return _repository.signIn(email: email, password: password);
  }
}
