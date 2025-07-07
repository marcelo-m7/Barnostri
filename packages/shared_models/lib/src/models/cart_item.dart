import 'item_cardapio.dart';

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
