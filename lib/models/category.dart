class Category {
  final String token;
  final String name;
  final String description;

  Category({
    required this.token,
    required this.name,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      token: json['token'],
      name: json['name'],
      description: json['description'] ?? '',
    );
  }
}