import 'package:test/test.dart';
import 'package:shared_models/shared_models.dart';

void main() {
  group('CategoryModel', () {
    const json = {
      'id': '1',
      'name': 'Entradas',
      'sort_order': 1,
      'active': true,
      'created_at': '2024-01-01T00:00:00.000Z',
      'updated_at': '2024-01-02T00:00:00.000Z',
    };

    test('fromJson and toJson', () {
      final category = CategoryModel.fromJson(json);
      expect(category.id, '1');
      expect(category.name, 'Entradas');
      expect(category.active, true);
      expect(category.toJson(), {
        'id': '1',
        'name': 'Entradas',
        'sort_order': 1,
        'active': true,
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-02T00:00:00.000Z',
      });
    });
  });

  group('MenuItem', () {
    const json = {
      'id': '3',
      'name': 'Moqueca',
      'description': 'Peixe fresco',
      'price': 45.9,
      'category_id': '2',
      'available': true,
      'image_url': null,
      'created_at': '2024-01-01T00:00:00.000Z',
      'updated_at': '2024-01-02T00:00:00.000Z',
    };

    test('fromJson and toJson', () {
      final item = MenuItem.fromJson(json);
      expect(item.name, 'Moqueca');
      expect(item.available, isTrue);
      expect(item.toJson(), {
        'id': '3',
        'name': 'Moqueca',
        'description': 'Peixe fresco',
        'price': 45.9,
        'category_id': '2',
        'available': true,
        'image_url': null,
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-02T00:00:00.000Z',
      });
    });
  });

  group('TableModel', () {
    const json = {
      'id': 't1',
      'number': '1',
      'qr_token': 'token1',
      'active': true,
      'created_at': '2024-01-01T00:00:00.000Z',
      'updated_at': '2024-01-02T00:00:00.000Z',
    };

    test('fromJson and toJson', () {
      final table = TableModel.fromJson(json);
      expect(table.number, '1');
      expect(table.toJson(), {
        'id': 't1',
        'number': '1',
        'qr_token': 'token1',
        'active': true,
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-02T00:00:00.000Z',
      });
    });
  });

  group('UserModel', () {
    const json = {
      'id': 'u1',
      'name': 'Admin',
      'email': 'a@a.com',
      'role': 'admin',
      'phone': '+55 11 99999-1234',
      'user_type': 'cliente',
      'store_name': null,
      'created_at': '2024-01-01T00:00:00.000Z',
      'updated_at': '2024-01-02T00:00:00.000Z',
    };

    test('fromJson and toJson', () {
      final user = UserModel.fromJson(json);
      expect(user.isAdmin, isTrue);
      expect(user.toJson(), {
        'id': 'u1',
        'name': 'Admin',
        'email': 'a@a.com',
        'role': 'admin',
        'phone': '+55 11 99999-1234',
        'user_type': 'cliente',
        'store_name': null,
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-02T00:00:00.000Z',
      });
    });
  });

  group('OrderItem', () {
    const json = {
      'id': 'ip1',
      'order_id': 'p1',
      'menu_item_id': 'i1',
      'quantity': 2,
      'note': 'Sem pimenta',
      'unit_price': 10.0,
      'created_at': '2024-01-01T00:00:00.000Z',
    };

    test('fromJson and toJson', () {
      final item = OrderItem.fromJson(json);
      expect(item.quantity, 2);
      expect(item.toJson(), {
        'id': 'ip1',
        'order_id': 'p1',
        'menu_item_id': 'i1',
        'quantity': 2,
        'note': 'Sem pimenta',
        'unit_price': 10.0,
        'created_at': '2024-01-01T00:00:00.000Z',
      });
    });
  });

  group('Order', () {
    final json = {
      'id': 'p1',
      'table_id': 't1',
      'status': 'Recebido',
      'total': 20.0,
      'payment_method': 'Pix',
      'paid': false,
      'created_at': '2024-01-01T00:00:00.000Z',
      'updated_at': '2024-01-02T00:00:00.000Z',
      'tables': {
        'id': 't1',
        'number': '1',
        'qr_token': 'token1',
        'active': true,
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-02T00:00:00.000Z',
      },
      'order_items': [
        {
          'id': 'ip1',
          'order_id': 'p1',
          'menu_item_id': 'i1',
          'quantity': 1,
          'note': '',
          'unit_price': 10.0,
          'created_at': '2024-01-01T00:00:00.000Z',
        },
      ],
    };

    test('fromJson and toJson', () {
      final order = Order.fromJson(json);
      expect(order.tableId, 't1');
      expect(order.items.length, 1);
      expect(order.toJson(), {
        'id': 'p1',
        'table_id': 't1',
        'status': 'Recebido',
        'total': 20.0,
        'payment_method': 'Pix',
        'paid': false,
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-02T00:00:00.000Z',
      });
    });
  });

  group('Payment', () {
    const json = {
      'id': 'pay1',
      'order_id': 'p1',
      'method': 'Pix',
      'amount': 20.0,
      'status': 'pendente',
      'transaction_id': null,
      'created_at': '2024-01-01T00:00:00.000Z',
      'updated_at': '2024-01-02T00:00:00.000Z',
    };

    test('fromJson and toJson', () {
      final payment = Payment.fromJson(json);
      expect(payment.method, 'Pix');
      expect(payment.toJson(), {
        'id': 'pay1',
        'order_id': 'p1',
        'method': 'Pix',
        'amount': 20.0,
        'status': 'pendente',
        'transaction_id': null,
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-02T00:00:00.000Z',
      });
    });
  });

  group('CartItem', () {
    test('toJson', () {
      final item = MenuItem(
        id: 'i1',
        name: 'Item',
        description: null,
        price: 5.0,
        categoryId: 'c1',
        available: true,
        imageUrl: null,
        createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2024-01-02T00:00:00.000Z'),
      );
      final cartItem = CartItem(item: item, quantity: 2, note: 'obs');
      expect(cartItem.toJson(), {
        'id': 'i1',
        'name': 'Item',
        'price': 5.0,
        'quantity': 2,
        'note': 'obs',
      });
    });

    test('subtotal returns expected value', () {
      final item = MenuItem(
        id: 'i1',
        name: 'Item',
        description: null,
        price: 10.0,
        categoryId: 'c1',
        available: true,
        imageUrl: null,
        createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2024-01-02T00:00:00.000Z'),
      );
      final cartItem = CartItem(item: item, quantity: 3);
      expect(cartItem.subtotal, 30.0);
    });
  });

  group('OrderItem', () {
    test('subtotal returns expected value', () {
      final orderItem = OrderItem(
        id: 'o1',
        orderId: 'p1',
        menuItemId: 'i1',
        quantity: 4,
        unitPrice: 5.0,
        createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
      );
      expect(orderItem.subtotal, 20.0);
    });
  });
}
