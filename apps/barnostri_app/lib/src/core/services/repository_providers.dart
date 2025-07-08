import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../repositories/order_repository.dart';
import '../../repositories/menu_repository.dart';
import '../../repositories/supabase/supabase_order_repository.dart';
import '../../repositories/supabase/supabase_menu_repository.dart';

final orderRepositoryProvider = Provider<OrderRepository>(
  (ref) => SupabaseOrderRepository(),
);

final menuRepositoryProvider = Provider<MenuRepository>(
  (ref) => SupabaseMenuRepository(),
);
