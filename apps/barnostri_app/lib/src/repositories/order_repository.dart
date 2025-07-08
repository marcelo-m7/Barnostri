abstract class OrderRepository {
  Future<String?> criarPedido({
    required String mesaId,
    required List<Map<String, dynamic>> itens,
    required double total,
    required String formaPagamento,
  });

  Future<bool> atualizarStatusPedido(String pedidoId, String novoStatus);

  Future<List<Map<String, dynamic>>> getPedidos();

  Stream<List<Map<String, dynamic>>> streamPedidos();

  Stream<Map<String, dynamic>> streamPedido(String pedidoId);
}
