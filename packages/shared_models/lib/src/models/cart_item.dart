import 'menu_item.dart';

class CartItem {
  final MenuItem item;
  int quantity;
  String? note;

  CartItem({required this.item, this.quantity = 1, this.note});

  double get subtotal => item.price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'id': item.id,
      'name': item.name,
      'price': item.price,
      'quantity': quantity,
      'note': note,
    };
  }
}
