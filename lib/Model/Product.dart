class Product {
  final String name;
  final double price;
  final String imagePath;

  Product({required this.name, required this.price, required this.imagePath});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      price: json['price'].toDouble(),
      imagePath: json['imagePath'] ?? "", // Add imagePath field to the JSON representation
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'imagePath': imagePath,
    };
  }
}