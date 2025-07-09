import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:barnostri_app/main.dart';
import 'package:barnostri_app/src/core/services/guard_mixin.dart';
import 'package:barnostri_app/src/features/auth/presentation/controllers/auth_service.dart';
import 'package:barnostri_app/src/features/auth/presentation/pages/admin_page.dart';

class FakeAuthService extends StateNotifier<AuthState> with GuardMixin<AuthState> {
  FakeAuthService(bool loggedIn) : super(AuthState(isAuthenticated: loggedIn));

  @override
  AuthState copyWithGuard(AuthState state, {bool? isLoading, String? error}) {
    return state.copyWith(isLoading: isLoading, error: error);
  }

  Future<void> login({String email = '', String password = ''}) async {}
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
