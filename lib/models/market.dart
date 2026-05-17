class Market {
  final String id;
  final String name;
  final String address;
  final double rating;
  final double distance; // в км
  final String closingTime;
  final String imageUrl;
  final bool isOpen;

  Market({
    required this.id,
    required this.name,
    required this.address,
    required this.rating,
    required this.distance,
    required this.closingTime,
    required this.imageUrl,
    this.isOpen = true,
  });
}