import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:barnostri_app/src/features/menu/data/repositories/supabase_menu_repository.dart';
import 'package:barnostri_app/src/features/order/data/repositories/supabase_order_repository.dart';
import 'package:shared_models/shared_models.dart';

class FailingClient extends Fake implements SupabaseClient {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Logger.root.level = Level.ALL;
  });

  test('SupabaseMenuRepository logs error on fetchTables failure', () async {
    final logs = <LogRecord>[];
    final sub = Logger.root.onRecord.listen(logs.add);
    final repo = SupabaseMenuRepository(FailingClient());
    await expectLater(repo.fetchTables(), throwsA(isA<Object>()));
    sub.cancel();
    expect(
      logs.any((r) =>
          r.level == Level.SEVERE &&
          r.message.contains('Erro ao buscar mesas')),
      isTrue,
    );
  });

  test('SupabaseOrderRepository logs error on createOrder failure', () async {
    final logs = <LogRecord>[];
    final sub = Logger.root.onRecord.listen(logs.add);
    final repo = SupabaseOrderRepository(FailingClient());
    final id = await repo.createOrder(
      tableId: '1',
      items: [
        CartItem(
            item: MenuItem(
                id: 'i',
                name: 'x',
                description: null,
                price: 1,
                categoryId: 'c',
                available: true,
                imageUrl: null,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now()),
            quantity: 1)
      ],
      total: 1,
      paymentMethod: 'Pix',
    );
    sub.cancel();
    expect(id, isNull);
    expect(
      logs.any((r) =>
          r.level == Level.SEVERE &&
          r.message.contains('Erro ao criar pedido')),
      isTrue,
    );
  });
}
