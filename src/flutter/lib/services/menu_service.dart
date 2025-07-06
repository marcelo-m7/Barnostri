import 'package:flutter/foundation.dart';
import '../models/app_models.dart';
import '../supabase/supabase_config.dart';

class MenuService extends ChangeNotifier {
  static final MenuService _instance = MenuService._internal();
  factory MenuService() => _instance;
  MenuService._internal();

  List<Categoria> _categorias = [];
  List<ItemCardapio> _itensCardapio = [];
  List<Mesa> _mesas = [];
  bool _isLoading = false;
  String? _error;

  List<Categoria> get categorias => _categorias;
  List<ItemCardapio> get itensCardapio => _itensCardapio;
  List<Mesa> get mesas => _mesas;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCategorias() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await SupabaseConfig.getCategorias();
      _categorias = data.map((json) => Categoria.fromJson(json)).toList();
    } catch (e) {
      _error = 'Erro ao carregar categorias: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadItensCardapio() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await SupabaseConfig.getItensCardapio();
      _itensCardapio = data.map((json) => ItemCardapio.fromJson(json)).toList();
    } catch (e) {
      _error = 'Erro ao carregar itens do cardápio: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMesas() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await SupabaseConfig.getMesas();
      _mesas = data.map((json) => Mesa.fromJson(json)).toList();
    } catch (e) {
      _error = 'Erro ao carregar mesas: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadAll() async {
    await Future.wait([
      loadCategorias(),
      loadItensCardapio(),
      loadMesas(),
    ]);
  }

  List<ItemCardapio> getItensByCategoria(String categoriaId) {
    return _itensCardapio.where((item) => item.categoriaId == categoriaId).toList();
  }

  List<ItemCardapio> searchItens(String query) {
    if (query.isEmpty) return _itensCardapio;
    
    final lowerQuery = query.toLowerCase();
    return _itensCardapio.where((item) =>
      item.nome.toLowerCase().contains(lowerQuery) ||
      (item.descricao?.toLowerCase().contains(lowerQuery) ?? false)
    ).toList();
  }

  Categoria? getCategoriaById(String id) {
    try {
      return _categorias.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  ItemCardapio? getItemById(String id) {
    try {
      return _itensCardapio.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  Mesa? getMesaById(String id) {
    try {
      return _mesas.firstWhere((mesa) => mesa.id == id);
    } catch (e) {
      return null;
    }
  }

  // Admin functions for managing menu items
  Future<bool> addCategoria({
    required String nome,
    required int ordem,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await SupabaseConfig.client
          .from('categorias')
          .insert({
            'nome': nome,
            'ordem': ordem,
            'ativo': true,
          })
          .select()
          .single();

      final novaCategoria = Categoria.fromJson(response);
      _categorias.add(novaCategoria);
      _categorias.sort((a, b) => a.ordem.compareTo(b.ordem));
      
      return true;
    } catch (e) {
      _error = 'Erro ao adicionar categoria: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateCategoria({
    required String id,
    String? nome,
    int? ordem,
    bool? ativo,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updateData = <String, dynamic>{};
      if (nome != null) updateData['nome'] = nome;
      if (ordem != null) updateData['ordem'] = ordem;
      if (ativo != null) updateData['ativo'] = ativo;

      await SupabaseConfig.client
          .from('categorias')
          .update(updateData)
          .eq('id', id);

      // Refresh categorias
      await loadCategorias();
      return true;
    } catch (e) {
      _error = 'Erro ao atualizar categoria: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addItemCardapio({
    required String nome,
    String? descricao,
    required double preco,
    required String categoriaId,
    String? imagemUrl,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
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

      final novoItem = ItemCardapio.fromJson(response);
      _itensCardapio.add(novoItem);
      _itensCardapio.sort((a, b) => a.nome.compareTo(b.nome));
      
      return true;
    } catch (e) {
      _error = 'Erro ao adicionar item: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateItemCardapio({
    required String id,
    String? nome,
    String? descricao,
    double? preco,
    String? categoriaId,
    bool? disponivel,
    String? imagemUrl,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
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

      // Refresh itens
      await loadItensCardapio();
      return true;
    } catch (e) {
      _error = 'Erro ao atualizar item: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> toggleItemDisponibilidade(String id) async {
    final item = getItemById(id);
    if (item == null) return false;

    return await updateItemCardapio(
      id: id,
      disponivel: !item.disponivel,
    );
  }

  Future<bool> deleteItemCardapio(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await SupabaseConfig.client
          .from('itens_cardapio')
          .delete()
          .eq('id', id);

      _itensCardapio.removeWhere((item) => item.id == id);
      
      return true;
    } catch (e) {
      _error = 'Erro ao deletar item: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addMesa({
    required String numero,
    required String qrToken,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await SupabaseConfig.client
          .from('mesas')
          .insert({
            'numero': numero,
            'qr_token': qrToken,
            'ativo': true,
          })
          .select()
          .single();

      final novaMesa = Mesa.fromJson(response);
      _mesas.add(novaMesa);
      _mesas.sort((a, b) => a.numero.compareTo(b.numero));
      
      return true;
    } catch (e) {
      _error = 'Erro ao adicionar mesa: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String formatPrice(double price) {
    return 'R\$ ${price.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}