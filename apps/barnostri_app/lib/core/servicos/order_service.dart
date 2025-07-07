import 'package:flutter/foundation.dart';
import 'package:shared_models/shared_models.dart';

class OrderService extends ChangeNotifier {
  static final OrderService _instance = OrderService._internal();
  factory OrderService() => _instance;
  OrderService._internal();

  List<CartItem> _cartItems = [];
  Mesa? _currentMesa;
  bool _isLoading = false;
  String? _error;

  List<CartItem> get cartItems => _cartItems;
  Mesa? get currentMesa => _currentMesa;
  bool get isLoading => _isLoading;
  String? get error => _error;

  double get cartTotal => _cartItems.fold(0.0, (total, item) => total + item.subtotal);
  int get cartItemCount => _cartItems.fold(0, (count, item) => count + item.quantidade);

  void setMesa(Mesa mesa) {
    _currentMesa = mesa;
    notifyListeners();
  }

  void addToCart(ItemCardapio item, {int quantidade = 1, String? observacao}) {
    final existingIndex = _cartItems.indexWhere((cartItem) => 
      cartItem.item.id == item.id && cartItem.observacao == observacao);

    if (existingIndex != -1) {
      _cartItems[existingIndex].quantidade += quantidade;
    } else {
      _cartItems.add(CartItem(
        item: item,
        quantidade: quantidade,
        observacao: observacao,
      ));
    }
    notifyListeners();
  }

  void removeFromCart(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
      notifyListeners();
    }
  }

  void updateCartItem(int index, {int? quantidade, String? observacao}) {
    if (index >= 0 && index < _cartItems.length) {
      if (quantidade != null) {
        _cartItems[index].quantidade = quantidade;
      }
      if (observacao != null) {
        _cartItems[index].observacao = observacao;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  Future<String?> createOrder({
    required PaymentMethod paymentMethod,
  }) async {
    if (_currentMesa == null) {
      _error = 'Nenhuma mesa selecionada';
      return null;
    }

    if (_cartItems.isEmpty) {
      _error = 'Carrinho está vazio';
      return null;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final itens = _cartItems.map((cartItem) => {
        'id': cartItem.item.id,
        'nome': cartItem.item.nome,
        'preco': cartItem.item.preco,
        'quantidade': cartItem.quantidade,
        'observacao': cartItem.observacao,
      }).toList();

      final pedidoId = await SupabaseConfig.criarPedido(
        mesaId: _currentMesa!.id,
        itens: itens,
        total: cartTotal,
        formaPagamento: paymentMethod.displayName,
      );

      if (pedidoId != null) {
        clearCart();
        return pedidoId;
      } else {
        _error = 'Erro ao criar pedido';
        return null;
      }
    } catch (e) {
      _error = 'Erro ao processar pedido: $e';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateOrderStatus(String pedidoId, OrderStatus status) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await SupabaseConfig.atualizarStatusPedido(
        pedidoId,
        status.displayName,
      );

      if (!success) {
        _error = 'Erro ao atualizar status do pedido';
      }

      return success;
    } catch (e) {
      _error = 'Erro ao atualizar status: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Pedido>> getAllOrders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await SupabaseConfig.getPedidos();
      final pedidos = data.map((json) => Pedido.fromJson(json)).toList();
      return pedidos;
    } catch (e) {
      _error = 'Erro ao carregar pedidos: $e';
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Stream<List<Pedido>> streamOrders() {
    return SupabaseConfig.streamPedidos().map((data) =>
        data.map((json) => Pedido.fromJson(json)).toList());
  }

  Stream<Pedido> streamOrder(String pedidoId) {
    return SupabaseConfig.streamPedido(pedidoId).map((data) =>
        Pedido.fromJson(data));
  }

  Future<Mesa?> getMesaByQrToken(String qrToken) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await SupabaseConfig.getMesaByQrToken(qrToken);
      if (data != null) {
        final mesa = Mesa.fromJson(data);
        setMesa(mesa);
        return mesa;
      } else {
        _error = 'Mesa não encontrada';
        return null;
      }
    } catch (e) {
      _error = 'Erro ao buscar mesa: $e';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Simulated payment processing
  Future<bool> processPayment({
    required PaymentMethod method,
    required double amount,
  }) async {
    _isLoading = true;
    notifyListeners();

    // Simulate payment processing delay
    await Future.delayed(const Duration(seconds: 2));

    // For MVP, always return success
    // In production, integrate with actual payment providers
    final success = true;

    if (!success) {
      _error = 'Falha no pagamento. Tente novamente.';
    }

    _isLoading = false;
    notifyListeners();

    return success;
  }

  String formatPrice(double price) {
    return 'R\$ ${price.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String getOrderStatusColor(OrderStatus status) {
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

  void clearError() {
    _error = null;
    notifyListeners();
  }
}