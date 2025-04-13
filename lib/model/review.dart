// models/review.dart
class Review {
  final int productId;
  final String content;
  final double rating;

  Review({required this.productId, required this.content, required this.rating});
}