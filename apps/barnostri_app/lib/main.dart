import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:barnostri_app/src/core/theme/theme.dart';
import 'package:barnostri_app/src/core/services/supabase_config.dart';
import 'package:barnostri_app/src/core/services/language_service.dart';
import 'package:barnostri_app/src/features/order/presentation/pages/qr_scanner_page.dart';
import 'package:barnostri_app/src/features/order/presentation/pages/cart_page.dart';
import 'package:barnostri_app/src/features/menu/presentation/pages/menu_page.dart';
import 'package:barnostri_app/src/features/auth/presentation/pages/admin_page.dart';
import 'package:barnostri_app/src/features/auth/presentation/controllers/auth_service.dart';
import 'l10n/generated/app_localizations.dart';
import 'package:barnostri_app/src/features/home/presentation/pages/home_page.dart';

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
    GoRoute(
      path: '/scanner',
      builder: (context, state) => const QrScannerPage(),
    ),
    GoRoute(
      path: '/menu',
      builder: (context, state) => const MenuPage(),
    ),
    GoRoute(path: '/cart', builder: (context, state) => const CartPage()),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminPage(),
      redirect: (context, state) {
        final container = ProviderScope.containerOf(context, listen: false);
        final isAuth = container.read(authServiceProvider).isAuthenticated;
        if (!isAuth) {
          return '/';
        }
        return null;
      },
    ),
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase and provide the client
  final client = await SupabaseConfig.createClient();

  final container = ProviderContainer(
    overrides: [supabaseClientProvider.overrideWithValue(client)],
  );
  await container.read(languageServiceProvider.notifier).initialize();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const BarnostriApp(),
    ),
  );
}

class BarnostriApp extends ConsumerWidget {
  const BarnostriApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageNotifier = ref.watch(languageServiceProvider.notifier);
    final locale = ref.watch(languageServiceProvider);

    return MaterialApp.router(
      title: 'Barnostri',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: LanguageService.supportedLocales,
      locale: locale,
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        if (deviceLocale != null) {
          return languageNotifier.getBestMatchingLocale([deviceLocale]);
        }
        return LanguageService.defaultLocale;
      },
    );
  }
}
