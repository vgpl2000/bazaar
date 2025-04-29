import 'package:bazaar/domain/repositories/wishlist_repository.dart';

class RemoveFromWishlist {
  final WishlistRepository repository;

  RemoveFromWishlist(this.repository);

  Future<void> call(int productId) async {
    await repository.removeFromWishlist(productId);
  }
}