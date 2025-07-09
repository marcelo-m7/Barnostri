import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_models/shared_models.dart';
import 'package:barnostri_app/src/core/repositories.dart';

class MenuState {
  final List<CategoryModel> categories;
  final List<MenuItem> menuItems;
  final List<TableModel> tables;
  final bool isLoading;
  final String? error;

  const MenuState({
    this.categories = const [],
    this.menuItems = const [],
    this.tables = const [],
    this.isLoading = false,
    this.error,
  });

  MenuState copyWith({
    List<CategoryModel>? categories,
    List<MenuItem>? menuItems,
    List<TableModel>? tables,
    bool? isLoading,
    String? error,
  }) {
    return MenuState(
      categories: categories ?? this.categories,
      menuItems: menuItems ?? this.menuItems,
      tables: tables ?? this.tables,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class MenuService extends StateNotifier<MenuState> {
  final MenuRepository _menuRepository;
  final LoadMenuUseCase _loadMenuUseCase;
  MenuService(this._menuRepository, this._loadMenuUseCase)
    : super(const MenuState());

  List<CategoryModel> get categories => state.categories;

  Future<T?> _guard<T>(
    Future<T> Function() action, {
    String Function(Object)? onError,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      return await action();
    } catch (e) {
      state = state.copyWith(
        error: onError != null ? onError(e) : e.toString(),
      );
      return null;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loadCategories() async {
    await _guard<void>(() async {
      final categories = await _menuRepository.fetchCategories();
      state = state.copyWith(categories: categories);
    }, onError: (e) => 'Erro ao carregar categorias: $e');
  }

  Future<void> loadMenuItems() async {
    await _guard<void>(() async {
      final items = await _menuRepository.fetchMenuItems();
      state = state.copyWith(menuItems: items);
    }, onError: (e) => 'Erro ao carregar itens do cardápio: $e');
  }

  Future<void> loadTables() async {
    await _guard<void>(() async {
      final tables = await _menuRepository.fetchTables();
      state = state.copyWith(tables: tables);
    }, onError: (e) => 'Erro ao carregar mesas: $e');
  }

  Future<void> loadAll() async {
    await _guard<void>(() async {
      final result = await _loadMenuUseCase();
      state = state.copyWith(
        categories: result.categories,
        menuItems: result.items,
        tables: result.tables,
      );
    }, onError: (e) => 'Erro ao carregar dados: $e');
  }

  List<MenuItem> getItemsByCategory(String categoryId) {
    return state.menuItems
        .where((item) => item.categoryId == categoryId)
        .toList();
  }

  List<MenuItem> searchItems(String query) {
    if (query.isEmpty) return state.menuItems;
    final lowerQuery = query.toLowerCase();
    return state.menuItems.where((item) {
      return item.name.toLowerCase().contains(lowerQuery) ||
          (item.description?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  CategoryModel? getCategoryById(String id) {
    try {
      return state.categories.firstWhere((cat) => cat.id == id);
    } catch (_) {
      return null;
    }
  }

  MenuItem? getItemById(String id) {
    try {
      return state.menuItems.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  TableModel? getTableById(String id) {
    try {
      return state.tables.firstWhere((table) => table.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<bool> addCategory({
    required String name,
    required int sortOrder,
  }) async {
    final result = await _guard<bool>(() async {
      final newCat = await _menuRepository.addCategory(
        name: name,
        sortOrder: sortOrder,
      );
      final list = [...state.categories, newCat]
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      state = state.copyWith(categories: list);
      return true;
    }, onError: (e) => 'Erro ao adicionar categoria: $e');
    return result ?? false;
  }

  Future<bool> updateCategory({
    required String id,
    String? name,
    int? sortOrder,
    bool? active,
  }) async {
    final ok = await _guard<bool>(() async {
      final result = await _menuRepository.updateCategory(
        id: id,
        name: name,
        sortOrder: sortOrder,
        active: active,
      );
      if (result) {
        await loadCategories();
      }
      return result;
    }, onError: (e) => 'Erro ao atualizar categoria: $e');
    return ok ?? false;
  }

  Future<bool> addMenuItem({
    required String name,
    String? description,
    required double price,
    required String categoryId,
    String? imageUrl,
  }) async {
    final result = await _guard<bool>(() async {
      final newItem = await _menuRepository.addMenuItem(
        name: name,
        description: description,
        price: price,
        categoryId: categoryId,
        imageUrl: imageUrl,
      );
      final list = [...state.menuItems, newItem]
        ..sort((a, b) => a.name.compareTo(b.name));
      state = state.copyWith(menuItems: list);
      return true;
    }, onError: (e) => 'Erro ao adicionar item: $e');
    return result ?? false;
  }

  Future<bool> updateMenuItem({
    required String id,
    String? name,
    String? description,
    double? price,
    String? categoryId,
    bool? available,
    String? imageUrl,
  }) async {
    final ok = await _guard<bool>(() async {
      final result = await _menuRepository.updateMenuItem(
        id: id,
        name: name,
        description: description,
        price: price,
        categoryId: categoryId,
        available: available,
        imageUrl: imageUrl,
      );
      if (result) {
        await loadMenuItems();
      }
      return result;
    }, onError: (e) => 'Erro ao atualizar item: $e');
    return ok ?? false;
  }

  Future<bool> toggleItemAvailability(String id) async {
    final item = getItemById(id);
    if (item == null) return false;
    return await updateMenuItem(id: id, available: !item.available);
  }

  Future<bool> deleteMenuItem(String id) async {
    final ok = await _guard<bool>(() async {
      final success = await _menuRepository.deleteMenuItem(id);
      if (success) {
        final list = [...state.menuItems]..removeWhere((item) => item.id == id);
        state = state.copyWith(menuItems: list);
      }
      return success;
    }, onError: (e) => 'Erro ao deletar item: $e');
    return ok ?? false;
  }

  Future<bool> addTable({
    required String number,
    required String qrToken,
  }) async {
    final result = await _guard<bool>(() async {
      final newTable = await _menuRepository.addTable(
        number: number,
        qrToken: qrToken,
      );
      final list = [...state.tables, newTable]
        ..sort((a, b) => a.number.compareTo(b.number));
      state = state.copyWith(tables: list);
      return true;
    }, onError: (e) => 'Erro ao adicionar mesa: $e');
    return result ?? false;
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final menuServiceProvider = StateNotifierProvider<MenuService, MenuState>((
  ref,
) {
  final menuRepo = ref.watch(menuRepositoryProvider);
  final loadMenu = LoadMenuUseCase(menuRepo);
  return MenuService(menuRepo, loadMenu);
});
