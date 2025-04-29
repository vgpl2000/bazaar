import 'package:bazaar/data/models/wishlist_model.dart';
import 'package:bazaar/domain/repositories/wishlist_repository.dart';

class GetWishlist {
  final WishlistRepository repository;

  GetWishlist(this.repository);

  Future<WishlistModel> call() async {
    return await repository.getWishlist();
  }
}