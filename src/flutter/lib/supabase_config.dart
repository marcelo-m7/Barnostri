import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'SUPABASE_URL';
  static const String anonKey = 'SUPABASE_ANON_KEY';
  
  static late final SupabaseClient _client;
  static bool _isConfigured = false;
  
  static SupabaseClient get client => _client;
  static bool get isConfigured => _isConfigured;
  
  static Future<void> initialize() async {
    // Check if using placeholder values
    if (supabaseUrl == 'SUPABASE_URL' || anonKey == 'SUPABASE_ANON_KEY') {
      _isConfigured = false;
      if (kDebugMode) {
        print('⚠️  Supabase credentials are placeholder values. Please configure with actual credentials.');
      }
      return;
    }
    
    try {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: anonKey,
      );
      _client = Supabase.instance.client;
      _isConfigured = true;
    } catch (e) {
      _isConfigured = false;
      if (kDebugMode) {
        print('❌ Failed to initialize Supabase: $e');
      }
    }
  }
  
  // Authentication helpers
  static Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    // Mock authentication for demo purposes when Supabase is not configured
    if (!_isConfigured) {
      if (kDebugMode) {
        print('🔒 Mock authentication: $email');
      }
      
      // Simulate demo login
      if (email == 'admin@barnostri.com' && password == 'admin123') {
        // Return a mock successful response
        await Future.delayed(const Duration(seconds: 1));
        return AuthResponse(
          user: User(
            id: 'demo-admin-id',
            appMetadata: {},
            userMetadata: {},
            aud: 'authenticated',
            createdAt: DateTime.now().toIso8601String(),
            email: email,
          ),
          session: Session(
            accessToken: 'demo-access-token',
            refreshToken: 'demo-refresh-token',
            expiresIn: 3600,
            tokenType: 'Bearer',
            user: User(
              id: 'demo-admin-id',
              appMetadata: {},
              userMetadata: {},
              aud: 'authenticated',
              createdAt: DateTime.now().toIso8601String(),
              email: email,
            ),
          ),
        );
      } else {
        throw AuthException('Invalid credentials');
      }
    }
    
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
    if (!_isConfigured) {
      if (kDebugMode) {
        print('🔓 Mock sign out');
      }
      return;
    }
    
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
    if (!_isConfigured) {
      return null;
    }
    return _client.auth.currentUser;
  }
  
  static Stream<AuthState> get authStateChanges {
    if (!_isConfigured) {
      // Return mock auth state stream for demo
      return Stream.value(AuthState(AuthChangeEvent.signedOut, null));
    }
    return _client.auth.onAuthStateChange;
  }
  
  // Database helpers
  static Future<List<Map<String, dynamic>>> getMesas() async {
    if (!_isConfigured) {
      // Return mock data for demo
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
      rethrow;
    }
  }
  
  static Future<Map<String, dynamic>?> getMesaByQrToken(String qrToken) async {
    if (!_isConfigured) {
      // Return mock data for demo
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
    if (!_isConfigured) {
      // Return mock data for demo
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
    if (!_isConfigured) {
      // Return mock data for demo
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
      final response = await _client
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
  
  static Future<String?> criarPedido({
    required String mesaId,
    required List<Map<String, dynamic>> itens,
    required double total,
    required String formaPagamento,
  }) async {
    if (!_isConfigured) {
      // Return mock order ID for demo
      if (kDebugMode) {
        print('📝 Mock order created: Mesa $mesaId, Total: R\$ $total');
      }
      return 'mock-order-${DateTime.now().millisecondsSinceEpoch}';
    }
    
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
      
      await _client
          .from('itens_pedido')
          .insert(itensData);
      
      return pedidoId;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao criar pedido: $e');
      }
      return null;
    }
  }
  
  static Future<bool> atualizarStatusPedido(String pedidoId, String novoStatus) async {
    if (!_isConfigured) {
      // Mock status update for demo
      if (kDebugMode) {
        print('📊 Mock status update: $pedidoId -> $novoStatus');
      }
      return true;
    }
    
    try {
      await _client
          .from('pedidos')
          .update({'status': novoStatus})
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
    if (!_isConfigured) {
      // Return mock orders for demo
      return [
        {
          'id': 'mock-order-1',
          'mesa_id': '1',
          'status': 'Em preparo',
          'total': 67.80,
          'forma_pagamento': 'Pix',
          'pago': false,
          'created_at': DateTime.now().subtract(const Duration(minutes: 10)).toIso8601String(),
          'updated_at': DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
          'mesas': {
            'id': '1',
            'numero': '1',
            'qr_token': 'mesa_001_qr',
            'ativo': true,
          },
          'itens_pedido': [
            {
              'id': 'item-1',
              'pedido_id': 'mock-order-1',
              'item_cardapio_id': '3',
              'quantidade': 1,
              'observacao': 'Menos pimenta',
              'preco_unitario': 45.90,
              'itens_cardapio': {
                'id': '3',
                'nome': 'Moqueca de Peixe',
                'descricao': 'Moqueca tradicional com peixe fresco e dendê',
                'preco': 45.90,
              }
            },
            {
              'id': 'item-2',
              'pedido_id': 'mock-order-1',
              'item_cardapio_id': '2',
              'quantidade': 2,
              'observacao': '',
              'preco_unitario': 12.00,
              'itens_cardapio': {
                'id': '2',
                'nome': 'Caipirinha',
                'descricao': 'Caipirinha tradicional com cachaça e limão',
                'preco': 12.00,
              }
            }
          ]
        }
      ];
    }
    
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
    if (!_isConfigured) {
      // Return mock stream for demo
      return Stream.periodic(const Duration(seconds: 5), (count) => [
        {
          'id': 'mock-order-1',
          'mesa_id': '1',
          'status': 'Em preparo',
          'total': 67.80,
          'forma_pagamento': 'Pix',
          'pago': false,
          'created_at': DateTime.now().subtract(const Duration(minutes: 10)).toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        }
      ]);
    }
    
    return _client
        .from('pedidos')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false);
  }
  
  static Stream<Map<String, dynamic>> streamPedido(String pedidoId) {
    if (!_isConfigured) {
      // Return mock stream for demo
      return Stream.periodic(const Duration(seconds: 5), (count) => {
        'id': pedidoId,
        'mesa_id': '1',
        'status': 'Em preparo',
        'total': 67.80,
        'forma_pagamento': 'Pix',
        'pago': false,
        'created_at': DateTime.now().subtract(const Duration(minutes: 10)).toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
    }
    
    return _client
        .from('pedidos')
        .stream(primaryKey: ['id'])
        .eq('id', pedidoId)
        .map((data) => data.first);
  }
}