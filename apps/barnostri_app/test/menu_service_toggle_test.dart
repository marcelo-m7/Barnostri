import 'package:flutter_test/flutter_test.dart';
import 'package:barnostri_app/src/features/menu/presentation/controllers/menu_service.dart';
import 'package:shared_models/shared_models.dart';

class FakeMenuRepository implements MenuRepository {
  List<MenuItem> _items;
  FakeMenuRepository(this._items);

  @override
  Future<List<MenuItem>> fetchMenuItems() async => _items;

  @override
  Future<bool> updateMenuItem({
    required String id,
    String? name,
    String? description,
    double? price,
    String? categoryId,
    bool? available,
    String? imageUrl,
  }) async {
    final index = _items.indexWhere((e) => e.id == id);
    if (index == -1) return false;
    final item = _items[index];
    _items[index] = MenuItem(
      id: item.id,
      name: name ?? item.name,
      description: description ?? item.description,
      price: price ?? item.price,
      categoryId: categoryId ?? item.categoryId,
      available: available ?? item.available,
      imageUrl: imageUrl ?? item.imageUrl,
      createdAt: item.createdAt,
      updatedAt: DateTime.now(),
    );
    return true;
  }

  // Unused methods throw to highlight if they are unexpectedly called.
  @override
  Future<List<TableModel>> fetchTables() async => [];

  @override
  Future<TableModel?> getTableByQrToken(String qrToken) async => null;

  @override
  Future<List<CategoryModel>> fetchCategories() async => [];

  @override
  Future<CategoryModel> addCategory({
    required String name,
    required int sortOrder,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<bool> updateCategory({
    required String id,
    String? name,
    int? sortOrder,
    bool? active,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteCategory(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<MenuItem> addMenuItem({
    required String name,
    String? description,
    required double price,
    required String categoryId,
    String? imageUrl,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteMenuItem(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<TableModel> addTable({
    required String number,
    required String qrToken,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<bool> updateTable({
    required String id,
    String? number,
    String? qrToken,
    bool? active,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteTable(String id) async {
    throw UnimplementedError();
  }
}

void main() {
  group('MenuService.toggleItemAvailability', () {
    late MenuService service;
    late FakeMenuRepository repo;

    setUp(() {
      final items = [
        MenuItem(
          id: '1',
          name: 'Item 1',
          description: null,
          price: 5.0,
          categoryId: 'c1',
          available: true,
          imageUrl: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
      repo = FakeMenuRepository(items);
      final loadUseCase = LoadMenuUseCase(repo);
      service = MenuService(repo, loadUseCase);
      service.state = service.state.copyWith(menuItems: items);
    });

    test('updates item availability and refreshes state', () async {
      expect(service.getItemById('1')!.available, isTrue);

      final ok = await service.toggleItemAvailability('1');

      expect(ok, isTrue);
      final item = service.getItemById('1');
      expect(item!.available, isFalse);
    });
  });
}
