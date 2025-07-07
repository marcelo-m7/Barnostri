import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'SUPABASE_URL';
  static const String anonKey = 'SUPABASE_ANON_KEY';
  
  static late final SupabaseClient _client;
  
  static SupabaseClient get client => _client;
  
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: anonKey,
    );
    _client = Supabase.instance.client;
  }
  
  // Authentication helpers
  static Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao fazer login: $e');
      }
      rethrow;
    }
  }
  
  static Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao fazer logout: $e');
      }
      rethrow;
    }
  }
  
  static User? getCurrentUser() {
    return _client.auth.currentUser;
  }
  
  static Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
  
  // Database helpers
  static Future<List<Map<String, dynamic>>> getMesas() async {
    try {
      final response = await _client
          .from('mesas')
          .select('*')
          .eq('ativo', true)
          .order('numero');
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar mesas: $e');
      }
      return [];
    }
  }
  
  static Future<Map<String, dynamic>?> getMesaByQrToken(String qrToken) async {
    try {
      final response = await _client
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
  
  static Future<List<Map<String, dynamic>>> getCategorias() async {
    try {
      final response = await _client
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
  
  static Future<List<Map<String, dynamic>>> getItensCardapio() async {
    try {
      final response = await _client
          .from('itens_cardapio')
          .select('*, categorias(*)')
          .eq('disponivel', true)
          .order('nome');
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar itens do cardápio: $e');
      }
      return [];
    }
  }
  
  static Future<String?> criarPedido({
    required String mesaId,
    required List<Map<String, dynamic>> itens,
    required double total,
    required String formaPagamento,
  }) async {
    try {
      // Criar pedido
      final pedidoResponse = await _client
          .from('pedidos')
          .insert({
            'mesa_id': mesaId,
            'status': 'Recebido',
            'total': total,
            'forma_pagamento': formaPagamento,
            'pago': false,
          })
          .select()
          .single();
      
      final pedidoId = pedidoResponse['id'];
      
      // Criar itens do pedido
      final itensData = itens.map((item) => {
        'pedido_id': pedidoId,
        'item_cardapio_id': item['id'],
        'quantidade': item['quantidade'],
        'observacao': item['observacao'] ?? '',
        'preco_unitario': item['preco'],
      }).toList();
      
      await _client.from('itens_pedido').insert(itensData);
      
      return pedidoId;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao criar pedido: $e');
      }
      return null;
    }
  }
  
  static Future<bool> atualizarStatusPedido(String pedidoId, String novoStatus) async {
    try {
      await _client
          .from('pedidos')
          .update({'status': novoStatus, 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', pedidoId);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao atualizar status do pedido: $e');
      }
      return false;
    }
  }
  
  static Future<List<Map<String, dynamic>>> getPedidos() async {
    try {
      final response = await _client
          .from('pedidos')
          .select('*, mesas(*), itens_pedido(*, itens_cardapio(*))')
          .order('created_at', ascending: false);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar pedidos: $e');
      }
      return [];
    }
  }
  
  static Stream<List<Map<String, dynamic>>> streamPedidos() {
    return _client
        .from('pedidos')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false);
  }
  
  static Stream<Map<String, dynamic>> streamPedido(String pedidoId) {
    return _client
        .from('pedidos')
        .stream(primaryKey: ['id'])
        .eq('id', pedidoId)
        .map((data) => data.first);
  }
}