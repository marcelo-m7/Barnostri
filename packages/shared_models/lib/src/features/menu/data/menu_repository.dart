abstract class MenuRepository {
  Future<List<Map<String, dynamic>>> fetchMesas();
  Future<Map<String, dynamic>?> getMesaByQrToken(String qrToken);
  Future<List<Map<String, dynamic>>> fetchCategorias();
  Future<List<Map<String, dynamic>>> fetchItensCardapio();

  Future<Map<String, dynamic>> addCategoria({
    required String nome,
    required int ordem,
  });

  Future<bool> updateCategoria({
    required String id,
    String? nome,
    int? ordem,
    bool? ativo,
  });

  Future<bool> deleteCategoria(String id);

  Future<Map<String, dynamic>> addItemCardapio({
    required String nome,
    String? descricao,
    required double preco,
    required String categoriaId,
    String? imagemUrl,
  });

  Future<bool> updateItemCardapio({
    required String id,
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

  Future<bool> updateMesa({
    required String id,
    String? numero,
    String? qrToken,
    bool? ativo,
  });

  Future<bool> deleteMesa(String id);
}
