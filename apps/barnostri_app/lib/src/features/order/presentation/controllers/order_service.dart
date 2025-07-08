import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_models/shared_models.dart';
import '../../../core/repositories.dart';
import '../../domain/usecases/create_order_use_case.dart';
import '../../domain/usecases/update_order_status_use_case.dart';

class OrderState {
  final List<CartItem> cartItems;
  final TableModel? currentTable;
  final bool isLoading;
  final String? error;

  const OrderState({
    this.cartItems = const [],
    this.currentTable,
    this.isLoading = false,
    this.error,
  });

  OrderState copyWith({
    List<CartItem>? cartItems,
    TableModel? currentTable,
    bool? isLoading,
    String? error,
  }) {
    return OrderState(
      cartItems: cartItems ?? this.cartItems,
      currentTable: currentTable ?? this.currentTable,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  double get cartTotal =>
      cartItems.fold(0.0, (total, item) => total + item.subtotal);
  int get cartItemCount =>
      cartItems.fold(0, (count, item) => count + item.quantity);
}

class OrderService extends StateNotifier<OrderState> {
  final OrderRepository _orderRepository;
  final MenuRepository _menuRepository;
  final CreateOrderUseCase _createOrderUseCase;
  final UpdateOrderStatusUseCase _updateOrderStatusUseCase;
  OrderService(
    this._orderRepository,
    this._menuRepository,
    this._createOrderUseCase,
    this._updateOrderStatusUseCase,
  ) : super(const OrderState());

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

  void setTable(TableModel table) {
    state = state.copyWith(currentTable: table);
  }

  void addToCart(MenuItem item, {int quantity = 1, String? note}) {
    final items = [...state.cartItems];
    final existingIndex = items.indexWhere(
      (cartItem) =>
          cartItem.item.id == item.id && cartItem.note == note,
    );
    if (existingIndex != -1) {
      items[existingIndex].quantity += quantity;
    } else {
      items.add(
        CartItem(item: item, quantity: quantity, note: note),
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

  void updateCartItem(int index, {int? quantity, String? note}) {
    final items = [...state.cartItems];
    if (index >= 0 && index < items.length) {
      final item = items[index];
      if (quantity != null) item.quantity = quantity;
      if (note != null) item.note = note;
      items[index] = item;
      state = state.copyWith(cartItems: items);
    }
  }

  void clearCart() {
    state = state.copyWith(cartItems: []);
  }

  Future<String?> createOrder({required PaymentMethod paymentMethod}) async {
    if (state.currentTable == null) {
      state = state.copyWith(error: 'Nenhuma mesa selecionada');
      return null;
    }
    if (state.cartItems.isEmpty) {
      state = state.copyWith(error: 'Carrinho está vazio');
      return null;
    }
    return await _guard<String?>(
      () async {
        final orderId = await _createOrderUseCase(
          tableId: state.currentTable!.id,
          items: state.cartItems,
          total: state.cartTotal,
          paymentMethod: paymentMethod,
        );
        if (orderId != null) {
          clearCart();
          return orderId;
        } else {
          state = state.copyWith(error: 'Erro ao criar pedido');
          return null;
        }
      },
      onError: (e) => 'Erro ao processar pedido: $e',
    );
  }

  Future<bool> updateOrderStatus(String orderId, OrderStatus status) async {
    final success = await _guard<bool>(
      () async {
        final result = await _updateOrderStatusUseCase(orderId, status);
        if (!result) {
          state = state.copyWith(error: 'Erro ao atualizar status do pedido');
        }
        return result;
      },
      onError: (e) => 'Erro ao atualizar status: $e',
    );
    return success ?? false;
  }

  Future<List<Order>> getAllOrders() async {
    final orders = await _guard<List<Order>>(
      () async {
        final result = await _orderRepository.fetchOrders();
        return result;
      },
      onError: (e) => 'Erro ao carregar pedidos: $e',
    );
    return orders ?? [];
  }

  Stream<List<Order>> streamOrders() {
    return _orderRepository.watchOrders();
  }

  Stream<Order> streamOrder(String orderId) {
    return _orderRepository.watchOrder(orderId);
  }

  Future<TableModel?> getTableByQrToken(String qrToken) async {
    return await _guard<TableModel?>(
      () async {
        final table = await _menuRepository.getTableByQrToken(qrToken);
        if (table != null) {
          setTable(table);
          return table;
        } else {
          state = state.copyWith(error: 'Mesa não encontrada');
          return null;
        }
      },
      onError: (e) => 'Erro ao buscar mesa: $e',
    );
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

final orderServiceProvider = StateNotifierProvider<OrderService, OrderState>(
  (
    ref,
  ) {
    final pedidoRepo = ref.watch(orderRepositoryProvider);
    final menuRepo = ref.watch(menuRepositoryProvider);
    final create = CreateOrderUseCase(pedidoRepo);
    final update = UpdateOrderStatusUseCase(pedidoRepo);
    return OrderService(pedidoRepo, menuRepo, create, update);
  },
);
