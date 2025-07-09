class Dish {
  final String token;
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  Dish({
    required this.token,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      token: json['token'],
      name: json['name'],
      description: json['description'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      imageUrl: json['img'] ?? '',
    );
  }
}