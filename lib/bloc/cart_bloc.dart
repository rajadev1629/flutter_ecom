
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/product.dart';
import '../model/review.dart';

class CartState {
  final Map<Product, int> cartItems;
  final List<Review> reviews;

  CartState({required this.cartItems, required this.reviews});
}


abstract class CartEvent {}

class AddToCart extends CartEvent {
  final Product product;

  AddToCart(this.product);
}

class RemoveFromCart extends CartEvent {
  final Product product;

  RemoveFromCart(this.product);
}

class AddReview extends CartEvent {
  final Review review;

  AddReview(this.review);
}

class UpdateCartItem extends CartEvent {
  final Product product;
  final int quantity; // New quantity

  UpdateCartItem(this.product, this.quantity);
}

/*class UpdateReview extends CartEvent {
  final Review updatedReview;

  UpdateReview(this.updatedReview);
}*/

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState(cartItems: {}, reviews: [])) {
    on<AddToCart>((event, emit) {
      print("------>>>> Add to cart");
      final cartItems = Map<Product, int>.from(state.cartItems);
      cartItems.update(event.product, (quantity) => quantity + 1, ifAbsent: () => 1);
      emit(CartState(cartItems: cartItems, reviews: state.reviews));
    });

    on<RemoveFromCart>((event, emit){
      print("------>>>> remove cart");
      final cartItems = Map<Product, int>.from(state.cartItems);
      cartItems.remove(event.product);
      emit(CartState(cartItems: cartItems, reviews: state.reviews));
    });

    on<AddReview> ((event, emit){
      final review = List<Review>.from(state.reviews)..add(event.review);
      emit(CartState(cartItems: state.cartItems, reviews: review));
    });

    on<UpdateCartItem>((event, emit) {
      print("------>>>> update cart");
      final cartItems = Map<Product, int>.from(state.cartItems);

      // Update quantity or remove product if quantity is 0
      if (event.quantity > 0) {
        cartItems[event.product] = event.quantity;
      } else {
        cartItems.remove(event.product);
      }

      emit(CartState(cartItems: cartItems, reviews: state.reviews));
    });

    /*on<UpdateReview>((event, emit) {
      final reviews = state.reviews.map((review) {
        if (review.productId == event.updatedReview.productId) {
          return event.updatedReview;
        }
        return review;
      }).toList();

      emit(CartState(cartItems: state.cartItems, reviews: reviews));
    });*/
  }



}
