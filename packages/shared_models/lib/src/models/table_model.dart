class TableModel {
  final String id;
  final String number;
  final String qrToken;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TableModel({
    required this.id,
    required this.number,
    required this.qrToken,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      id: json['id'],
      number: json['number'],
      qrToken: json['qr_token'],
      active: json['active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'qr_token': qrToken,
      'active': active,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
