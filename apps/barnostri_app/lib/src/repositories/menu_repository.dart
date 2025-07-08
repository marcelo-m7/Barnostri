abstract class MenuRepository {
  Future<List<Map<String, dynamic>>> getCategorias();
  Future<List<Map<String, dynamic>>> getItensCardapio();
  Future<List<Map<String, dynamic>>> getMesas();
  Future<Map<String, dynamic>?> getMesaByQrToken(String qrToken);
}
