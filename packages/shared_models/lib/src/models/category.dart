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
