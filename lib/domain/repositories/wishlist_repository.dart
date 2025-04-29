import 'package:bazaar/data/models/product_model.dart';
import '../../data/models/wishlist_model.dart';

abstract class WishlistRepository {
  Future<WishlistModel> getWishlist();
  Future<void> addToWishlist(ProductModel product);
  Future<void> removeFromWishlist(int productId);
}