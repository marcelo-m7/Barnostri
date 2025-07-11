import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_models/shared_models.dart';
import 'package:barnostri_app/src/core/logger.dart';

class SupabaseMenuRepository implements MenuRepository {
  final SupabaseClient? _client;

  SupabaseMenuRepository(this._client);
  @override
  Future<List<TableModel>> fetchTables() async {
    if (_client == null) {
      return [
        TableModel(
          id: '1',
          number: '1',
          qrToken: 'mesa_001_qr',
          active: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        TableModel(
          id: '2',
          number: '2',
          qrToken: 'mesa_002_qr',
          active: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
    }
    try {
      final response = await _client!
          .from('tables')
          .select('*')
          .eq('active', true)
          .order('number');
      return response.map<TableModel>((e) => TableModel.fromJson(e)).toList();
    } catch (e) {
      logger.severe('Erro ao buscar mesas: $e');
      rethrow;
    }
  }

  @override
  Future<TableModel?> getTableByQrToken(String qrToken) async {
    if (_client == null) {
      if (qrToken == 'mesa_001_qr') {
        return TableModel(
          id: '1',
          number: '1',
          qrToken: 'mesa_001_qr',
          active: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      } else if (qrToken == 'mesa_002_qr') {
        return TableModel(
          id: '2',
          number: '2',
          qrToken: 'mesa_002_qr',
          active: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
      return null;
    }
    try {
      final response = await _client!
          .from('tables')
          .select('*')
          .eq('qr_token', qrToken)
          .eq('active', true)
          .single();
      return TableModel.fromJson(response);
    } catch (e) {
      logger.severe('Erro ao buscar mesa por QR: $e');
      return null;
    }
  }

  @override
  Future<List<CategoryModel>> fetchCategories() async {
    if (_client == null) {
      return [
        CategoryModel(
          id: '1',
          name: 'Entradas',
          sortOrder: 1,
          active: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        CategoryModel(
          id: '2',
          name: 'Bebidas',
          sortOrder: 2,
          active: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        CategoryModel(
          id: '3',
          name: 'Pratos Principais',
          sortOrder: 3,
          active: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        CategoryModel(
          id: '4',
          name: 'Sobremesas',
          sortOrder: 4,
          active: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
    }
    try {
      final response = await _client!
          .from('categories')
          .select('*')
          .eq('active', true)
          .order('sort_order');
      return response
          .map<CategoryModel>((e) => CategoryModel.fromJson(e))
          .toList();
    } catch (e) {
      logger.severe('Erro ao buscar categorias: $e');
      return [];
    }
  }

  @override
  Future<List<MenuItem>> fetchMenuItems() async {
    if (_client == null) {
      return [
        MenuItem(
          id: '1',
          name: 'Pastéis de Camarão',
          description: 'Deliciosos pastéis recheados com camarão fresco',
          price: 18.90,
          categoryId: '1',
          available: true,
          imageUrl: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        MenuItem(
          id: '2',
          name: 'Caipirinha',
          description: 'Caipirinha tradicional com cachaça e limão',
          price: 12.00,
          categoryId: '2',
          available: true,
          imageUrl: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        MenuItem(
          id: '3',
          name: 'Moqueca de Peixe',
          description: 'Moqueca tradicional com peixe fresco e dendê',
          price: 45.90,
          categoryId: '3',
          available: true,
          imageUrl: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        MenuItem(
          id: '4',
          name: 'Pudim de Leite',
          description: 'Pudim caseiro com calda de caramelo',
          price: 12.90,
          categoryId: '4',
          available: true,
          imageUrl: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
    }
    try {
      final response = await _client!
          .from('menu_items')
          .select()
          .eq('available', true)
          .order('name');
      return response.map<MenuItem>((e) => MenuItem.fromJson(e)).toList();
    } catch (e) {
      logger.severe('Erro ao buscar itens do cardápio: $e');
      rethrow;
    }
  }

  @override
  Future<CategoryModel> addCategory({
    required String name,
    required int sortOrder,
  }) async {
    if (_client == null) {
      return CategoryModel(
        id: 'mock-cat-${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        sortOrder: sortOrder,
        active: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
    final response = await _client!
        .from('categories')
        .insert({'name': name, 'sort_order': sortOrder, 'active': true})
        .select()
        .single();
    return CategoryModel.fromJson(response);
  }

  @override
  Future<bool> updateCategory({
    required String id,
    String? name,
    int? sortOrder,
    bool? active,
  }) async {
    if (_client == null) {
      if (kDebugMode) {
        logger.info('📝 Mock update categoria $id');
      }
      return true;
    }
    final updateData = <String, dynamic>{};
    if (name != null) updateData['name'] = name;
    if (sortOrder != null) updateData['sort_order'] = sortOrder;
    if (active != null) updateData['active'] = active;
    await _client!.from('categories').update(updateData).eq('id', id);
    return true;
  }

  @override
  Future<bool> deleteCategory(String id) async {
    if (_client == null) {
      if (kDebugMode) {
        logger.info('🗑️ Mock delete categoria $id');
      }
      return true;
    }
    await _client!.from('categories').delete().eq('id', id);
    return true;
  }

  @override
  Future<MenuItem> addMenuItem({
    required String name,
    String? description,
    required double price,
    required String categoryId,
    String? imageUrl,
  }) async {
    if (_client == null) {
      return MenuItem(
        id: 'mock-item-${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        description: description,
        price: price,
        categoryId: categoryId,
        available: true,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
    final response = await _client!
        .from('menu_items')
        .insert({
          'name': name,
          'description': description,
          'price': price,
          'category_id': categoryId,
          'available': true,
          'image_url': imageUrl,
        })
        .select('*, categories(*)')
        .single();
    return MenuItem.fromJson(response);
  }

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
    if (_client == null) {
      if (kDebugMode) {
        logger.info('📝 Mock update item $id');
      }
      return true;
    }
    final updateData = <String, dynamic>{};
    if (name != null) updateData['name'] = name;
    if (description != null) updateData['description'] = description;
    if (price != null) updateData['price'] = price;
    if (categoryId != null) updateData['category_id'] = categoryId;
    if (available != null) updateData['available'] = available;
    if (imageUrl != null) updateData['image_url'] = imageUrl;
    await _client!.from('menu_items').update(updateData).eq('id', id);
    return true;
  }

  @override
  Future<bool> deleteMenuItem(String id) async {
    if (_client == null) {
      if (kDebugMode) {
        logger.info('🗑️ Mock delete item $id');
      }
      return true;
    }
    await _client!.from('menu_items').delete().eq('id', id);
    return true;
  }

  @override
  Future<TableModel> addTable({
    required String number,
    required String qrToken,
  }) async {
    if (_client == null) {
      return TableModel(
        id: 'mock-table-${DateTime.now().millisecondsSinceEpoch}',
        number: number,
        qrToken: qrToken,
        active: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
    final response = await _client!
        .from('tables')
        .insert({'number': number, 'qr_token': qrToken, 'active': true})
        .select()
        .single();
    return TableModel.fromJson(response);
  }

  @override
  Future<bool> updateTable({
    required String id,
    String? number,
    String? qrToken,
    bool? active,
  }) async {
    if (_client == null) {
      if (kDebugMode) {
        logger.info('📝 Mock update mesa $id');
      }
      return true;
    }
    final updateData = <String, dynamic>{};
    if (number != null) updateData['number'] = number;
    if (qrToken != null) updateData['qr_token'] = qrToken;
    if (active != null) updateData['active'] = active;
    await _client!.from('tables').update(updateData).eq('id', id);
    return true;
  }

  @override
  Future<bool> deleteTable(String id) async {
    if (_client == null) {
      if (kDebugMode) {
        logger.info('🗑️ Mock delete mesa $id');
      }
      return true;
    }
    await _client!.from('tables').delete().eq('id', id);
    return true;
  }
}
