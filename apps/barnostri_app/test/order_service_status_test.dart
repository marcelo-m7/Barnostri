import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barnostri_app/src/features/order/presentation/controllers/order_service.dart';
import 'package:barnostri_app/src/features/menu/data/repositories/supabase_menu_repository.dart';
import 'package:shared_models/shared_models.dart';

class FakeOrderRepository implements OrderRepository {
  FakeOrderRepository(this.result);

  final bool result;
  String? lastId;
  String? lastStatus;

  @override
  Future<String?> createOrder({
    required String tableId,
    required List<CartItem> items,
    required double total,
    required String paymentMethod,
  }) async => null;

  @override
  Future<bool> updateStatus(String orderId, String newStatus) async {
    lastId = orderId;
    lastStatus = newStatus;
    return result;
  }

  @override
  Future<List<Order>> fetchOrders() async => [];

  @override
  Stream<List<Order>> watchOrders() => const Stream.empty();

  @override
  Stream<Order> watchOrder(String orderId) => const Stream.empty();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OrderService.updateOrderStatus', () {
    test('returns true on successful repository call', () async {
      final container = ProviderContainer();
      final repo = FakeOrderRepository(true);
      final menuRepo = SupabaseMenuRepository(null);
      final service = OrderService(
        container.read,
        repo,
        menuRepo,
        CreateOrderUseCase(repo),
        UpdateOrderStatusUseCase(repo),
      );

      final ok = await service.updateOrderStatus('o1', OrderStatus.ready);

      expect(ok, isTrue);
      expect(repo.lastId, 'o1');
      expect(repo.lastStatus, OrderStatus.ready.displayName);
      expect(service.state.error, isNull);
    });

    test('returns false and sets error when repository fails', () async {
      final container = ProviderContainer();
      final repo = FakeOrderRepository(false);
      final menuRepo = SupabaseMenuRepository(null);
      final service = OrderService(
        container.read,
        repo,
        menuRepo,
        CreateOrderUseCase(repo),
        UpdateOrderStatusUseCase(repo),
      );

      final ok = await service.updateOrderStatus('o2', OrderStatus.canceled);

      expect(ok, isFalse);
      expect(repo.lastId, 'o2');
      expect(repo.lastStatus, OrderStatus.canceled.displayName);
    });
  });
}
