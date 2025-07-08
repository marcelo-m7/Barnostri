abstract class PedidoRepository {
  Future<String?> criarPedido({
    required String mesaId,
    required List<Map<String, dynamic>> itens,
    required double total,
    required String formaPagamento,
  });

  Future<bool> atualizarStatus(String pedidoId, String novoStatus);

  Future<List<Map<String, dynamic>>> fetchPedidos();

  Stream<List<Map<String, dynamic>>> watchPedidos();

  Stream<Map<String, dynamic>> watchPedido(String pedidoId);
}
