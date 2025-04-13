import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/review.dart';
import '../repository/review_repository.dart';
import 'cart_bloc.dart';

class ReviewState {
  final List<Review> reviews;

  ReviewState({required this.reviews});

  ReviewState copyWith({List<Review>? reviews}) {
    return ReviewState(reviews: reviews ?? this.reviews);
  }
}

// bloc/review_bloc.dart
 class ReviewEvent {}

class AddReview extends ReviewEvent {
  final Review review;

  AddReview(this.review);
}

class UpdateReview extends ReviewEvent {
  final Review updatedReview;

  UpdateReview(this.updatedReview);
}

class ShowReview extends ReviewEvent {

}


class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository reviewRepository;
  final CartBloc cartBloc;
  ReviewBloc(this.reviewRepository, this.cartBloc) : super(ReviewState(reviews: [])) {
    on<AddReview>((event, emit) {
      List<Review> updatedReviews = List<Review>.from(state.reviews)..add(event.review);
      //emit(updatedReviews as ReviewState);
      emit(state.copyWith(reviews: updatedReviews));
    });

    on<UpdateReview>((event, emit) {
      // Update the review
      final updatedReviews = state.reviews.map((review) {
        if (review.productId == event.updatedReview.productId) {
          return event.updatedReview;
        }
        return review;
      }).toList();

      emit(state.copyWith(reviews: updatedReviews));

      // Increase product quantity in CartBloc
      final cartItems = cartBloc.state.cartItems;
      final product = cartItems.keys.firstWhere(
            (p) => p.id == event.updatedReview.productId,
      );
      final currentQuantity = cartItems[product]!;
      cartBloc.add(UpdateCartItem(product, currentQuantity + 1));
        });

    on<ShowReview>((event, emit) {
      print("------>>>> review Load event call");
      final reviews = reviewRepository.getReview();
      emit(ReviewState(reviews: reviews));
    });
  }
}