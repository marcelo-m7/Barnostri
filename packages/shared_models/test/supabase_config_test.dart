import 'package:flutter_test/flutter_test.dart';
import 'package:shared_models/shared_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SupabaseConfig mock helpers', () {
    test('signInWithEmail returns mock user', () async {
      final res = await SupabaseConfig.signInWithEmail(
        email: 'admin@barnostri.com',
        password: 'admin123',
      );
      expect(res.user?.id, 'demo-admin-id');
    });

    test('signInWithEmail invalid throws', () async {
      expect(
        () => SupabaseConfig.signInWithEmail(
          email: 'wrong',
          password: 'bad',
        ),
        throwsA(isA<AuthException>()),
      );
    });

    test('getCurrentUser returns null when not configured', () {
      expect(SupabaseConfig.getCurrentUser(), isNull);
    });

    test('getMesaByQrToken returns mock mesa', () async {
      final mesa = await SupabaseConfig.getMesaByQrToken('mesa_001_qr');
      expect(mesa?['numero'], '1');
    });

    test('getCategorias returns mock list', () async {
      final categorias = await SupabaseConfig.getCategorias();
      expect(categorias.length, greaterThanOrEqualTo(1));
    });

    test('getItensCardapio returns mock list', () async {
      final itens = await SupabaseConfig.getItensCardapio();
      expect(itens.length, greaterThanOrEqualTo(1));
    });

    test('criarPedido returns mock id', () async {
      final id = await SupabaseConfig.criarPedido(
        mesaId: '1',
        itens: const [
          {'id': 'i1', 'quantidade': 1, 'preco': 10.0}
        ],
        total: 10.0,
        formaPagamento: 'Pix',
      );
      expect(id, isNotNull);
      expect(id!.startsWith('mock-order-'), isTrue);
    });

    test('atualizarStatusPedido returns true', () async {
      final ok = await SupabaseConfig.atualizarStatusPedido('1', 'Pronto');
      expect(ok, isTrue);
    });

    test('getPedidos returns mock data', () async {
      final pedidos = await SupabaseConfig.getPedidos();
      expect(pedidos.first['id'], 'mock-order-1');
    });
  });
}
