import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_models/shared_models.dart';

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
}

class AuthService extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  AuthService(this._authRepository) : super(const AuthState()) {
    final user = _authRepository.getCurrentUser();
    state = state.copyWith(isAuthenticated: user != null);
    _authRepository.authStateChanges.listen((event) {
      state = state.copyWith(
        isAuthenticated: event.session != null || event.user != null,
      );
    });
  }

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authRepository.signIn(email: email, password: password);
      state = state.copyWith(isAuthenticated: true);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authRepository.signOut();
      state = state.copyWith(isAuthenticated: false);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final authServiceProvider = StateNotifierProvider<AuthService, AuthState>((
  ref,
) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthService(repo);
});
