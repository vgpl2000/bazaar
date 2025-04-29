import 'package:equatable/equatable.dart';
import 'package:bazaar/data/models/product_model.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCart extends CartEvent {}

class AddToCart extends CartEvent {
  final ProductModel product;

  const AddToCart(this.product);
}

class RemoveFromCart extends CartEvent {
  final int productId;

  const RemoveFromCart(this.productId);
}

class UpdateCartQuantity extends CartEvent {
  final int productId;
  final int quantity;

  const UpdateCartQuantity(this.productId, this.quantity);
}