abstract class MenuRepository {
  Future<List<Map<String, dynamic>>> getCategorias();
  Future<List<Map<String, dynamic>>> getItensCardapio();
  Future<List<Map<String, dynamic>>> getMesas();
  Future<Map<String, dynamic>?> getMesaByQrToken(String qrToken);

  Future<Map<String, dynamic>> addCategoria({
    required String nome,
    required int ordem,
  });

  Future<void> updateCategoria(
    String id, {
    String? nome,
    int? ordem,
    bool? ativo,
  });

  Future<Map<String, dynamic>> addItemCardapio({
    required String nome,
    String? descricao,
    required double preco,
    required String categoriaId,
    String? imagemUrl,
  });

  Future<void> updateItemCardapio(
    String id, {
    String? nome,
    String? descricao,
    double? preco,
    String? categoriaId,
    bool? disponivel,
    String? imagemUrl,
  });

  Future<bool> deleteItemCardapio(String id);

  Future<Map<String, dynamic>> addMesa({
    required String numero,
    required String qrToken,
  });
}
