import 'package:flutter_test/flutter_test.dart';
import 'package:shared_models/shared_models.dart';
import 'package:barnostri_app/src/features/auth/data/supabase_auth_repository.dart';
import 'package:barnostri_app/src/features/menu/data/supabase_menu_repository.dart';
import 'package:barnostri_app/src/features/order/data/supabase_order_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final authRepo = SupabaseAuthRepository(null);
  final menuRepo = SupabaseMenuRepository(null);
  final pedidoRepo = SupabaseOrderRepository(null);

  group('Supabase repositories mock helpers', () {
    test('signIn returns mock user', () async {
      final res = await authRepo.signIn(
        email: 'admin@barnostri.com',
        password: 'admin123',
      );
      expect(res.user?.id, 'demo-admin-id');
    });

    test('signIn invalid throws', () async {
      expect(
        () => authRepo.signIn(email: 'wrong', password: 'bad'),
        throwsA(isA<AuthException>()),
      );
    });

    test('getCurrentUser returns null when not configured', () {
      expect(authRepo.getCurrentUser(), isNull);
    });

    test('getMesaByQrToken returns mock mesa', () async {
      final mesa = await menuRepo.getTableByQrToken('mesa_001_qr');
      expect(mesa?.number, '1');
    });

    test('fetchCategorias returns mock list', () async {
      final categorias = await menuRepo.fetchCategories();
      expect(categorias.length, greaterThanOrEqualTo(1));
    });

    test('fetchItensCardapio returns mock list', () async {
      final itens = await menuRepo.fetchMenuItems();
      expect(itens.length, greaterThanOrEqualTo(1));
    });

    test('fetchMesas returns mock list', () async {
      final mesas = await menuRepo.fetchTables();
      expect(mesas.length, greaterThanOrEqualTo(1));
    });

    test('criarPedido returns mock id', () async {
      final item = MenuItem(
        id: 'i1',
        name: 'Item',
        description: null,
        price: 10.0,
        categoriaId: 'c1',
        available: true,
        imageUrl: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final id = await pedidoRepo.createOrder(
        tableId: '1',
        items: [CartItem(item: item, quantity: 1)],
        total: 10.0,
        paymentMethod: 'Pix',
      );
      expect(id, isNotNull);
      expect(id!.startsWith('mock-order-'), isTrue);
    });

    test('atualizarStatus retorna true', () async {
      final ok = await pedidoRepo.updateStatus('1', 'Pronto');
      expect(ok, isTrue);
    });

    test('fetchPedidos returns mock data', () async {
      final pedidos = await pedidoRepo.fetchOrders();
      expect(pedidos.first.id, 'mock-order-1');
    });

    test('watchPedidos emits list', () async {
      final stream = pedidoRepo.watchOrders();
      final first = await stream.first;
      expect(first, isA<List<Order>>());
    });
  });
}
