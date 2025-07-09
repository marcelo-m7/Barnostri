import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:barnostri_app/main.dart';
import 'package:barnostri_app/src/core/services/guard_mixin.dart';
import 'package:barnostri_app/src/features/auth/presentation/controllers/auth_service.dart';
import 'package:shared_models/shared_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:barnostri_app/src/features/auth/presentation/pages/admin_page.dart';

class _FakeAuthRepository implements AuthRepository {
  bool loggedIn;
  _FakeAuthRepository(this.loggedIn);

  @override
  Future<supabase.AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    loggedIn = true;
    return supabase.AuthResponse();
  }

  @override
  Future<void> signOut() async {
    loggedIn = false;
  }

  @override
  supabase.User? getCurrentUser() {
    if (!loggedIn) return null;
    return const supabase.User(
      id: '1',
      appMetadata: {},
      userMetadata: {},
      aud: 'authenticated',
      createdAt: '',
    );
  }

  @override
  Stream<supabase.AuthState> get authStateChanges => const Stream.empty();
}

class FakeAuthService extends AuthService {
  FakeAuthService(bool loggedIn)
      : super(_FakeAuthRepository(loggedIn), LoginUseCase(_FakeAuthRepository(loggedIn))) {
    state = state.copyWith(isAuthenticated: loggedIn);
  }

  @override
  Future<void> login({required String email, required String password}) async {}

  @override
  Future<void> logout() async {}
}

void main() {
  testWidgets('Admin route shows login when not authenticated', (tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authServiceProvider.overrideWith((ref) => FakeAuthService(false)),
        ],
        child: const BarnostriApp(),
      ),
    );

    final router = GoRouter.of(tester.element(find.byType(BarnostriApp)));
    router.go('/admin');
    await tester.pumpAndSettle();
    expect(find.byType(AdminPage), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });

  testWidgets('Admin route shows dashboard when authenticated', (tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authServiceProvider.overrideWith((ref) => FakeAuthService(true)),
        ],
        child: const BarnostriApp(),
      ),
    );

    final router = GoRouter.of(tester.element(find.byType(BarnostriApp)));
    router.go('/admin');
    await tester.pumpAndSettle();
    expect(find.byType(AdminPage), findsOneWidget);
    expect(find.textContaining('Pedidos'), findsOneWidget);
  });
}

