import 'package:flutter_test/flutter_test.dart';
import 'package:shared_models/shared_models.dart';

void main() {
  group('Categoria', () {
    const json = {
      'id': '1',
      'nome': 'Entradas',
      'ordem': 1,
      'ativo': true,
      'created_at': '2024-01-01T00:00:00.000Z',
      'updated_at': '2024-01-02T00:00:00.000Z',
    };

    test('fromJson and toJson', () {
      final categoria = Categoria.fromJson(json);
      expect(categoria.id, '1');
      expect(categoria.nome, 'Entradas');
      expect(categoria.ativo, true);
      expect(categoria.toJson(), json);
    });
  });

  group('ItemCardapio', () {
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
      final item = ItemCardapio.fromJson(json);
      expect(item.nome, 'Moqueca');
      expect(item.disponivel, isTrue);
      expect(item.toJson(), json);
    });
  });

  group('Mesa', () {
    const json = {
      'id': 't1',
      'numero': '1',
      'qr_token': 'token1',
      'ativo': true,
      'created_at': '2024-01-01T00:00:00.000Z',
      'updated_at': '2024-01-02T00:00:00.000Z',
    };

    test('fromJson and toJson', () {
      final mesa = Mesa.fromJson(json);
      expect(mesa.numero, '1');
      expect(mesa.toJson(), json);
    });
  });

  group('Usuario', () {
    const json = {
      'id': 'u1',
      'nome': 'Admin',
      'email': 'a@a.com',
      'tipo': 'admin',
      'created_at': '2024-01-01T00:00:00.000Z',
      'updated_at': '2024-01-02T00:00:00.000Z',
    };

    test('fromJson and toJson', () {
      final usuario = Usuario.fromJson(json);
      expect(usuario.isAdmin, isTrue);
      expect(usuario.toJson(), json);
    });
  });

  group('ItemPedido', () {
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
      final item = ItemPedido.fromJson(json);
      expect(item.quantidade, 2);
      expect(item.toJson(), json);
    });
  });

  group('Pedido', () {
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
      final pedido = Pedido.fromJson(json);
      expect(pedido.mesaId, 't1');
      expect(pedido.itens.length, 1);
      expect(pedido.toJson(), {
        'id': 'p1',
        'mesa_id': 't1',
        'status': 'Recebido',
        'total': 20.0,
        'forma_pagamento': 'Pix',
        'pago': false,
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-02T00:00:00.000Z',
      });
    });
  });

  group('Pagamento', () {
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
      final pagamento = Pagamento.fromJson(json);
      expect(pagamento.metodo, 'Pix');
      expect(pagamento.toJson(), json);
    });
  });

  group('CartItem', () {
    test('toJson', () {
      final item = ItemCardapio(
        id: 'i1',
        nome: 'Item',
        descricao: null,
        preco: 5.0,
        categoriaId: 'c1',
        disponivel: true,
        imagemUrl: null,
        createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2024-01-02T00:00:00.000Z'),
      );
      final cartItem = CartItem(item: item, quantidade: 2, observacao: 'obs');
      expect(cartItem.toJson(), {
        'id': 'i1',
        'nome': 'Item',
        'preco': 5.0,
        'quantidade': 2,
        'observacao': 'obs',
      });
    });
  });
}
