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
