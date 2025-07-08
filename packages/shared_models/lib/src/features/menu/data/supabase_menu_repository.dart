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
}
