import 'menu_item.dart';

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
          json['itens_cardapio'] != null ? ItemCardapio.fromJson(json['itens_cardapio']) : null,
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
