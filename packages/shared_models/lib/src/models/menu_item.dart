import 'category.dart';

class ItemCardapio {
  final String id;
  final String nome;
  final String? descricao;
  final double preco;
  final String categoriaId;
  final bool disponivel;
  final String? imagemUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Categoria? categoria;

  ItemCardapio({
    required this.id,
    required this.nome,
    this.descricao,
    required this.preco,
    required this.categoriaId,
    required this.disponivel,
    this.imagemUrl,
    required this.createdAt,
    required this.updatedAt,
    this.categoria,
  });

  factory ItemCardapio.fromJson(Map<String, dynamic> json) {
    return ItemCardapio(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      preco: (json['preco'] as num).toDouble(),
      categoriaId: json['categoria_id'],
      disponivel: json['disponivel'],
      imagemUrl: json['imagem_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      categoria: json['categorias'] != null
          ? Categoria.fromJson(json['categorias'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
      'categoria_id': categoriaId,
      'disponivel': disponivel,
      'imagem_url': imagemUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
