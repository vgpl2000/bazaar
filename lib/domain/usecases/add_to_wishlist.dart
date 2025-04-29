import 'package:bazaar/data/models/product_model.dart';
import 'package:bazaar/domain/repositories/wishlist_repository.dart';

class AddToWishlist {
  final WishlistRepository repository;

  AddToWishlist(this.repository);

  Future<void> call(ProductModel product) async {
    await repository.addToWishlist(product);
  }
}