import '../../models/category.dart';
import '../../models/menu_item.dart';
import '../../models/table_model.dart';

/// Data access layer for menu related entities.
abstract class MenuRepository {
  Future<List<TableModel>> fetchTables();
  Future<TableModel?> getTableByQrToken(String qrToken);
  Future<List<Category>> fetchCategories();
  Future<List<MenuItem>> fetchMenuItems();

  Future<Category> addCategory({required String name, required int sortOrder});

  Future<bool> updateCategory({
    required String id,
    String? name,
    int? sortOrder,
    bool? active,
  });

  Future<bool> deleteCategory(String id);

  Future<MenuItem> addMenuItem({
    required String name,
    String? description,
    required double price,
    required String categoryId,
    String? imageUrl,
  });

  Future<bool> updateMenuItem({
    required String id,
    String? name,
    String? description,
    double? price,
    String? categoryId,
    bool? available,
    String? imageUrl,
  });

  Future<bool> deleteMenuItem(String id);

  Future<TableModel> addTable({required String number, required String qrToken});

  Future<bool> updateTable({
    required String id,
    String? number,
    String? qrToken,
    bool? active,
  });

  Future<bool> deleteTable(String id);
}
