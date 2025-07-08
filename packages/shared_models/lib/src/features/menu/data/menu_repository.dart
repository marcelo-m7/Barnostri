abstract class MenuRepository {
  Future<List<Map<String, dynamic>>> fetchMesas();
  Future<Map<String, dynamic>?> getMesaByQrToken(String qrToken);
  Future<List<Map<String, dynamic>>> fetchCategorias();
  Future<List<Map<String, dynamic>>> fetchItensCardapio();
}
