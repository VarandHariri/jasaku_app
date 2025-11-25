class Service {
  final int id;
  final String title;
  final String seller;
  final int price;
  final int sold;
  final double rating;
  final int reviews;
  final bool isVerified;
  final bool hasFastResponse;
  final String? category;

  const Service({
    required this.id,
    required this.title,
    required this.seller,
    required this.price,
    required this.sold,
    required this.rating,
    required this.reviews,
    this.isVerified = true,
    this.hasFastResponse = true,
    this.category,
  });
}
