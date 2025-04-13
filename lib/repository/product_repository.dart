import '../model/product.dart';

class ProductRepository {
  List<Product> getProducts() {
    return [
      Product(id: 1, name: "Product A", price: 10.0, description: "Description A"),
      Product(id: 2, name: "Product B", price: 20.0, description: "Description B"),
    ];
  }
}