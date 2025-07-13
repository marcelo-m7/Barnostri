import 'package:shared_models/shared_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<AuthResponse> call({
    required String email,
    required String password,
    required String name,
    required UserType userType,
    String? phone,
    String? storeName,
  }) {
    return _repository.signUp(
      email: email,
      password: password,
      name: name,
      userType: userType,
      phone: phone,
      storeName: storeName,
    );
  }
}
