import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cart_bloc.dart';
import '../bloc/review_bloc.dart';
import '../model/review.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<CartBloc, CartState>(
              builder: (context, cartState) {
                return ListView(
                  children: [
                    ...cartState.cartItems.keys.map((product) {
                      final quantity = cartState.cartItems[product]!;
                      return ListTile(
                        title: Text(product.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Quantity: $quantity"),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    BlocProvider.of<CartBloc>(context).add(
                                      UpdateCartItem(product, quantity - 1),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    BlocProvider.of<CartBloc>(context).add(
                                      UpdateCartItem(product, quantity + 1),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            BlocProvider.of<CartBloc>(context).add(
                              UpdateCartItem(product, 0),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          ),
          const Divider(),
          Expanded(
            child: BlocBuilder<ReviewBloc, ReviewState>(
              builder: (context, reviewState) {
                print('count::  ${reviewState.reviews.length}');
                return ListView(
                  children: reviewState.reviews.map((review) {
                    return ListTile(
                      title: Text("Review for Product ID: ${review.productId}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Content: ${review.content}"),
                          Text("Rating: ${review.rating}"),
                          ElevatedButton(
                            child: Text("Edit Review"),
                            onPressed: () {
                              _showEditReviewDialog(context, review);
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showEditReviewDialog(BuildContext context, Review review) {
    final TextEditingController contentController = TextEditingController(text: review.content);
    double updatedRating = review.rating;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Review"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: contentController,
                decoration: InputDecoration(labelText: "Review Content"),
              ),
              Slider(
                value: updatedRating,
                min: 0,
                max: 5,
                divisions: 5,
                label: "$updatedRating",
                onChanged: (value) {
                  updatedRating = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                BlocProvider.of<ReviewBloc>(context).add(
                  UpdateReview(
                    Review(
                      productId: review.productId,
                      content: contentController.text,
                      rating: updatedRating,
                    ),
                  ),
                );
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }
}