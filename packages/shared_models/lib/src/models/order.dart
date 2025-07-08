import 'table.dart';
import 'order_item.dart';

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
      itens: json['itens_pedido'] != null
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
