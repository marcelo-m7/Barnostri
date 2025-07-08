import 'category_model.dart';

class MenuItem {
  final String id;
  final String name;
  final String? description;
  final double price;
  final String categoryId;
  final bool available;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CategoryModel? category;

  MenuItem({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.categoryId,
    required this.available,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.category,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      categoryId: json['category_id'],
      available: json['available'],
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      category: json['categories'] != null
          ? CategoryModel.fromJson(json['categories'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category_id': categoryId,
      'available': available,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
