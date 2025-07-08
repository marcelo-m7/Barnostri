import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_models/shared_models.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) => SupabaseAuthRepository());
final menuRepositoryProvider = Provider<MenuRepository>((ref) => SupabaseMenuRepository());
final pedidoRepositoryProvider = Provider<PedidoRepository>((ref) => SupabasePedidoRepository());
