import 'package:bazaar/data/models/wishlist_model.dart';
import 'package:bazaar/data/models/product_model.dart';
import 'package:bazaar/domain/repositories/wishlist_repository.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  static final WishlistRepositoryImpl _instance = WishlistRepositoryImpl._internal();
  factory WishlistRepositoryImpl() => _instance;
  WishlistRepositoryImpl._internal();

  WishlistModel _wishlist = const WishlistModel();

  //Get current wishlist
  @override
  Future<WishlistModel> getWishlist() async {
    return _wishlist;
  }

  // Add item to wishlist
  @override
  Future<void> addToWishlist(ProductModel product) async {
    final items = List<WishlistItem>.from(_wishlist.items);
    if (!items.any((item) => item.product.id == product.id)) {
      items.add(WishlistItem(product: product));
    }
    _wishlist = WishlistModel(items: items);
  }

  // Remove one item from wishlist
  @override
  Future<void> removeFromWishlist(int productId) async {
    final items = _wishlist.items.where((item) => item.product.id != productId).toList();
    _wishlist = WishlistModel(items: items);
  }
}