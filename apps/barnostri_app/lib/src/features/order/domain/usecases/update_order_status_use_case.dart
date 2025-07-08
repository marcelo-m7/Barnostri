import 'package:shared_models/shared_models.dart';
import '../../data/order_repository.dart';

/// Updates the status of an existing order.
class UpdateOrderStatusUseCase {
  final OrderRepository _repository;

  UpdateOrderStatusUseCase(this._repository);

  Future<bool> call(String orderId, OrderStatus status) {
    return _repository.updateStatus(orderId, status.displayName);
  }
}
