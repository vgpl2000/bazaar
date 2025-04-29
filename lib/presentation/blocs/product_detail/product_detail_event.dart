import 'package:bazaar/data/models/product_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object> get props => [];
}

class AddToCart extends ProductDetailEvent {
  final int productId;
  final ProductModel product;
  final BuildContext context;

  const AddToCart(this.productId, this.product, this.context);

  @override
  List<Object> get props => [productId, product, context];
}

class AddToWishlist extends ProductDetailEvent {
  final ProductModel product;

  const AddToWishlist(this.product);

  @override
  List<Object> get props => [product];
}