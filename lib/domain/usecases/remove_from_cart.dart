import 'package:bazaar/domain/repositories/cart_repository.dart';

class RemoveFromCart {
  final CartRepository repository;

  RemoveFromCart(this.repository);

  Future<void> call(int productId) async {
    await repository.removeFromCart(productId);
  }
}