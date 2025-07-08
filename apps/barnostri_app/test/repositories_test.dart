import 'package:flutter_test/flutter_test.dart';
import 'package:shared_models/shared_models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final auth = SupabaseAuthRepository();
  final menu = SupabaseMenuRepository();
  final pedidos = SupabasePedidoRepository();

  group('AuthRepository', () {
    test('valid login returns user', () async {
      final res = await auth.signIn(
        email: 'admin@barnostri.com',
        password: 'admin123',
      );
      expect(res.user?.id, 'demo-admin-id');
    });

    test('invalid login throws', () async {
      expect(
        () => auth.signIn(email: 'x', password: 'y'),
        throwsA(isA<AuthException>()),
      );
    });
  });

  group('MenuRepository', () {
    test('fetchCategorias returns list', () async {
      final cats = await menu.fetchCategorias();
      expect(cats, isNotEmpty);
    });

    test('fetchItensCardapio returns list', () async {
      final itens = await menu.fetchItensCardapio();
      expect(itens, isNotEmpty);
    });
  });

  group('PedidoRepository', () {
    test('create and update order', () async {
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
      final id = await pedidos.criarPedido(
        mesaId: '1',
        itens: [CartItem(item: item, quantidade: 1)],
        total: 10.0,
        formaPagamento: 'Pix',
      );
      expect(id, isNotNull);
      final ok = await pedidos.atualizarStatus(id!, 'Pronto');
      expect(ok, isTrue);
    });
  });
}
