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
