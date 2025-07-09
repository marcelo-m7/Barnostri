import 'package:shared_models/shared_models.dart';

/// Handles creating a new order using the [OrderRepository].
class CreateOrderUseCase {
  final OrderRepository _repository;

  CreateOrderUseCase(this._repository);

  Future<String?> call({
    required String tableId,
    required List<CartItem> items,
    required double total,
    required PaymentMethod paymentMethod,
  }) {
    return _repository.createOrder(
      tableId: tableId,
      items: items,
      total: total,
      paymentMethod: paymentMethod.displayName,
    );
  }
}
