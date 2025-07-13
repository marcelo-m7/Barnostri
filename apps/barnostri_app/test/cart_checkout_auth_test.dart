import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barnostri_app/src/features/order/presentation/pages/cart_page.dart';
import 'package:barnostri_app/src/features/auth/presentation/controllers/auth_service.dart';
import 'package:barnostri_app/src/features/order/presentation/controllers/order_service.dart';
import 'package:barnostri_app/src/features/order/data/repositories/supabase_order_repository.dart';
import 'package:barnostri_app/src/features/menu/data/repositories/supabase_menu_repository.dart';
import 'package:barnostri_app/src/core/app_providers.dart';
import 'package:barnostri_app/l10n/generated/app_localizations.dart';
import 'package:barnostri_app/src/core/services/language_service.dart';
import 'package:shared_models/shared_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:barnostri_app/src/features/auth/data/repositories/supabase_profile_repository.dart';

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
  Future<supabase.AuthResponse> signUp({
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
          SignUpUseCase(_FakeAuthRepository(loggedIn)),
          SupabaseProfileRepository(null),
        ) {
    state = state.copyWith(isAuthenticated: loggedIn);
  }

  @override
  Future<void> login({required String email, required String password}) async {}

  @override
  Future<void> logout() async {}
}

class FakeOrderService extends OrderService {
  FakeOrderService(Reader read)
      : super(
          read,
          SupabaseOrderRepository(null),
          SupabaseMenuRepository(null),
          CreateOrderUseCase(SupabaseOrderRepository(null)),
          UpdateOrderStatusUseCase(SupabaseOrderRepository(null)),
        ) {
    final table = TableModel(
      id: 't1',
      number: '1',
      qrToken: 't1_qr',
      active: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    setTable(table);
    final item = MenuItem(
      id: 'm1',
      name: 'Item',
      description: null,
      price: 5.0,
      categoryId: 'c1',
      available: true,
      imageUrl: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      category: null,
    );
    addToCart(item);
  }

  bool paymentCalled = false;

  @override
  Future<bool> processPayment(
      {required PaymentMethod method, required double amount}) async {
    paymentCalled = true;
    return true;
  }

  @override
  Future<String?> createOrder({required PaymentMethod paymentMethod}) async {
    return 'order1234';
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('unauthenticated users see login prompt', (tester) async {
    late FakeOrderService orderService;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authServiceProvider.overrideWith((ref) => FakeAuthService(false)),
          orderServiceProvider.overrideWith((ref) {
            orderService = FakeOrderService(ref.read);
            return orderService;
          }),
          demoModeProvider.overrideWithValue(false),
        ],
        child: const MaterialApp(
          locale: Locale('en', 'GB'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: LanguageService.supportedLocales,
          home: CartPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('Checkout'));
    await tester.pumpAndSettle();

    final l10n = AppLocalizations.of(tester.element(find.byType(CartPage)));
    expect(find.text(l10n.loginRequired), findsOneWidget);
    expect(orderService.paymentCalled, isFalse);
  });

  testWidgets('authenticated users proceed with checkout', (tester) async {
    late FakeOrderService orderService;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authServiceProvider.overrideWith((ref) => FakeAuthService(true)),
          orderServiceProvider.overrideWith((ref) {
            orderService = FakeOrderService(ref.read);
            return orderService;
          }),
          demoModeProvider.overrideWithValue(false),
        ],
        child: const MaterialApp(
          locale: Locale('en', 'GB'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: LanguageService.supportedLocales,
          home: CartPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('Checkout'));
    await tester.pump();

    final l10n = AppLocalizations.of(tester.element(find.byType(CartPage)));
    expect(orderService.paymentCalled, isTrue);
    expect(find.text(l10n.loginRequired), findsNothing);
  });
}
