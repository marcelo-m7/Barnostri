import 'package:flutter/foundation.dart';
import '../../repositories/order_repository.dart';
import 'package:shared_models/shared_models.dart';

class SupabaseOrderRepository implements OrderRepository {
  @override
  Future<String?> criarPedido({
    required String mesaId,
    required List<Map<String, dynamic>> itens,
    required double total,
    required String formaPagamento,
  }) async {
    if (!SupabaseConfig.isConfigured) {
      if (kDebugMode) {
        print('📝 Mock order created: Mesa $mesaId, Total: R\$ $total');
      }
      return 'mock-order-${DateTime.now().millisecondsSinceEpoch}';
    }

    try {
      final pedidoResponse = await SupabaseConfig.client
          .from('pedidos')
          .insert({
            'mesa_id': mesaId,
            'status': 'Recebido',
            'total': total,
            'forma_pagamento': formaPagamento,
            'pago': false,
          })
          .select()
          .single();

      final pedidoId = pedidoResponse['id'];

      final itensData = itens
          .map(
            (item) => {
              'pedido_id': pedidoId,
              'item_cardapio_id': item['id'],
              'quantidade': item['quantidade'],
              'observacao': item['observacao'] ?? '',
              'preco_unitario': item['preco'],
            },
          )
          .toList();

      await SupabaseConfig.client.from('itens_pedido').insert(itensData);

      return pedidoId;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao criar pedido: $e');
      }
      return null;
    }
  }

  @override
  Future<bool> atualizarStatusPedido(String pedidoId, String novoStatus) async {
    if (!SupabaseConfig.isConfigured) {
      if (kDebugMode) {
        print('📊 Mock status update: $pedidoId -> $novoStatus');
      }
      return true;
    }

    try {
      await SupabaseConfig.client
          .from('pedidos')
          .update({'status': novoStatus})
          .eq('id', pedidoId);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao atualizar status do pedido: $e');
      }
      return false;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getPedidos() async {
    if (!SupabaseConfig.isConfigured) {
      return [
        {
          'id': 'mock-order-1',
          'mesa_id': '1',
          'status': 'Em preparo',
          'total': 67.80,
          'forma_pagamento': 'Pix',
          'pago': false,
          'created_at': DateTime.now()
              .subtract(const Duration(minutes: 10))
              .toIso8601String(),
          'updated_at': DateTime.now()
              .subtract(const Duration(minutes: 5))
              .toIso8601String(),
          'mesas': {
            'id': '1',
            'numero': '1',
            'qr_token': 'mesa_001_qr',
            'ativo': true,
          },
          'itens_pedido': [
            {
              'id': 'item-1',
              'pedido_id': 'mock-order-1',
              'item_cardapio_id': '3',
              'quantidade': 1,
              'observacao': 'Menos pimenta',
              'preco_unitario': 45.90,
              'itens_cardapio': {
                'id': '3',
                'nome': 'Moqueca de Peixe',
                'descricao': 'Moqueca tradicional com peixe fresco e dendê',
                'preco': 45.90,
              },
            },
            {
              'id': 'item-2',
              'pedido_id': 'mock-order-1',
              'item_cardapio_id': '2',
              'quantidade': 2,
              'observacao': '',
              'preco_unitario': 12.00,
              'itens_cardapio': {
                'id': '2',
                'nome': 'Caipirinha',
                'descricao': 'Caipirinha tradicional com cachaça e limão',
                'preco': 12.00,
              },
            },
          ],
        },
      ];
    }

    try {
      final response = await SupabaseConfig.client
          .from('pedidos')
          .select('*, mesas(*), itens_pedido(*, itens_cardapio(*))')
          .order('created_at', ascending: false);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar pedidos: $e');
      }
      return [];
    }
  }

  @override
  Stream<List<Map<String, dynamic>>> streamPedidos() {
    if (!SupabaseConfig.isConfigured) {
      return Stream.periodic(
        const Duration(seconds: 5),
        (count) => [
          {
            'id': 'mock-order-1',
            'mesa_id': '1',
            'status': 'Em preparo',
            'total': 67.80,
            'forma_pagamento': 'Pix',
            'pago': false,
            'created_at': DateTime.now()
                .subtract(const Duration(minutes: 10))
                .toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          },
        ],
      );
    }

    return SupabaseConfig.client
        .from('pedidos')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false);
  }

  @override
  Stream<Map<String, dynamic>> streamPedido(String pedidoId) {
    if (!SupabaseConfig.isConfigured) {
      return Stream.periodic(
        const Duration(seconds: 5),
        (count) => {
          'id': pedidoId,
          'mesa_id': '1',
          'status': 'Em preparo',
          'total': 67.80,
          'forma_pagamento': 'Pix',
          'pago': false,
          'created_at': DateTime.now()
              .subtract(const Duration(minutes: 10))
              .toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
      );
    }

    return SupabaseConfig.client
        .from('pedidos')
        .stream(primaryKey: ['id'])
        .eq('id', pedidoId)
        .map((data) => data.first);
  }
}
