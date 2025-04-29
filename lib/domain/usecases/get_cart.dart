import 'package:bazaar/data/models/cart_model.dart';
import 'package:bazaar/domain/repositories/cart_repository.dart';

class GetCart {
  final CartRepository repository;

  GetCart(this.repository);

  Future<CartModel> call() async {
    return await repository.getCart();
  }
}