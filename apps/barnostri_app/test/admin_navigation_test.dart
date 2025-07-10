import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barnostri_app/main.dart';
import 'package:barnostri_app/src/features/auth/presentation/controllers/auth_service.dart';
import 'package:shared_models/shared_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:barnostri_app/src/features/auth/presentation/pages/admin_page.dart';
import 'package:barnostri_app/src/core/repositories.dart';

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
    : super(
        _FakeAuthRepository(loggedIn),
        LoginUseCase(_FakeAuthRepository(loggedIn)),
      ) {
    state = state.copyWith(isAuthenticated: loggedIn);
  }

  @override
  Future<void> login({required String email, required String password}) async {}

  @override
  Future<void> logout() async {}
}

class _FakeOrderRepository implements OrderRepository {
  @override
  Future<String?> createOrder({
    required String tableId,
    required List<CartItem> items,
    required double total,
    required String paymentMethod,
  }) async => 'mock';

  @override
  Future<bool> updateStatus(String orderId, String newStatus) async => true;

  @override
  Future<List<Order>> fetchOrders() async => [];

  @override
  Stream<List<Order>> watchOrders() => Stream.value([]);

  @override
  Stream<Order> watchOrder(String orderId) => const Stream.empty();
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
          orderRepositoryProvider.overrideWith((ref) => _FakeOrderRepository()),
        ],
        child: const BarnostriApp(),
      ),
    );
    await tester.pump();
    await tester.pumpAndSettle();

    appRouter.go('/admin');
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
          orderRepositoryProvider.overrideWith((ref) => _FakeOrderRepository()),
        ],
        child: const BarnostriApp(),
      ),
    );
    await tester.pump();
    await tester.pumpAndSettle();

    appRouter.go('/admin');
    await tester.pumpAndSettle();
    expect(find.byType(AdminPage), findsOneWidget);
    expect(find.textContaining('Pedidos'), findsOneWidget);
  });
}
