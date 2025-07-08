import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/data/supabase_auth_repository.dart';
import '../features/menu/data/menu_repository.dart';
import '../features/menu/data/supabase_menu_repository.dart';
import '../features/order/data/order_repository.dart';
import '../features/order/data/supabase_order_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => SupabaseAuthRepository(),
);
final menuRepositoryProvider = Provider<MenuRepository>(
  (ref) => SupabaseMenuRepository(),
);
final orderRepositoryProvider = Provider<OrderRepository>(
  (ref) => SupabaseOrderRepository(),
);
