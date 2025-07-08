import 'package:flutter/foundation.dart';
import '../../../services/supabase_config.dart';
import 'menu_repository.dart';

class SupabaseMenuRepository implements MenuRepository {
  @override
  Future<List<Map<String, dynamic>>> fetchMesas() async {
    if (!SupabaseConfig.isConfigured) {
      return [
        {
          'id': '1',
          'numero': '1',
          'qr_token': 'mesa_001_qr',
          'ativo': true,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        {
          'id': '2',
          'numero': '2',
          'qr_token': 'mesa_002_qr',
          'ativo': true,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
      ];
    }
    try {
      final response = await SupabaseConfig.client
          .from('mesas')
          .select('*')
          .eq('ativo', true)
          .order('numero');
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar mesas: $e');
      }
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>?> getMesaByQrToken(String qrToken) async {
    if (!SupabaseConfig.isConfigured) {
      if (qrToken == 'mesa_001_qr') {
        return {
          'id': '1',
          'numero': '1',
          'qr_token': 'mesa_001_qr',
          'ativo': true,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };
      } else if (qrToken == 'mesa_002_qr') {
        return {
          'id': '2',
          'numero': '2',
          'qr_token': 'mesa_002_qr',
          'ativo': true,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };
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
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar mesa por QR: $e');
      }
      return null;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchCategorias() async {
    if (!SupabaseConfig.isConfigured) {
      return [
        {
          'id': '1',
          'nome': 'Entradas',
          'ordem': 1,
          'ativo': true,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        {
          'id': '2',
          'nome': 'Bebidas',
          'ordem': 2,
          'ativo': true,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        {
          'id': '3',
          'nome': 'Pratos Principais',
          'ordem': 3,
          'ativo': true,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        {
          'id': '4',
          'nome': 'Sobremesas',
          'ordem': 4,
          'ativo': true,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
      ];
    }
    try {
      final response = await SupabaseConfig.client
          .from('categorias')
          .select('*')
          .eq('ativo', true)
          .order('ordem');
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar categorias: $e');
      }
      return [];
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchItensCardapio() async {
    if (!SupabaseConfig.isConfigured) {
      return [
        {
          'id': '1',
          'nome': 'Pastéis de Camarão',
          'descricao': 'Deliciosos pastéis recheados com camarão fresco',
          'preco': 18.90,
          'categoria_id': '1',
          'disponivel': true,
          'imagem_url': null,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        {
          'id': '2',
          'nome': 'Caipirinha',
          'descricao': 'Caipirinha tradicional com cachaça e limão',
          'preco': 12.00,
          'categoria_id': '2',
          'disponivel': true,
          'imagem_url': null,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        {
          'id': '3',
          'nome': 'Moqueca de Peixe',
          'descricao': 'Moqueca tradicional com peixe fresco e dendê',
          'preco': 45.90,
          'categoria_id': '3',
          'disponivel': true,
          'imagem_url': null,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        {
          'id': '4',
          'nome': 'Pudim de Leite',
          'descricao': 'Pudim caseiro com calda de caramelo',
          'preco': 12.90,
          'categoria_id': '4',
          'disponivel': true,
          'imagem_url': null,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
      ];
    }
    try {
      final response = await SupabaseConfig.client
          .from('itens_cardapio')
          .select()
          .eq('disponivel', true)
          .order('nome');
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar itens do cardápio: $e');
      }
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> addCategoria({
    required String nome,
    required int ordem,
  }) async {
    if (!SupabaseConfig.isConfigured) {
      return {
        'id': 'mock-cat-${DateTime.now().millisecondsSinceEpoch}',
        'nome': nome,
        'ordem': ordem,
        'ativo': true,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };
    }
    final response = await SupabaseConfig.client
        .from('categorias')
        .insert({'nome': nome, 'ordem': ordem, 'ativo': true})
        .select()
        .single();
    return response;
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
  Future<Map<String, dynamic>> addItemCardapio({
    required String nome,
    String? descricao,
    required double preco,
    required String categoriaId,
    String? imagemUrl,
  }) async {
    if (!SupabaseConfig.isConfigured) {
      return {
        'id': 'mock-item-${DateTime.now().millisecondsSinceEpoch}',
        'nome': nome,
        'descricao': descricao,
        'preco': preco,
        'categoria_id': categoriaId,
        'disponivel': true,
        'imagem_url': imagemUrl,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };
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
    return response;
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
  Future<Map<String, dynamic>> addMesa({
    required String numero,
    required String qrToken,
  }) async {
    if (!SupabaseConfig.isConfigured) {
      return {
        'id': 'mock-table-${DateTime.now().millisecondsSinceEpoch}',
        'numero': numero,
        'qr_token': qrToken,
        'ativo': true,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };
    }
    final response = await SupabaseConfig.client
        .from('mesas')
        .insert({'numero': numero, 'qr_token': qrToken, 'ativo': true})
        .select()
        .single();
    return response;
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
