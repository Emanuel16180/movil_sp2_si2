class Product {
  final int id;
  final String name;
  final String description;
  final String size;
  final int stock;
  final double price;
  final String brand;
  final String image;
  final int categoryId;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.size,
    required this.stock,
    required this.price,
    required this.brand,
    required this.image,
    required this.categoryId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      size: json['size'],
      stock: json['stock'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      brand: json['brand'],
      image: json['image'],
      categoryId: json['category'], // se espera solo el ID de categoría
    );
  }
}
