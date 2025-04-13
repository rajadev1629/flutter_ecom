import '../model/review.dart';

class ReviewRepository {
  List<Review> getReview() {
    return [
      Review(productId: 1, content : 'Review for Item 1', rating: 4),
      Review(productId: 2, content : 'Review for Item 2', rating: 4)
    ];
  }
}