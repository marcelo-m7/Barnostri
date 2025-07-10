import 'package:shared_models/shared_models.dart';

/// Result containing menu related entities loaded from repository.
class LoadMenuResult {
  final List<CategoryModel> categories;
  final List<MenuItem> items;
  final List<TableModel> tables;

  const LoadMenuResult({
    required this.categories,
    required this.items,
    required this.tables,
  });
}

/// Loads menu categories, items and tables.
class LoadMenuUseCase {
  final MenuRepository _repository;

  LoadMenuUseCase(this._repository);

  Future<LoadMenuResult> call() async {
    final cats = await _repository.fetchCategories();
    final items = await _repository.fetchMenuItems();
    final tables = await _repository.fetchTables();
    return LoadMenuResult(categories: cats, items: items, tables: tables);
  }
}
