import 'package:bazaar/data/models/product_model.dart';

class GetProduct {
  final ProductModel product;

  GetProduct(this.product);

  ProductModel call() {
    return product;
  }
}