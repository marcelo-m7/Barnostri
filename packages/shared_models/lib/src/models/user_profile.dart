class UserProfile {
  final String id;
  final String name;
  final String phone;
  final String userType;
  final String? storeName;
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    required this.name,
    required this.phone,
    required this.userType,
    this.storeName,
    required this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      userType: json['user_type'],
      storeName: json['store_name'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'user_type': userType,
      'store_name': storeName,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
