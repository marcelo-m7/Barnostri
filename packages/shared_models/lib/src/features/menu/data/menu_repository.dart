import '../../models/category.dart';
import '../../models/menu_item.dart';
import '../../models/table.dart';

/// Data access layer for menu related entities.
abstract class MenuRepository {
  Future<List<Mesa>> fetchMesas();
  Future<Mesa?> getMesaByQrToken(String qrToken);
  Future<List<Categoria>> fetchCategorias();
  Future<List<ItemCardapio>> fetchItensCardapio();

  Future<Categoria> addCategoria({required String nome, required int ordem});

  Future<bool> updateCategoria({
    required String id,
    String? nome,
    int? ordem,
    bool? ativo,
  });

  Future<bool> deleteCategoria(String id);

  Future<ItemCardapio> addItemCardapio({
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

  Future<Mesa> addMesa({required String numero, required String qrToken});

  Future<bool> updateMesa({
    required String id,
    String? numero,
    String? qrToken,
    bool? ativo,
  });

  Future<bool> deleteMesa(String id);
}
