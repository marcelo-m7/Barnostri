import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barnostri_app/src/core/app_providers.dart';
import 'package:barnostri_app/src/core/repositories.dart';
import 'package:barnostri_app/src/features/home/presentation/pages/home_page.dart';
import 'package:barnostri_app/src/features/menu/presentation/pages/menu_page.dart';
import 'package:barnostri_app/src/features/order/presentation/pages/cart_page.dart';
import 'package:barnostri_app/src/features/auth/presentation/pages/admin_page.dart';
import 'package:barnostri_app/src/features/menu/data/repositories/supabase_menu_repository.dart';
import 'package:barnostri_app/src/features/order/data/repositories/supabase_order_repository.dart';
import 'package:barnostri_app/src/features/auth/presentation/controllers/auth_service.dart';
import 'package:shared_models/shared_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:barnostri_app/l10n/generated/app_localizations.dart';
import 'package:barnostri_app/src/core/services/language_service.dart';

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

void main() {
  final devices = [
    const Device(name: 'mobile', size: Size(375, 812), devicePixelRatio: 1),
    const Device(name: 'web', size: Size(1200, 800), devicePixelRatio: 1),
  ];

  testGoldens('HomePage golden', (tester) async {
    final builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: devices)
      ..addScenario(
        widget: ProviderScope(
          overrides: [demoModeProvider.overrideWithValue(false)],
          child: const HomePage(),
        ),
        name: 'home',
      );

    await tester.pumpDeviceBuilder(
      builder,
      wrapper: materialAppWrapper(
        localizations: AppLocalizations.localizationsDelegates,
        localeOverrides: LanguageService.supportedLocales,
      ),
    );
    await screenMatchesGolden(tester, 'home_page');
  });

  testGoldens('MenuPage golden', (tester) async {
    final builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: devices)
      ..addScenario(
        widget: ProviderScope(
          overrides: [
            menuRepositoryProvider
                .overrideWithValue(SupabaseMenuRepository(null)),
            orderRepositoryProvider
                .overrideWithValue(SupabaseOrderRepository(null)),
            demoModeProvider.overrideWithValue(false),
          ],
          child: const MenuPage(),
        ),
        name: 'menu',
      );

    await tester.pumpDeviceBuilder(
      builder,
      wrapper: materialAppWrapper(
        localizations: AppLocalizations.localizationsDelegates,
        localeOverrides: LanguageService.supportedLocales,
      ),
    );
    await screenMatchesGolden(tester, 'menu_page');
  });

  testGoldens('CartPage golden', (tester) async {
    final builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: devices)
      ..addScenario(
        widget: ProviderScope(
          overrides: [
            orderRepositoryProvider
                .overrideWithValue(SupabaseOrderRepository(null)),
            menuRepositoryProvider
                .overrideWithValue(SupabaseMenuRepository(null)),
            demoModeProvider.overrideWithValue(false),
          ],
          child: const CartPage(),
        ),
        name: 'cart',
      );

    await tester.pumpDeviceBuilder(
      builder,
      wrapper: materialAppWrapper(
        localizations: AppLocalizations.localizationsDelegates,
        localeOverrides: LanguageService.supportedLocales,
      ),
    );
    await screenMatchesGolden(tester, 'cart_page');
  });

  testGoldens('AdminPage golden', (tester) async {
    final builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: devices)
      ..addScenario(
        widget: ProviderScope(
          overrides: [
            authServiceProvider.overrideWith((ref) => FakeAuthService(true)),
            orderRepositoryProvider
                .overrideWithValue(SupabaseOrderRepository(null)),
            menuRepositoryProvider
                .overrideWithValue(SupabaseMenuRepository(null)),
            demoModeProvider.overrideWithValue(false),
          ],
          child: const AdminPage(),
        ),
        name: 'admin',
      );

    await tester.pumpDeviceBuilder(
      builder,
      wrapper: materialAppWrapper(
        localizations: AppLocalizations.localizationsDelegates,
        localeOverrides: LanguageService.supportedLocales,
      ),
    );
    await screenMatchesGolden(tester, 'admin_page');
  });
}
