import 'package:equatable/equatable.dart';

abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object> get props => [];
}

class AddToCart extends ProductDetailEvent {
  final int productId;

  const AddToCart(this.productId);
}

class AddToWishlist extends ProductDetailEvent {
  final int productId;

  const AddToWishlist(this.productId);
}