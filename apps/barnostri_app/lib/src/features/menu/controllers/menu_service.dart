import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_models/shared_models.dart';
import '../../../core/repositories.dart';

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
  final MenuRepository _menuRepository;
  MenuService(this._menuRepository) : super(const MenuState());

  Future<void> loadCategorias() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final categorias = await _menuRepository.fetchCategorias();
      state = state.copyWith(categorias: categorias);
    } catch (e) {
      state = state.copyWith(error: 'Erro ao carregar categorias: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loadItensCardapio() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final itens = await _menuRepository.fetchItensCardapio();
      state = state.copyWith(itensCardapio: itens);
    } catch (e) {
      state = state.copyWith(error: 'Erro ao carregar itens do cardápio: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loadMesas() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final mesas = await _menuRepository.fetchMesas();
      state = state.copyWith(mesas: mesas);
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
      final nova = await _menuRepository.addCategoria(nome: nome, ordem: ordem);
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
      final ok = await _menuRepository.updateCategoria(
        id: id,
        nome: nome,
        ordem: ordem,
        ativo: ativo,
      );
      if (ok) {
        await loadCategorias();
      }
      return ok;
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
      final novoItem = await _menuRepository.addItemCardapio(
        nome: nome,
        descricao: descricao,
        preco: preco,
        categoriaId: categoriaId,
        imagemUrl: imagemUrl,
      );
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
      final ok = await _menuRepository.updateItemCardapio(
        id: id,
        nome: nome,
        descricao: descricao,
        preco: preco,
        categoriaId: categoriaId,
        disponivel: disponivel,
        imagemUrl: imagemUrl,
      );
      if (ok) {
        await loadItensCardapio();
      }
      return ok;
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
      final ok = await _menuRepository.deleteItemCardapio(id);
      if (ok) {
        final list = [...state.itensCardapio]
          ..removeWhere((item) => item.id == id);
        state = state.copyWith(itensCardapio: list);
      }
      return ok;
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
      final novaMesa = await _menuRepository.addMesa(
        numero: numero,
        qrToken: qrToken,
      );
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

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final menuServiceProvider = StateNotifierProvider<MenuService, MenuState>((
  ref,
) {
  final menuRepo = ref.watch(menuRepositoryProvider);
  return MenuService(menuRepo);
});
