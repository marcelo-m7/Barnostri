import 'package:flutter_test/flutter_test.dart';
import 'package:shared_models/shared_models.dart';

void main() {
  group('Category', () {
    const json = {
      'id': '1',
      'nome': 'Entradas',
      'ordem': 1,
      'ativo': true,
      'created_at': '2024-01-01T00:00:00.000Z',
      'updated_at': '2024-01-02T00:00:00.000Z',
    };

    test('fromJson and toJson', () {
      final categoria = Category.fromJson(json);
      expect(categoria.id, '1');
      expect(categoria.name, 'Entradas');
      expect(categoria.active, true);
      expect(categoria.toJson(), {
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
      'nome': 'Moqueca',
      'descricao': 'Peixe fresco',
      'preco': 45.9,
      'categoria_id': '2',
      'disponivel': true,
      'imagem_url': null,
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
      'numero': '1',
      'qr_token': 'token1',
      'ativo': true,
      'created_at': '2024-01-01T00:00:00.000Z',
      'updated_at': '2024-01-02T00:00:00.000Z',
    };

    test('fromJson and toJson', () {
      final mesa = TableModel.fromJson(json);
      expect(mesa.number, '1');
      expect(mesa.toJson(), {
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
      'nome': 'Admin',
      'email': 'a@a.com',
      'tipo': 'admin',
      'created_at': '2024-01-01T00:00:00.000Z',
      'updated_at': '2024-01-02T00:00:00.000Z',
    };

    test('fromJson and toJson', () {
      final usuario = UserModel.fromJson(json);
      expect(usuario.isAdmin, isTrue);
      expect(usuario.toJson(), {
        'id': 'u1',
        'name': 'Admin',
        'email': 'a@a.com',
        'role': 'admin',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-02T00:00:00.000Z',
      });
    });
  });

  group('OrderItem', () {
    const json = {
      'id': 'ip1',
      'pedido_id': 'p1',
      'item_cardapio_id': 'i1',
      'quantidade': 2,
      'observacao': 'Sem pimenta',
      'preco_unitario': 10.0,
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
      'mesa_id': 't1',
      'status': 'Recebido',
      'total': 20.0,
      'forma_pagamento': 'Pix',
      'pago': false,
      'created_at': '2024-01-01T00:00:00.000Z',
      'updated_at': '2024-01-02T00:00:00.000Z',
      'mesas': {
        'id': 't1',
        'numero': '1',
        'qr_token': 'token1',
        'ativo': true,
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-02T00:00:00.000Z',
      },
      'itens_pedido': [
        {
          'id': 'ip1',
          'pedido_id': 'p1',
          'item_cardapio_id': 'i1',
          'quantidade': 1,
          'observacao': '',
          'preco_unitario': 10.0,
          'created_at': '2024-01-01T00:00:00.000Z',
        },
      ],
    };

    test('fromJson and toJson', () {
      final pedido = Order.fromJson(json);
      expect(pedido.tableId, 't1');
      expect(pedido.items.length, 1);
      expect(pedido.toJson(), {
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
      'pedido_id': 'p1',
      'metodo': 'Pix',
      'valor': 20.0,
      'status': 'pendente',
      'transacao_id': null,
      'created_at': '2024-01-01T00:00:00.000Z',
      'updated_at': '2024-01-02T00:00:00.000Z',
    };

    test('fromJson and toJson', () {
      final pagamento = Payment.fromJson(json);
      expect(pagamento.method, 'Pix');
      expect(pagamento.toJson(), {
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
        categoriaId: 'c1',
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
  });
}
