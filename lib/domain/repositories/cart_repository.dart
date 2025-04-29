import 'package:bazaar/data/models/cart_model.dart';
import 'package:bazaar/data/models/product_model.dart';

abstract class CartRepository {
  Future<CartModel> getCart();
  Future<void> addToCart(ProductModel product);
  Future<void> removeFromCart(int productId);
  Future<void> updateQuantity(int productId, int quantity);
}