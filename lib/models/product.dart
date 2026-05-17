class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final String unit;
  final String imageUrl;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.unit,
    required this.imageUrl,
    this.quantity = 0,
  });

  double get totalPrice => price * quantity;
}