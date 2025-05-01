import 'package:bazaar/data/models/cart_model.dart';
import 'package:bazaar/data/models/product_model.dart';
import 'package:bazaar/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  static final CartRepositoryImpl _instance = CartRepositoryImpl._internal();
  factory CartRepositoryImpl() => _instance;
  CartRepositoryImpl._internal();

  CartModel _cart = const CartModel();

  @override
  Future<CartModel> getCart() async {
    return _cart;
  }

  @override
  Future<void> addToCart(ProductModel product) async {
    final items = List<CartItem>.from(_cart.items);
    final index = items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      items[index] = CartItem(product: product, quantity: items[index].quantity + 1);
    } else {
      items.add(CartItem(product: product));
    }
    _cart = CartModel(items: items);
  }

  @override
  Future<void> removeFromCart(int productId) async {
    final items = _cart.items.where((item) => item.product.id != productId).toList();
    _cart = CartModel(items: items);
  }

  @override
  Future<void> updateQuantity(int productId, int quantity) async {
    final items = List<CartItem>.from(_cart.items);
    final index = items.indexWhere((item) => item.product.id == productId);
    if (index >= 0 && quantity > 0) {
      items[index] = CartItem(product: items[index].product, quantity: quantity);
      _cart = CartModel(items: items);
    } else if (index >= 0 && quantity <= 0) {
      items.removeAt(index);
      _cart = CartModel(items: items);
    }
  }

  Future<void> clearCart() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _cart = const CartModel(items: []);
  }
}