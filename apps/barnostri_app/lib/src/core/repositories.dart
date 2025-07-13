import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_models/shared_models.dart';
import 'package:barnostri_app/src/features/auth/data/repositories/supabase_auth_repository.dart';
import 'package:barnostri_app/src/features/menu/data/repositories/supabase_menu_repository.dart';
import 'package:barnostri_app/src/features/order/data/repositories/supabase_order_repository.dart';
import 'package:barnostri_app/src/features/auth/data/repositories/supabase_profile_repository.dart';
import 'package:barnostri_app/src/core/services/supabase_config.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => SupabaseAuthRepository(ref.watch(supabaseClientProvider)),
);
final menuRepositoryProvider = Provider<MenuRepository>(
  (ref) => SupabaseMenuRepository(ref.watch(supabaseClientProvider)),
);
final orderRepositoryProvider = Provider<OrderRepository>(
  (ref) => SupabaseOrderRepository(ref.watch(supabaseClientProvider)),
);
final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => SupabaseProfileRepository(ref.watch(supabaseClientProvider)),
);
