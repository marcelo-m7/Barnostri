import '../../models/order.dart';
import '../../models/cart_item.dart';

abstract class PedidoRepository {
  Future<String?> criarPedido({
    required String mesaId,
    required List<CartItem> itens,
    required double total,
    required String formaPagamento,
  });

  Future<bool> atualizarStatus(String pedidoId, String novoStatus);

  Future<List<Pedido>> fetchPedidos();

  Stream<List<Pedido>> watchPedidos();

  Stream<Pedido> watchPedido(String pedidoId);
}
