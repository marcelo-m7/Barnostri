import 'package:flutter/foundation.dart';
import '../../models/order.dart';
import '../../models/order_item.dart';
import '../../models/menu_item.dart';
import '../../models/table.dart';
import '../../../services/supabase_config.dart';
import 'pedido_repository.dart';

class SupabasePedidoRepository implements PedidoRepository {
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
  Future<bool> atualizarStatus(String pedidoId, String novoStatus) async {
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
  Future<List<Pedido>> fetchPedidos() async {
    if (!SupabaseConfig.isConfigured) {
      return [
        Pedido(
          id: 'mock-order-1',
          mesaId: '1',
          status: 'Em preparo',
          total: 67.80,
          formaPagamento: 'Pix',
          pago: false,
          createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
          updatedAt: DateTime.now().subtract(const Duration(minutes: 5)),
          mesa: Mesa(
            id: '1',
            numero: '1',
            qrToken: 'mesa_001_qr',
            ativo: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          itens: [
            ItemPedido(
              id: 'item-1',
              pedidoId: 'mock-order-1',
              itemCardapioId: '3',
              quantidade: 1,
              observacao: 'Menos pimenta',
              precoUnitario: 45.90,
              createdAt: DateTime.now(),
              itemCardapio: ItemCardapio(
                id: '3',
                nome: 'Moqueca de Peixe',
                descricao: 'Moqueca tradicional com peixe fresco e dendê',
                preco: 45.90,
                categoriaId: '',
                disponivel: true,
                imagemUrl: null,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
            ),
            ItemPedido(
              id: 'item-2',
              pedidoId: 'mock-order-1',
              itemCardapioId: '2',
              quantidade: 2,
              observacao: '',
              precoUnitario: 12.00,
              createdAt: DateTime.now(),
              itemCardapio: ItemCardapio(
                id: '2',
                nome: 'Caipirinha',
                descricao: 'Caipirinha tradicional com cachaça e limão',
                preco: 12.00,
                categoriaId: '',
                disponivel: true,
                imagemUrl: null,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
            ),
          ],
        ),
      ];
    }
    try {
      final response = await SupabaseConfig.client
          .from('pedidos')
          .select('*, mesas(*), itens_pedido(*, itens_cardapio(*))')
          .order('created_at', ascending: false);
      return (response as List<dynamic>)
          .map((e) => Pedido.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar pedidos: $e');
      }
      return [];
    }
  }

  @override
  Stream<List<Pedido>> watchPedidos() {
    if (!SupabaseConfig.isConfigured) {
      return Stream.periodic(
        const Duration(seconds: 5),
        (count) => [
          Pedido(
            id: 'mock-order-1',
            mesaId: '1',
            status: 'Em preparo',
            total: 67.80,
            formaPagamento: 'Pix',
            pago: false,
            createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
            updatedAt: DateTime.now(),
          ),
        ],
      );
    }
    return SupabaseConfig.client
        .from('pedidos')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map(
          (list) => list
              .map((e) => Pedido.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
  }

  @override
  Stream<Pedido> watchPedido(String pedidoId) {
    if (!SupabaseConfig.isConfigured) {
      return Stream.periodic(
        const Duration(seconds: 5),
        (count) => Pedido(
          id: pedidoId,
          mesaId: '1',
          status: 'Em preparo',
          total: 67.80,
          formaPagamento: 'Pix',
          pago: false,
          createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
          updatedAt: DateTime.now(),
        ),
      );
    }
    return SupabaseConfig.client
        .from('pedidos')
        .stream(primaryKey: ['id'])
        .eq('id', pedidoId)
        .map((data) => Pedido.fromJson(data.first as Map<String, dynamic>));
  }
}
