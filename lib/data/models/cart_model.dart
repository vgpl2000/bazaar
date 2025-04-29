import 'package:bazaar/data/models/product_model.dart';
import 'package:equatable/equatable.dart';

class CartModel extends Equatable {
  final List<CartItem> items;

  const CartModel({this.items = const []});

  double get totalPrice => items.fold(0, (sum, item) => sum + item.product.price * item.quantity);

  @override
  List<Object> get props => [items];
}

class CartItem extends Equatable {
  final ProductModel product;
  final int quantity;

  const CartItem({required this.product, this.quantity = 1});

  @override
  List<Object> get props => [product, quantity];
}