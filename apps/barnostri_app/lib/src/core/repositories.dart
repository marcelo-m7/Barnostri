import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/data/supabase_auth_repository.dart';
import '../features/menu/data/menu_repository.dart';
import '../features/menu/data/supabase_menu_repository.dart';
import '../features/order/data/order_repository.dart';
import '../features/order/data/supabase_order_repository.dart';
import 'services/supabase_config.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => SupabaseAuthRepository(ref.watch(supabaseClientProvider)),
);
final menuRepositoryProvider = Provider<MenuRepository>(
  (ref) => SupabaseMenuRepository(ref.watch(supabaseClientProvider)),
);
final orderRepositoryProvider = Provider<OrderRepository>(
  (ref) => SupabaseOrderRepository(ref.watch(supabaseClientProvider)),
);
