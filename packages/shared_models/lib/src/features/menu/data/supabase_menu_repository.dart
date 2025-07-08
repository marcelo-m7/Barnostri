import 'package:flutter/foundation.dart';
import '../../models/category.dart';
import '../../models/menu_item.dart';
import '../../models/table.dart';
import '../../../services/supabase_config.dart';
import 'menu_repository.dart';

class SupabaseMenuRepository implements MenuRepository {
  @override
  Future<List<Mesa>> fetchMesas() async {
    if (!SupabaseConfig.isConfigured) {
      return [
        Mesa(
          id: '1',
          numero: '1',
          qrToken: 'mesa_001_qr',
          ativo: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Mesa(
          id: '2',
          numero: '2',
          qrToken: 'mesa_002_qr',
          ativo: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
    }
    try {
      final response = await SupabaseConfig.client
          .from('mesas')
          .select('*')
          .eq('ativo', true)
          .order('numero');
      return (response as List<dynamic>)
          .map((e) => Mesa.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar mesas: $e');
      }
      rethrow;
    }
  }

  @override
  Future<Mesa?> getMesaByQrToken(String qrToken) async {
    if (!SupabaseConfig.isConfigured) {
      if (qrToken == 'mesa_001_qr') {
        return Mesa(
          id: '1',
          numero: '1',
          qrToken: 'mesa_001_qr',
          ativo: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      } else if (qrToken == 'mesa_002_qr') {
        return Mesa(
          id: '2',
          numero: '2',
          qrToken: 'mesa_002_qr',
          ativo: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
      return null;
    }
    try {
      final response = await SupabaseConfig.client
          .from('mesas')
          .select('*')
          .eq('qr_token', qrToken)
          .eq('ativo', true)
          .single();
      return Mesa.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar mesa por QR: $e');
      }
      return null;
    }
  }

  @override
  Future<List<Categoria>> fetchCategorias() async {
    if (!SupabaseConfig.isConfigured) {
      return [
        Categoria(
          id: '1',
          nome: 'Entradas',
          ordem: 1,
          ativo: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Categoria(
          id: '2',
          nome: 'Bebidas',
          ordem: 2,
          ativo: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Categoria(
          id: '3',
          nome: 'Pratos Principais',
          ordem: 3,
          ativo: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Categoria(
          id: '4',
          nome: 'Sobremesas',
          ordem: 4,
          ativo: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
    }
    try {
      final response = await SupabaseConfig.client
          .from('categorias')
          .select('*')
          .eq('ativo', true)
          .order('ordem');
      return (response as List<dynamic>)
          .map((e) => Categoria.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar categorias: $e');
      }
      return [];
    }
  }

  @override
  Future<List<ItemCardapio>> fetchItensCardapio() async {
    if (!SupabaseConfig.isConfigured) {
      return [
        ItemCardapio(
          id: '1',
          nome: 'Pastéis de Camarão',
          descricao: 'Deliciosos pastéis recheados com camarão fresco',
          preco: 18.90,
          categoriaId: '1',
          disponivel: true,
          imagemUrl: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ItemCardapio(
          id: '2',
          nome: 'Caipirinha',
          descricao: 'Caipirinha tradicional com cachaça e limão',
          preco: 12.00,
          categoriaId: '2',
          disponivel: true,
          imagemUrl: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ItemCardapio(
          id: '3',
          nome: 'Moqueca de Peixe',
          descricao: 'Moqueca tradicional com peixe fresco e dendê',
          preco: 45.90,
          categoriaId: '3',
          disponivel: true,
          imagemUrl: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ItemCardapio(
          id: '4',
          nome: 'Pudim de Leite',
          descricao: 'Pudim caseiro com calda de caramelo',
          preco: 12.90,
          categoriaId: '4',
          disponivel: true,
          imagemUrl: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
    }
    try {
      final response = await SupabaseConfig.client
          .from('itens_cardapio')
          .select()
          .eq('disponivel', true)
          .order('nome');
      return (response as List<dynamic>)
          .map((e) => ItemCardapio.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar itens do cardápio: $e');
      }
      rethrow;
    }
  }

  @override
  Future<Categoria> addCategoria({
    required String nome,
    required int ordem,
  }) async {
    if (!SupabaseConfig.isConfigured) {
      return Categoria(
        id: 'mock-cat-${DateTime.now().millisecondsSinceEpoch}',
        nome: nome,
        ordem: ordem,
        ativo: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
    final response = await SupabaseConfig.client
        .from('categorias')
        .insert({'nome': nome, 'ordem': ordem, 'ativo': true})
        .select()
        .single();
    return Categoria.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<bool> updateCategoria({
    required String id,
    String? nome,
    int? ordem,
    bool? ativo,
  }) async {
    if (!SupabaseConfig.isConfigured) {
      if (kDebugMode) {
        print('📝 Mock update categoria $id');
      }
      return true;
    }
    final updateData = <String, dynamic>{};
    if (nome != null) updateData['nome'] = nome;
    if (ordem != null) updateData['ordem'] = ordem;
    if (ativo != null) updateData['ativo'] = ativo;
    await SupabaseConfig.client
        .from('categorias')
        .update(updateData)
        .eq('id', id);
    return true;
  }

  @override
  Future<bool> deleteCategoria(String id) async {
    if (!SupabaseConfig.isConfigured) {
      if (kDebugMode) {
        print('🗑️ Mock delete categoria $id');
      }
      return true;
    }
    await SupabaseConfig.client.from('categorias').delete().eq('id', id);
    return true;
  }

  @override
  Future<ItemCardapio> addItemCardapio({
    required String nome,
    String? descricao,
    required double preco,
    required String categoriaId,
    String? imagemUrl,
  }) async {
    if (!SupabaseConfig.isConfigured) {
      return ItemCardapio(
        id: 'mock-item-${DateTime.now().millisecondsSinceEpoch}',
        nome: nome,
        descricao: descricao,
        preco: preco,
        categoriaId: categoriaId,
        disponivel: true,
        imagemUrl: imagemUrl,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
    final response = await SupabaseConfig.client
        .from('itens_cardapio')
        .insert({
          'nome': nome,
          'descricao': descricao,
          'preco': preco,
          'categoria_id': categoriaId,
          'disponivel': true,
          'imagem_url': imagemUrl,
        })
        .select('*, categorias(*)')
        .single();
    return ItemCardapio.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<bool> updateItemCardapio({
    required String id,
    String? nome,
    String? descricao,
    double? preco,
    String? categoriaId,
    bool? disponivel,
    String? imagemUrl,
  }) async {
    if (!SupabaseConfig.isConfigured) {
      if (kDebugMode) {
        print('📝 Mock update item $id');
      }
      return true;
    }
    final updateData = <String, dynamic>{};
    if (nome != null) updateData['nome'] = nome;
    if (descricao != null) updateData['descricao'] = descricao;
    if (preco != null) updateData['preco'] = preco;
    if (categoriaId != null) updateData['categoria_id'] = categoriaId;
    if (disponivel != null) updateData['disponivel'] = disponivel;
    if (imagemUrl != null) updateData['imagem_url'] = imagemUrl;
    await SupabaseConfig.client
        .from('itens_cardapio')
        .update(updateData)
        .eq('id', id);
    return true;
  }

  @override
  Future<bool> deleteItemCardapio(String id) async {
    if (!SupabaseConfig.isConfigured) {
      if (kDebugMode) {
        print('🗑️ Mock delete item $id');
      }
      return true;
    }
    await SupabaseConfig.client.from('itens_cardapio').delete().eq('id', id);
    return true;
  }

  @override
  Future<Mesa> addMesa({
    required String numero,
    required String qrToken,
  }) async {
    if (!SupabaseConfig.isConfigured) {
      return Mesa(
        id: 'mock-table-${DateTime.now().millisecondsSinceEpoch}',
        numero: numero,
        qrToken: qrToken,
        ativo: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
    final response = await SupabaseConfig.client
        .from('mesas')
        .insert({'numero': numero, 'qr_token': qrToken, 'ativo': true})
        .select()
        .single();
    return Mesa.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<bool> updateMesa({
    required String id,
    String? numero,
    String? qrToken,
    bool? ativo,
  }) async {
    if (!SupabaseConfig.isConfigured) {
      if (kDebugMode) {
        print('📝 Mock update mesa $id');
      }
      return true;
    }
    final updateData = <String, dynamic>{};
    if (numero != null) updateData['numero'] = numero;
    if (qrToken != null) updateData['qr_token'] = qrToken;
    if (ativo != null) updateData['ativo'] = ativo;
    await SupabaseConfig.client.from('mesas').update(updateData).eq('id', id);
    return true;
  }

  @override
  Future<bool> deleteMesa(String id) async {
    if (!SupabaseConfig.isConfigured) {
      if (kDebugMode) {
        print('🗑️ Mock delete mesa $id');
      }
      return true;
    }
    await SupabaseConfig.client.from('mesas').delete().eq('id', id);
    return true;
  }
}
