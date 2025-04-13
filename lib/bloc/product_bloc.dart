

import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/product.dart';
import '../repository/product_repository.dart';

class ProductState {
  final List<Product> products;

  ProductState(this.products);
}

class ProductEvent {

}

class ProductLoadEvent extends ProductEvent {}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc(this.productRepository) : super(ProductState([])) {
    on<ProductLoadEvent>((event, emit) {
      print("------>>>> product Load event call");
      final products = productRepository.getProducts();
      emit(ProductState(products));
    });
  }
}