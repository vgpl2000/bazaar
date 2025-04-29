import 'package:bazaar/data/models/product_model.dart';
import 'package:bazaar/domain/repositories/cart_repository.dart';

class AddToCart {
  final CartRepository repository;

  AddToCart(this.repository);

  Future<void> call(ProductModel product) async {
    await repository.addToCart(product);
  }
}