import 'package:flutter_test/flutter_test.dart';
import 'package:shared_models/shared_models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final authRepo = SupabaseAuthRepository();
  final menuRepo = SupabaseMenuRepository();
  final pedidoRepo = SupabasePedidoRepository();

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
      final mesa = await menuRepo.getMesaByQrToken('mesa_001_qr');
      expect(mesa?.numero, '1');
    });

    test('fetchCategorias returns mock list', () async {
      final categorias = await menuRepo.fetchCategorias();
      expect(categorias.length, greaterThanOrEqualTo(1));
    });

    test('fetchItensCardapio returns mock list', () async {
      final itens = await menuRepo.fetchItensCardapio();
      expect(itens.length, greaterThanOrEqualTo(1));
    });

    test('fetchMesas returns mock list', () async {
      final mesas = await menuRepo.fetchMesas();
      expect(mesas.length, greaterThanOrEqualTo(1));
    });

    test('criarPedido returns mock id', () async {
      final item = ItemCardapio(
        id: 'i1',
        nome: 'Item',
        descricao: null,
        preco: 10.0,
        categoriaId: 'c1',
        disponivel: true,
        imagemUrl: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final id = await pedidoRepo.criarPedido(
        mesaId: '1',
        itens: [CartItem(item: item, quantidade: 1)],
        total: 10.0,
        formaPagamento: 'Pix',
      );
      expect(id, isNotNull);
      expect(id!.startsWith('mock-order-'), isTrue);
    });

    test('atualizarStatus retorna true', () async {
      final ok = await pedidoRepo.atualizarStatus('1', 'Pronto');
      expect(ok, isTrue);
    });

    test('fetchPedidos returns mock data', () async {
      final pedidos = await pedidoRepo.fetchPedidos();
      expect(pedidos.first.id, 'mock-order-1');
    });

    test('watchPedidos emits list', () async {
      final stream = pedidoRepo.watchPedidos();
      final first = await stream.first;
      expect(first, isA<List<Pedido>>());
    });
  });
}
