import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_models/shared_models.dart';
import '../../domain/usecases/login_use_case.dart';

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
  final LoginUseCase _loginUseCase;
  AuthService(this._authRepository, this._loginUseCase) : super(const AuthState()) {
    final user = _authRepository.getCurrentUser();
    state = state.copyWith(isAuthenticated: user != null);
    _authRepository.authStateChanges.listen((event) {
      state = state.copyWith(
        isAuthenticated: event.session != null || event.user != null,
      );
    });
  }

  Future<T?> _guard<T>(Future<T> Function() action) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      return await action();
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> login({required String email, required String password}) async {
    await _guard<void>(() async {
      await _loginUseCase(email: email, password: password);
      state = state.copyWith(isAuthenticated: true);
    });
  }

  Future<void> logout() async {
    await _guard<void>(() async {
      await _authRepository.signOut();
      state = state.copyWith(isAuthenticated: false);
    });
  }
}

final authServiceProvider = StateNotifierProvider<AuthService, AuthState>(
  (ref) {
    final repo = ref.watch(authRepositoryProvider);
    final login = LoginUseCase(repo);
    return AuthService(repo, login);
  },
);
