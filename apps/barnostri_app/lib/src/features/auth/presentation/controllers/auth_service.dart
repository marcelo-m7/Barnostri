import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:barnostri_app/src/core/repositories.dart';
import 'package:shared_models/shared_models.dart';

import 'package:barnostri_app/src/core/services/guard_mixin.dart';

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({bool? isAuthenticated, bool? isLoading, String? error}) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  AuthState copyWithGuard({bool? isLoading, String? error}) {
    return copyWith(isLoading: isLoading, error: error);
  }
}

class AuthService extends StateNotifier<AuthState> with GuardMixin<AuthState> {
  final AuthRepository _authRepository;
  final LoginUseCase _loginUseCase;
  late final StreamSubscription<supabase.AuthState> _authSub;

  AuthService(this._authRepository, this._loginUseCase)
      : super(const AuthState()) {
    final user = _authRepository.getCurrentUser();
    state = state.copyWith(isAuthenticated: user != null);
    _authSub = _authRepository.authStateChanges.listen((event) {
      state = state.copyWith(isAuthenticated: event.session?.user != null);
    });
  }

  @override
  void dispose() {
    _authSub.cancel();
    super.dispose();
  }

  @override
  AuthState copyWithGuard(AuthState state, {bool? isLoading, String? error}) {
    return state.copyWith(isLoading: isLoading, error: error);
  }

  Future<void> login({required String email, required String password}) async {
    await guard<void>(() async {
      await _loginUseCase(email: email, password: password);
      state = state.copyWith(isAuthenticated: true);
    });
  }

  Future<void> logout() async {
    await guard<void>(() async {
      await _authRepository.signOut();
      state = state.copyWith(isAuthenticated: false);
    });
  }
}

final authServiceProvider = StateNotifierProvider<AuthService, AuthState>((
  ref,
) {
  final repo = ref.watch(authRepositoryProvider);
  final login = LoginUseCase(repo);
  return AuthService(repo, login);
});
