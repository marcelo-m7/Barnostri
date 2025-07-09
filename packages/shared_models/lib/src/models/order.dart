import 'table_model.dart';
import 'order_item.dart';

class Order {
  final String id;
  final String tableId;
  final String status;
  final double total;
  final String paymentMethod;
  final bool paid;
  final DateTime createdAt;
  final DateTime updatedAt;
  final TableModel? table;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.tableId,
    required this.status,
    required this.total,
    required this.paymentMethod,
    required this.paid,
    required this.createdAt,
    required this.updatedAt,
    this.table,
    this.items = const [],
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      tableId: json['table_id'],
      status: json['status'],
      total: (json['total'] as num).toDouble(),
      paymentMethod: json['payment_method'],
      paid: json['paid'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      table:
          json['tables'] != null ? TableModel.fromJson(json['tables']) : null,
      items: json['order_items'] != null
          ? (json['order_items'] as List)
              .map((item) => OrderItem.fromJson(item))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'table_id': tableId,
      'status': status,
      'total': total,
      'payment_method': paymentMethod,
      'paid': paid,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
