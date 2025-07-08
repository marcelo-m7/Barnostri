import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_models/shared_models.dart';
import '../../repositories/menu_repository.dart';
import '../../repositories/supabase/supabase_menu_repository.dart';

class MenuState {
  final List<Categoria> categorias;
  final List<ItemCardapio> itensCardapio;
  final List<Mesa> mesas;
  final bool isLoading;
  final String? error;

  const MenuState({
    this.categorias = const [],
    this.itensCardapio = const [],
    this.mesas = const [],
    this.isLoading = false,
    this.error,
  });

  MenuState copyWith({
    List<Categoria>? categorias,
    List<ItemCardapio>? itensCardapio,
    List<Mesa>? mesas,
    bool? isLoading,
    String? error,
  }) {
    return MenuState(
      categorias: categorias ?? this.categorias,
      itensCardapio: itensCardapio ?? this.itensCardapio,
      mesas: mesas ?? this.mesas,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class MenuService extends StateNotifier<MenuState> {
  final MenuRepository _repo = SupabaseMenuRepository();

  MenuService() : super(const MenuState());

  Future<void> loadCategorias() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await _repo.getCategorias();
      state = state.copyWith(
        categorias: data.map((json) => Categoria.fromJson(json)).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: 'Erro ao carregar categorias: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loadItensCardapio() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await _repo.getItensCardapio();
      state = state.copyWith(
        itensCardapio: data.map((json) => ItemCardapio.fromJson(json)).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: 'Erro ao carregar itens do cardápio: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loadMesas() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await _repo.getMesas();
      state = state.copyWith(
        mesas: data.map((json) => Mesa.fromJson(json)).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: 'Erro ao carregar mesas: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loadAll() async {
    await Future.wait([loadCategorias(), loadItensCardapio(), loadMesas()]);
  }

  List<ItemCardapio> getItensByCategoria(String categoriaId) {
    return state.itensCardapio
        .where((item) => item.categoriaId == categoriaId)
        .toList();
  }

  List<ItemCardapio> searchItens(String query) {
    if (query.isEmpty) return state.itensCardapio;
    final lowerQuery = query.toLowerCase();
    return state.itensCardapio.where((item) {
      return item.nome.toLowerCase().contains(lowerQuery) ||
          (item.descricao?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  Categoria? getCategoriaById(String id) {
    try {
      return state.categorias.firstWhere((cat) => cat.id == id);
    } catch (_) {
      return null;
    }
  }

  ItemCardapio? getItemById(String id) {
    try {
      return state.itensCardapio.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  Mesa? getMesaById(String id) {
    try {
      return state.mesas.firstWhere((mesa) => mesa.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<bool> addCategoria({required String nome, required int ordem}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await SupabaseConfig.client
          .from('categorias')
          .insert({'nome': nome, 'ordem': ordem, 'ativo': true})
          .select()
          .single();
      final nova = Categoria.fromJson(response);
      final list = [...state.categorias, nova]
        ..sort((a, b) => a.ordem.compareTo(b.ordem));
      state = state.copyWith(categorias: list);
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Erro ao adicionar categoria: $e');
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> updateCategoria({
    required String id,
    String? nome,
    int? ordem,
    bool? ativo,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final updateData = <String, dynamic>{};
      if (nome != null) updateData['nome'] = nome;
      if (ordem != null) updateData['ordem'] = ordem;
      if (ativo != null) updateData['ativo'] = ativo;
      await SupabaseConfig.client
          .from('categorias')
          .update(updateData)
          .eq('id', id);
      await loadCategorias();
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Erro ao atualizar categoria: $e');
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> addItemCardapio({
    required String nome,
    String? descricao,
    required double preco,
    required String categoriaId,
    String? imagemUrl,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
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
      final list = [...state.itensCardapio, novoItem]
        ..sort((a, b) => a.nome.compareTo(b.nome));
      state = state.copyWith(itensCardapio: list);
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Erro ao adicionar item: $e');
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
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
    state = state.copyWith(isLoading: true, error: null);
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
      await loadItensCardapio();
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Erro ao atualizar item: $e');
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> toggleItemDisponibilidade(String id) async {
    final item = getItemById(id);
    if (item == null) return false;
    return await updateItemCardapio(id: id, disponivel: !item.disponivel);
  }

  Future<bool> deleteItemCardapio(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await SupabaseConfig.client.from('itens_cardapio').delete().eq('id', id);
      final list = [...state.itensCardapio]
        ..removeWhere((item) => item.id == id);
      state = state.copyWith(itensCardapio: list);
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Erro ao deletar item: $e');
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> addMesa({
    required String numero,
    required String qrToken,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await SupabaseConfig.client
          .from('mesas')
          .insert({'numero': numero, 'qr_token': qrToken, 'ativo': true})
          .select()
          .single();
      final novaMesa = Mesa.fromJson(response);
      final list = [...state.mesas, novaMesa]
        ..sort((a, b) => a.numero.compareTo(b.numero));
      state = state.copyWith(mesas: list);
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Erro ao adicionar mesa: $e');
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  static String formatPrice(double price) {
    return 'R\$ ${price.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final menuServiceProvider = StateNotifierProvider<MenuService, MenuState>(
  (ref) => MenuService(),
);
