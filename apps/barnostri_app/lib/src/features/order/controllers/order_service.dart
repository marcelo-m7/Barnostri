import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_models/shared_models.dart';
import '../../../core/repositories.dart';

class OrderState {
  final List<CartItem> cartItems;
  final Mesa? currentMesa;
  final bool isLoading;
  final String? error;

  const OrderState({
    this.cartItems = const [],
    this.currentMesa,
    this.isLoading = false,
    this.error,
  });

  OrderState copyWith({
    List<CartItem>? cartItems,
    Mesa? currentMesa,
    bool? isLoading,
    String? error,
  }) {
    return OrderState(
      cartItems: cartItems ?? this.cartItems,
      currentMesa: currentMesa ?? this.currentMesa,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  double get cartTotal =>
      cartItems.fold(0.0, (total, item) => total + item.subtotal);
  int get cartItemCount =>
      cartItems.fold(0, (count, item) => count + item.quantidade);
}

class OrderService extends StateNotifier<OrderState> {
  final PedidoRepository _pedidoRepository;
  final MenuRepository _menuRepository;
  OrderService(this._pedidoRepository, this._menuRepository)
    : super(const OrderState());

  void setMesa(Mesa mesa) {
    state = state.copyWith(currentMesa: mesa);
  }

  void addToCart(ItemCardapio item, {int quantidade = 1, String? observacao}) {
    final items = [...state.cartItems];
    final existingIndex = items.indexWhere(
      (cartItem) =>
          cartItem.item.id == item.id && cartItem.observacao == observacao,
    );
    if (existingIndex != -1) {
      items[existingIndex].quantidade += quantidade;
    } else {
      items.add(
        CartItem(item: item, quantidade: quantidade, observacao: observacao),
      );
    }
    state = state.copyWith(cartItems: items);
  }

  void removeFromCart(int index) {
    final items = [...state.cartItems];
    if (index >= 0 && index < items.length) {
      items.removeAt(index);
      state = state.copyWith(cartItems: items);
    }
  }

  void updateCartItem(int index, {int? quantidade, String? observacao}) {
    final items = [...state.cartItems];
    if (index >= 0 && index < items.length) {
      final item = items[index];
      if (quantidade != null) item.quantidade = quantidade;
      if (observacao != null) item.observacao = observacao;
      items[index] = item;
      state = state.copyWith(cartItems: items);
    }
  }

  void clearCart() {
    state = state.copyWith(cartItems: []);
  }

  Future<String?> createOrder({required PaymentMethod paymentMethod}) async {
    if (state.currentMesa == null) {
      state = state.copyWith(error: 'Nenhuma mesa selecionada');
      return null;
    }
    if (state.cartItems.isEmpty) {
      state = state.copyWith(error: 'Carrinho está vazio');
      return null;
    }
    state = state.copyWith(isLoading: true, error: null);
    try {
      final itens = state.cartItems
          .map((cartItem) => cartItem.toJson())
          .toList();
      final pedidoId = await _pedidoRepository.criarPedido(
        mesaId: state.currentMesa!.id,
        itens: itens,
        total: state.cartTotal,
        formaPagamento: paymentMethod.displayName,
      );
      if (pedidoId != null) {
        clearCart();
        return pedidoId;
      } else {
        state = state.copyWith(error: 'Erro ao criar pedido');
        return null;
      }
    } catch (e) {
      state = state.copyWith(error: 'Erro ao processar pedido: $e');
      return null;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> updateOrderStatus(String pedidoId, OrderStatus status) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final success = await _pedidoRepository.atualizarStatus(
        pedidoId,
        status.displayName,
      );
      if (!success) {
        state = state.copyWith(error: 'Erro ao atualizar status do pedido');
      }
      return success;
    } catch (e) {
      state = state.copyWith(error: 'Erro ao atualizar status: $e');
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<List<Pedido>> getAllOrders() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await _pedidoRepository.fetchPedidos();
      return data.map((json) => Pedido.fromJson(json)).toList();
    } catch (e) {
      state = state.copyWith(error: 'Erro ao carregar pedidos: $e');
      return [];
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Stream<List<Pedido>> streamOrders() {
    return _pedidoRepository.watchPedidos().map(
      (data) => data.map((json) => Pedido.fromJson(json)).toList(),
    );
  }

  Stream<Pedido> streamOrder(String pedidoId) {
    return _pedidoRepository
        .watchPedido(pedidoId)
        .map((data) => Pedido.fromJson(data));
  }

  Future<Mesa?> getMesaByQrToken(String qrToken) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await _menuRepository.getMesaByQrToken(qrToken);
      if (data != null) {
        final mesa = Mesa.fromJson(data);
        setMesa(mesa);
        return mesa;
      } else {
        state = state.copyWith(error: 'Mesa não encontrada');
        return null;
      }
    } catch (e) {
      state = state.copyWith(error: 'Erro ao buscar mesa: $e');
      return null;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> processPayment({
    required PaymentMethod method,
    required double amount,
  }) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 2));
    final success = true;
    if (!success) {
      state = state.copyWith(error: 'Falha no pagamento. Tente novamente.');
    }
    state = state.copyWith(isLoading: false);
    return success;
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  static String formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  static String getOrderStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.recebido:
        return 'blue';
      case OrderStatus.emPreparo:
        return 'orange';
      case OrderStatus.pronto:
        return 'green';
      case OrderStatus.entregue:
        return 'grey';
      case OrderStatus.cancelado:
        return 'red';
    }
  }
}

final orderServiceProvider = StateNotifierProvider<OrderService, OrderState>((
  ref,
) {
  final pedidoRepo = ref.watch(pedidoRepositoryProvider);
  final menuRepo = ref.watch(menuRepositoryProvider);
  return OrderService(pedidoRepo, menuRepo);
});
