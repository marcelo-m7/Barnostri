import 'menu_item.dart';

class OrderItem {
  final String id;
  final String orderId;
  final String menuItemId;
  final int quantity;
  final String? note;
  final double unitPrice;
  final DateTime createdAt;
  final MenuItem? menuItem;

  const OrderItem({
    required this.id,
    required this.orderId,
    required this.menuItemId,
    required this.quantity,
    this.note,
    required this.unitPrice,
    required this.createdAt,
    this.menuItem,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderId: json['order_id'],
      menuItemId: json['menu_item_id'],
      quantity: json['quantity'],
      note: json['note'],
      unitPrice: (json['unit_price'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      menuItem: json['menu_items'] != null
          ? MenuItem.fromJson(json['menu_items'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'menu_item_id': menuItemId,
      'quantity': quantity,
      'note': note,
      'unit_price': unitPrice,
      'created_at': createdAt.toIso8601String(),
    };
  }

  double get subtotal => unitPrice * quantity;
}
