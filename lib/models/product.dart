class Product {
  final int? id;
  final String name;
  final String category;
  final int quantity;
  final double price;

  Product({
    this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.price,
  });

  // Convert Product to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'quantity': quantity,
      'price': price,
    };
  }

  // Convert Map to Product
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] == null
          ? null
          : int.tryParse(map['id'].toString()),
      name: map['name']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      quantity: int.tryParse(map['quantity'].toString()) ?? 0,
      price: double.tryParse(map['price'].toString()) ?? 0.0,
    );
  }

  // Copy Product with changed values
  Product copyWith({
    int? id,
    String? name,
    String? category,
    int? quantity,
    double? price,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }
}