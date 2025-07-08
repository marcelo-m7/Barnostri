import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_models/shared_models.dart';
import '../features/auth/data/repositories/supabase_auth_repository.dart';
import '../features/menu/data/repositories/supabase_menu_repository.dart';
import '../features/order/data/repositories/supabase_order_repository.dart';
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
