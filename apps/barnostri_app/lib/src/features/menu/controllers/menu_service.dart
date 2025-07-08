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

  Future<T?> _guard<T>(Future<T> Function() action,
      {String Function(Object)? onError}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      return await action();
    } catch (e) {
      state = state.copyWith(error: onError != null ? onError(e) : e.toString());
      return null;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loadCategorias() async {
    await _guard<void>(
      () async {
        final categorias = await _menuRepository.fetchCategorias();
        state = state.copyWith(categorias: categorias);
      },
      onError: (e) => 'Erro ao carregar categorias: $e',
    );
  }

  Future<void> loadItensCardapio() async {
    await _guard<void>(
      () async {
        final itens = await _menuRepository.fetchItensCardapio();
        state = state.copyWith(itensCardapio: itens);
      },
      onError: (e) => 'Erro ao carregar itens do cardápio: $e',
    );
  }

  Future<void> loadMesas() async {
    await _guard<void>(
      () async {
        final mesas = await _menuRepository.fetchMesas();
        state = state.copyWith(mesas: mesas);
      },
      onError: (e) => 'Erro ao carregar mesas: $e',
    );
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
    final result = await _guard<bool>(
      () async {
        final nova = await _menuRepository.addCategoria(nome: nome, ordem: ordem);
        final list = [...state.categorias, nova]
          ..sort((a, b) => a.ordem.compareTo(b.ordem));
        state = state.copyWith(categorias: list);
        return true;
      },
      onError: (e) => 'Erro ao adicionar categoria: $e',
    );
    return result ?? false;
  }

  Future<bool> updateCategoria({
    required String id,
    String? nome,
    int? ordem,
    bool? ativo,
  }) async {
    final ok = await _guard<bool>(
      () async {
        final result = await _menuRepository.updateCategoria(
          id: id,
          nome: nome,
          ordem: ordem,
          ativo: ativo,
        );
        if (result) {
          await loadCategorias();
        }
        return result;
      },
      onError: (e) => 'Erro ao atualizar categoria: $e',
    );
    return ok ?? false;
  }

  Future<bool> addItemCardapio({
    required String nome,
    String? descricao,
    required double preco,
    required String categoriaId,
    String? imagemUrl,
  }) async {
    final result = await _guard<bool>(
      () async {
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
      },
      onError: (e) => 'Erro ao adicionar item: $e',
    );
    return result ?? false;
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
    final ok = await _guard<bool>(
      () async {
        final result = await _menuRepository.updateItemCardapio(
          id: id,
          nome: nome,
          descricao: descricao,
          preco: preco,
          categoriaId: categoriaId,
          disponivel: disponivel,
          imagemUrl: imagemUrl,
        );
        if (result) {
          await loadItensCardapio();
        }
        return result;
      },
      onError: (e) => 'Erro ao atualizar item: $e',
    );
    return ok ?? false;
  }

  Future<bool> toggleItemDisponibilidade(String id) async {
    final item = getItemById(id);
    if (item == null) return false;
    return await updateItemCardapio(id: id, disponivel: !item.disponivel);
  }

  Future<bool> deleteItemCardapio(String id) async {
    final ok = await _guard<bool>(
      () async {
        final success = await _menuRepository.deleteItemCardapio(id);
        if (success) {
          final list = [...state.itensCardapio]
            ..removeWhere((item) => item.id == id);
          state = state.copyWith(itensCardapio: list);
        }
        return success;
      },
      onError: (e) => 'Erro ao deletar item: $e',
    );
    return ok ?? false;
  }

  Future<bool> addMesa({
    required String numero,
    required String qrToken,
  }) async {
    final result = await _guard<bool>(
      () async {
        final novaMesa = await _menuRepository.addMesa(
          numero: numero,
          qrToken: qrToken,
        );
        final list = [...state.mesas, novaMesa]
          ..sort((a, b) => a.numero.compareTo(b.numero));
        state = state.copyWith(mesas: list);
        return true;
      },
      onError: (e) => 'Erro ao adicionar mesa: $e',
    );
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
  return MenuService(menuRepo);
});
