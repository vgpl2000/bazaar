import 'package:bazaar/domain/repositories/cart_repository.dart';

class UpdateCartQuantity {
  final CartRepository repository;

  UpdateCartQuantity(this.repository);

  Future<void> call(int productId, int quantity) async {
    await repository.updateQuantity(productId, quantity);
  }
}