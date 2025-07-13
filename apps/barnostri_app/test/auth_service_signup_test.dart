import 'package:flutter_test/flutter_test.dart';
import 'package:shared_models/shared_models.dart';
import 'package:barnostri_app/src/features/auth/presentation/controllers/auth_service.dart';
import 'package:barnostri_app/src/features/auth/data/repositories/supabase_profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class _FakeAuthRepository implements AuthRepository {
  final String? userId;
  bool signedUp = false;

  _FakeAuthRepository(this.userId);

  @override
  Future<supabase.AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return supabase.AuthResponse();
  }

  @override
  Future<supabase.AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    signedUp = true;
    if (userId == null) return supabase.AuthResponse();
    return supabase.AuthResponse(
      user: supabase.User(
        id: userId!,
        appMetadata: const {},
        userMetadata: const {},
        aud: 'authenticated',
        createdAt: DateTime.now().toIso8601String(),
      ),
      session: null,
    );
  }

  @override
  Future<void> signOut() async {}

  @override
  supabase.User? getCurrentUser() => null;

  @override
  Stream<supabase.AuthState> get authStateChanges => const Stream.empty();
}

class _FakeProfileRepository implements ProfileRepository {
  int calls = 0;
  UserProfile? lastProfile;

  @override
  Future<void> createProfile(UserProfile profile) async {
    calls++;
    lastProfile = profile;
  }

  @override
  Future<UserProfile?> fetchProfile(String id) async => null;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthService.signUp', () {
    test('successful signup updates state', () async {
      final repo = _FakeAuthRepository('u1');
      final profileRepo = _FakeProfileRepository();
      final service = AuthService(
        repo,
        LoginUseCase(repo),
        SignUpUseCase(repo),
        profileRepo,
      );
      final profile = UserProfile(
        id: '',
        name: 'User',
        phone: '123',
        userType: 'cliente',
        storeName: null,
        createdAt: DateTime.now(),
      );

      await service.signUp(
        email: 'test@example.com',
        password: 'secret',
        profile: profile,
      );

      expect(repo.signedUp, isTrue);
      expect(profileRepo.calls, 1);
      expect(profileRepo.lastProfile?.id, 'u1');
      expect(service.state.isAuthenticated, isTrue);
    });

    test('failed signup sets error', () async {
      final repo = _FakeAuthRepository(null);
      final profileRepo = _FakeProfileRepository();
      final service = AuthService(
        repo,
        LoginUseCase(repo),
        SignUpUseCase(repo),
        profileRepo,
      );
      final profile = UserProfile(
        id: '',
        name: 'User',
        phone: '123',
        userType: 'cliente',
        storeName: null,
        createdAt: DateTime.now(),
      );

      await service.signUp(
        email: 'fail@example.com',
        password: 'secret',
        profile: profile,
      );
      await Future.delayed(Duration.zero);

      expect(service.state.isAuthenticated, isFalse);
      expect(profileRepo.calls, 0);
    });
  });
}
