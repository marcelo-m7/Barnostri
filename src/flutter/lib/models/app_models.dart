class Mesa {
  final String id;
  final String numero;
  final String qrToken;
  final bool ativo;
  final DateTime createdAt;
  final DateTime updatedAt;

  Mesa({
    required this.id,
    required this.numero,
    required this.qrToken,
    required this.ativo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Mesa.fromJson(Map<String, dynamic> json) {
    return Mesa(
      id: json['id'],
      numero: json['numero'],
      qrToken: json['qr_token'],
      ativo: json['ativo'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numero': numero,
      'qr_token': qrToken,
      'ativo': ativo,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class Categoria {
  final String id;
  final String nome;
  final int ordem;
  final bool ativo;
  final DateTime createdAt;
  final DateTime updatedAt;

  Categoria({
    required this.id,
    required this.nome,
    required this.ordem,
    required this.ativo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'],
      nome: json['nome'],
      ordem: json['ordem'],
      ativo: json['ativo'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'ordem': ordem,
      'ativo': ativo,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class ItemCardapio {
  final String id;
  final String nome;
  final String? descricao;
  final double preco;
  final String categoriaId;
  final bool disponivel;
  final String? imagemUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Categoria? categoria;

  ItemCardapio({
    required this.id,
    required this.nome,
    this.descricao,
    required this.preco,
    required this.categoriaId,
    required this.disponivel,
    this.imagemUrl,
    required this.createdAt,
    required this.updatedAt,
    this.categoria,
  });

  factory ItemCardapio.fromJson(Map<String, dynamic> json) {
    return ItemCardapio(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      preco: (json['preco'] as num).toDouble(),
      categoriaId: json['categoria_id'],
      disponivel: json['disponivel'],
      imagemUrl: json['imagem_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      categoria:
          json['categorias'] != null
              ? Categoria.fromJson(json['categorias'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
      'categoria_id': categoriaId,
      'disponivel': disponivel,
      'imagem_url': imagemUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class Pedido {
  final String id;
  final String mesaId;
  final String status;
  final double total;
  final String formaPagamento;
  final bool pago;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Mesa? mesa;
  final List<ItemPedido> itens;

  Pedido({
    required this.id,
    required this.mesaId,
    required this.status,
    required this.total,
    required this.formaPagamento,
    required this.pago,
    required this.createdAt,
    required this.updatedAt,
    this.mesa,
    this.itens = const [],
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'],
      mesaId: json['mesa_id'],
      status: json['status'],
      total: (json['total'] as num).toDouble(),
      formaPagamento: json['forma_pagamento'],
      pago: json['pago'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      mesa: json['mesas'] != null ? Mesa.fromJson(json['mesas']) : null,
      itens:
          json['itens_pedido'] != null
              ? (json['itens_pedido'] as List)
                  .map((item) => ItemPedido.fromJson(item))
                  .toList()
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mesa_id': mesaId,
      'status': status,
      'total': total,
      'forma_pagamento': formaPagamento,
      'pago': pago,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class ItemPedido {
  final String id;
  final String pedidoId;
  final String itemCardapioId;
  final int quantidade;
  final String? observacao;
  final double precoUnitario;
  final DateTime createdAt;
  final ItemCardapio? itemCardapio;

  ItemPedido({
    required this.id,
    required this.pedidoId,
    required this.itemCardapioId,
    required this.quantidade,
    this.observacao,
    required this.precoUnitario,
    required this.createdAt,
    this.itemCardapio,
  });

  factory ItemPedido.fromJson(Map<String, dynamic> json) {
    return ItemPedido(
      id: json['id'],
      pedidoId: json['pedido_id'],
      itemCardapioId: json['item_cardapio_id'],
      quantidade: json['quantidade'],
      observacao: json['observacao'],
      precoUnitario: (json['preco_unitario'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      itemCardapio:
          json['itens_cardapio'] != null
              ? ItemCardapio.fromJson(json['itens_cardapio'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pedido_id': pedidoId,
      'item_cardapio_id': itemCardapioId,
      'quantidade': quantidade,
      'observacao': observacao,
      'preco_unitario': precoUnitario,
      'created_at': createdAt.toIso8601String(),
    };
  }

  double get subtotal => precoUnitario * quantidade;
}

class Pagamento {
  final String id;
  final String pedidoId;
  final String metodo;
  final double valor;
  final String status;
  final String? transacaoId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Pagamento({
    required this.id,
    required this.pedidoId,
    required this.metodo,
    required this.valor,
    required this.status,
    this.transacaoId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Pagamento.fromJson(Map<String, dynamic> json) {
    return Pagamento(
      id: json['id'],
      pedidoId: json['pedido_id'],
      metodo: json['metodo'],
      valor: (json['valor'] as num).toDouble(),
      status: json['status'],
      transacaoId: json['transacao_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pedido_id': pedidoId,
      'metodo': metodo,
      'valor': valor,
      'status': status,
      'transacao_id': transacaoId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class Usuario {
  final String id;
  final String nome;
  final String email;
  final String tipo;
  final DateTime createdAt;
  final DateTime updatedAt;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.tipo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      tipo: json['tipo'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'tipo': tipo,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  bool get isAdmin => tipo == 'admin';
}

// Cart item for managing shopping cart
class CartItem {
  final ItemCardapio item;
  int quantidade;
  String? observacao;

  CartItem({required this.item, this.quantidade = 1, this.observacao});

  double get subtotal => item.preco * quantidade;

  Map<String, dynamic> toJson() {
    return {
      'id': item.id,
      'nome': item.nome,
      'preco': item.preco,
      'quantidade': quantidade,
      'observacao': observacao,
    };
  }
}

// Order status enum
enum OrderStatus {
  recebido('Recebido'),
  emPreparo('Em preparo'),
  pronto('Pronto'),
  entregue('Entregue'),
  cancelado('Cancelado');

  const OrderStatus(this.displayName);
  final String displayName;

  static OrderStatus fromString(String status) {
    switch (status) {
      case 'Recebido':
        return OrderStatus.recebido;
      case 'Em preparo':
        return OrderStatus.emPreparo;
      case 'Pronto':
        return OrderStatus.pronto;
      case 'Entregue':
        return OrderStatus.entregue;
      case 'Cancelado':
        return OrderStatus.cancelado;
      default:
        return OrderStatus.recebido;
    }
  }
}

// Payment method enum
enum PaymentMethod {
  pix('Pix'),
  cartao('Cartão'),
  dinheiro('Dinheiro');

  const PaymentMethod(this.displayName);
  final String displayName;

  static PaymentMethod fromString(String method) {
    switch (method) {
      case 'Pix':
        return PaymentMethod.pix;
      case 'Cartão':
        return PaymentMethod.cartao;
      case 'Dinheiro':
        return PaymentMethod.dinheiro;
      default:
        return PaymentMethod.pix;
    }
  }
}
