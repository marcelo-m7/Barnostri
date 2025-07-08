import '../../models/order.dart';

abstract class PedidoRepository {
  Future<String?> criarPedido({
    required String mesaId,
    required List<Map<String, dynamic>> itens,
    required double total,
    required String formaPagamento,
  });

  Future<bool> atualizarStatus(String pedidoId, String novoStatus);

  Future<List<Pedido>> fetchPedidos();

  Stream<List<Pedido>> watchPedidos();

  Stream<Pedido> watchPedido(String pedidoId);
}
