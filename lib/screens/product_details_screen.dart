import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cart_bloc.dart';
import '../model/product.dart';
import 'cart_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, cartState) {
          final quantity = cartState.cartItems[product] ?? 0;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  "Price: \$${product.price}",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 16),
                Text(
                  "Quantity in Cart: $quantity",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<CartBloc>(context).add(
                          UpdateCartItem(product, quantity + 1),
                        );
                      },
                      child: Text("Add to Cart"),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: quantity > 0
                          ? () {
                        BlocProvider.of<CartBloc>(context).add(
                          UpdateCartItem(product, quantity - 1),
                        );
                      }
                          : null,
                      child: Text("Remove from Cart"),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartScreen()),
                    );
                  },
                  child: Text("Go To Cart"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}