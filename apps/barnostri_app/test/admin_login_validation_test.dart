import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barnostri_app/src/features/auth/presentation/pages/admin_page.dart';
import 'package:barnostri_app/src/features/auth/presentation/controllers/auth_service.dart';
import 'package:barnostri_app/src/core/services/language_service.dart';
import 'package:barnostri_app/l10n/generated/app_localizations.dart';
import 'package:barnostri_app/src/core/repositories.dart';
import 'package:shared_models/shared_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

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

class TrackingAuthService extends AuthService {
  int loginCalls = 0;

  TrackingAuthService()
      : super(_FakeAuthRepository(false),
            LoginUseCase(_FakeAuthRepository(false))) {
    state = state.copyWith(isAuthenticated: false);
  }

  @override
  Future<void> login({required String email, required String password}) async {
    loginCalls++;
  }

  @override
  Future<void> logout() async {}
}

Future<void> _pumpAdminPage(
    WidgetTester tester, TrackingAuthService service) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authServiceProvider.overrideWith((ref) => service),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: LanguageService.supportedLocales,
        home: const AdminPage(),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('does not login when fields are empty', (tester) async {
    final service = TrackingAuthService();
    await _pumpAdminPage(tester, service);

    final context = tester.element(find.byType(AdminPage));
    final l10n = AppLocalizations.of(context);

    await tester.tap(find.text('Entrar'));
    await tester.pump();

    expect(service.loginCalls, 0);
    expect(find.text(l10n.fillAllFields), findsOneWidget);
  });

  testWidgets('does not login when password is empty', (tester) async {
    final service = TrackingAuthService();
    await _pumpAdminPage(tester, service);

    final context = tester.element(find.byType(AdminPage));
    final l10n = AppLocalizations.of(context);

    await tester.enterText(find.byType(TextField).first, 'admin@barnostri.com');
    await tester.tap(find.text('Entrar'));
    await tester.pump();

    expect(service.loginCalls, 0);
    expect(find.text(l10n.fillAllFields), findsOneWidget);
  });

  testWidgets('does not login when email is empty', (tester) async {
    final service = TrackingAuthService();
    await _pumpAdminPage(tester, service);

    final context = tester.element(find.byType(AdminPage));
    final l10n = AppLocalizations.of(context);

    // Second text field is password field
    await tester.enterText(find.byType(TextField).last, 'pass');
    await tester.tap(find.text('Entrar'));
    await tester.pump();

    expect(service.loginCalls, 0);
    expect(find.text(l10n.fillAllFields), findsOneWidget);
  });
}
